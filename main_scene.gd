extends Node2D

@export var factory_scene: PackedScene

@onready var ui = $Ui
@onready var camera = $Camera
@onready var background = $Camera/Background

func _ready() -> void:
	Globals.set_camera(camera)
	camera.panning.connect(_on_camera_panning)
	camera.zooming_in.connect(_on_camera_zooming)
	camera.zooming_out.connect(_on_camera_zooming)

	ui.selection_dragging.connect(_on_ui_selection_dragging)

	var factory = factory_scene.instantiate()
	factory.position = Vector2(5 * Globals.PIXELS_PER_METER, 10 * Globals.PIXELS_PER_METER)
	factory.building_width = 8
	factory.building_depth = 10
	factory.building_name = "Constructor"
	factory.input_event.connect(_on_factory_building_input_event)
	add_child(factory)
	
	factory = factory_scene.instantiate()
	factory.position = Vector2(15 * Globals.PIXELS_PER_METER, 10 * Globals.PIXELS_PER_METER)
	factory.building_width = 8
	factory.building_depth = 10
	factory.building_name = "Constructor"
	factory.input_event.connect(_on_factory_building_input_event)
	add_child(factory)

func _on_ui_selection_dragging(position: Vector2, size: Vector2):
	var world_position = (position - camera.position) * camera.zoom.x
	var world_size = size * camera.zoom.x
	
	var space = get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	query.shape = RectangleShape2D.new()
	query.shape.extents = world_size / 2
	query.transform = Transform2D()
	query.transform.origin = world_position + (world_size / 2)
	query.collision_mask = 2
	var selected = space.intersect_shape(query)
	print("Selected: ", selected)

func _on_factory_building_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (event.is_action_pressed("select")):
		print("Building selected")

func _on_camera_panning() -> void:
	background.redraw_grid(camera.position, camera.zoom.x)
	
func _on_camera_zooming() -> void:
	background.redraw_grid(camera.position, camera.zoom.x)
