extends Node2D

var manager: FloorManager = FloorManager.new(self)

@onready var camera = $Camera
@onready var floorplan_ui = $FloorplanUi

var placeable = preload("res:///scenes/placeable/placeable.tscn")

func _ready() -> void:
	Globals.set_camera(camera)
	
	floorplan_ui.manager = manager

	#var factory = Placeable.create_building(Buildings.CONSTRUCTOR)
	#factory.position = Vector2(8 * Globals.PIXELS_PER_METER, 8 * Globals.PIXELS_PER_METER)
	#factory.building_input_event.connect(_on_factory_building_input_event)
	#add_child(factory)
	#
	#factory = Placeable.create_building(Buildings.ASSEMBLER)
	#factory.position = Vector2(19 * Globals.PIXELS_PER_METER, 8 * Globals.PIXELS_PER_METER)
	#factory.building_input_event.connect(_on_factory_building_input_event)
	#add_child(factory)
	#
	#factory = Placeable.create_building(Buildings.MERGER)
	#factory.position = Vector2(10 * Globals.PIXELS_PER_METER, 2 * Globals.PIXELS_PER_METER)
	#factory.building_input_event.connect(_on_factory_building_input_event)
	#add_child(factory)

#func _on_floorplan_ui_selection_dragging(position: Vector2, size: Vector2) -> void:
	#var world_position = (position - camera.position) * camera.zoom.x
	#var world_size = size * camera.zoom.x
	#
	#var space = get_world_2d().direct_space_state
	#var query = PhysicsShapeQueryParameters2D.new()
	#query.shape = RectangleShape2D.new()
	#query.shape.extents = world_size / 2
	#query.transform = Transform2D(0, world_position + (world_size / 2))
	#query.collision_mask = 2
	#query.collide_with_areas = true
	#var selected_items = space.intersect_shape(query)
	#for selected_index in range(0, selected_items.size()):
		#print(selected_index + 1, "> ", selected_items[selected_index].collider.building_type)

func _on_factory_building_input_event(viewport: Node, event: InputEvent, building: Placeable) -> void:
	pass

func _on_camera_panning(delta: Vector2) -> void:
	floorplan_ui.redraw_grid(camera.position, camera.zoom.x)

func _on_camera_zooming(percentage: float) -> void:
	floorplan_ui.redraw_grid(camera.position, camera.zoom.x)
