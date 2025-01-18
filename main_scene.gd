extends Node2D

@export var factory_scene: PackedScene

@onready var camera = $Camera
@onready var floorplan_ui = $FloorplanUi

func _ready() -> void:
	Globals.set_camera(camera)

	var factory = factory_scene.instantiate()
	# TODO: building_x, building_y or building_position and building_size in meters
	#       that the FactoryBuilding scales automatically
	factory.position = Vector2(5 * Globals.PIXELS_PER_METER, 4 * Globals.PIXELS_PER_METER)
	factory.building_width = 8
	factory.building_depth = 10
	factory.building_name = "Constructor"
	factory.input_event.connect(_on_factory_building_input_event)
	add_child(factory)
	
	factory = factory_scene.instantiate()
	factory.position = Vector2(15 * Globals.PIXELS_PER_METER, 4 * Globals.PIXELS_PER_METER)
	factory.building_width = 8
	factory.building_depth = 10
	factory.building_name = "Constructor"
	factory.input_event.connect(_on_factory_building_input_event)
	add_child(factory)

func _on_floorplan_ui_selection_dragging(position: Vector2, size: Vector2) -> void:
	var world_position = (position - camera.position) * camera.zoom.x
	var world_size = size * camera.zoom.x
	
	var space = get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	query.shape = RectangleShape2D.new()
	query.shape.extents = world_size / 2
	query.transform = Transform2D(0, world_position + (world_size / 2))
	query.collision_mask = 2
	query.collide_with_areas = true
	var selected_items = space.intersect_shape(query)
	for selected_item in selected_items:
		print("Selected ", selected_item.collider.factory_name())
	#print("Selected: ", selected)

func _on_factory_building_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (event.is_action_pressed("select")):
		print("Building selected")

func _on_camera_panning() -> void:
	floorplan_ui.redraw_grid(camera.position, camera.zoom.x)

func _on_camera_zooming(percentage: float) -> void:
	floorplan_ui.redraw_grid(camera.position, camera.zoom.x)
