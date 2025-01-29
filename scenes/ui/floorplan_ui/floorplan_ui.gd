extends CanvasLayer

signal selection_dragging(position: Vector2, size: Vector2)

var manager: FloorManager
var ghost: Placeable
var is_new: bool
var old_position: Vector2

@onready var background = $Background
@onready var selection_box = $SelectionBox

func redraw_grid(camera_position: Vector2, camera_zoom: float) -> void:
	background.redraw_grid(camera_position, camera_zoom)	

func _set_ghost(building_resource: BuildingResource, destroy: bool):
	if (destroy):
		manager.destroy_building(ghost)

	if (building_resource):
		var position = (get_viewport().get_mouse_position() - Globals.camera_position()) / Globals.camera_zoom()
		ghost = manager.add_building(building_resource)
		ghost.position = position
	else:
		ghost = null

func _input(event: InputEvent) -> void:
	if (ghost):
		if (event.is_action_pressed("select")):
			get_viewport().set_input_as_handled()
			if (is_new):
				ghost.placeable_input_event.connect(_on_placeable_input_event)
				_set_ghost(ghost.building, false)
			else:
				_set_ghost(null, false)
		elif (event.is_action_pressed("back")):
			get_viewport().set_input_as_handled()
			if (!is_new):
				ghost.position = old_position
			_set_ghost(null, is_new)

	#if (event.is_action_pressed("select")):
		#var position = get_viewport().get_mouse_position()
		#print("Start select", position)
#
		#selection_box.position = position
		#selection_box.size = Vector2(0, 0)
		#selection_box.visible = true
	#elif (event.is_action_released("select")):
		#print("End select")
		#selection_box.visible = false
	#elif (event is InputEventMouseMotion and selection_box.visible):
		#var position = get_viewport().get_mouse_position()
		#var size = position - selection_box.position
		#selection_box.size = size
		#selection_dragging.emit(selection_box.position, size)

func _unhandled_input(event: InputEvent) -> void:
	if (ghost and event is InputEventMouseMotion):
		var building_size = ghost.building.get_building_size()
		var position = ((Globals.camera_position() * Globals.camera_zoom()) + event.position) / Globals.camera_zoom()

		position = floor(position / Globals.PIXELS_PER_METER) * Globals.PIXELS_PER_METER
		position.x -= building_size.x / 2
		position.y -= building_size.y / 2

		ghost.position = position

func _on_placeable_input_event(view: Viewport, event: InputEvent, placeable: Placeable):
	if (event.is_action_pressed("select")):
		is_new = false
		ghost = placeable
		old_position = ghost.position

func _on_popup_about_to_popup() -> void:
	_set_ghost(null, is_new)
	
func _on_logistics_id_pressed(id: int) -> void:
	var building_resource: BuildingResource
	match id:
		0: building_resource = Buildings.MERGER
		1: building_resource = Buildings.PROGRAMMABLE_SPLITTER
		2: building_resource = Buildings.SMART_SPLITTER
		3: building_resource = Buildings.SPLITTER

	if (building_resource):
		is_new = true
		_set_ghost(building_resource, false)
		get_viewport().set_input_as_handled()

func _on_organization_id_pressed(id: int) -> void:
	var building_resource: BuildingResource
	match id:
		0: building_resource = Buildings.DIMENSIONAL_DEPOT_UPLOADER
		1: building_resource = Buildings.FLUID_BUFFER
		2: building_resource = Buildings.INDUSTRIAL_FLUID_BUFFER
		3: building_resource = Buildings.INDUSTRIAL_STORAGE_CONTAINER
		4: building_resource = Buildings.STORAGE_CONTAINER

	if (building_resource):
		is_new = true
		_set_ghost(building_resource, false)
		get_viewport().set_input_as_handled()

func _on_power_id_pressed(id: int) -> void:
	var building_resource: BuildingResource
	match id:
		0: building_resource = Buildings.ALIEN_POWER_AUGMENTER
		1: building_resource = Buildings.BIOMASS_BURNER
		2: building_resource = Buildings.COAL_POWERED_GENERATOR
		3: building_resource = Buildings.FUEL_POWERED_GENERATOR
		4: building_resource = Buildings.NUCLEAR_POWER_PLANT

	if (building_resource):
		is_new = true
		_set_ghost(building_resource, false)
		get_viewport().set_input_as_handled()

func _on_production_id_pressed(id: int) -> void:
	var building_resource: BuildingResource
	match id:
		0: building_resource = Buildings.ASSEMBLER
		1: building_resource = Buildings.BLENDER
		2: building_resource = Buildings.CONSTRUCTOR
		3: building_resource = Buildings.CONVERTER
		4: building_resource = Buildings.FOUNDRY
		5: building_resource = Buildings.MANUFACTURER
		6: building_resource = Buildings.PACKAGER
		7: building_resource = Buildings.PARTICLE_ACCELERATOR
		8: building_resource = Buildings.QUANTUM_ENCODER
		9: building_resource = Buildings.REFINERY
		10: building_resource = Buildings.SMELTER

	if (building_resource):
		is_new = true
		_set_ghost(building_resource, false)
		get_viewport().set_input_as_handled()

func _on_special_id_pressed(id: int) -> void:
	var building_resource: BuildingResource
	match id:
		0: building_resource = Buildings.AWESOME_SHOP
		1: building_resource = Buildings.AWESOME_SINK
		2: building_resource = Buildings.BLUEPRINT_DESIGNER_MK1
		3: building_resource = Buildings.BLUEPRINT_DESIGNER_MK2
		4: building_resource = Buildings.BLUEPRINT_DESIGNER_MK3
		5: building_resource = Buildings.CRAFTING_BENCH
		6: building_resource = Buildings.EQUIPMENT_WORKSHOP
		7: building_resource = Buildings.HUB
		8: building_resource = Buildings.MAM
		9: building_resource = Buildings.SPACE_ELEVATOR

	if (building_resource):
		is_new = true
		_set_ghost(building_resource, false)
		get_viewport().set_input_as_handled()

func _on_transportation_id_pressed(id: int) -> void:
	var building_resource: BuildingResource
	match id:
		0: building_resource = Buildings.DRONE_PORT
		1: building_resource = Buildings.EMPTY_PLATFORM
		2: building_resource = Buildings.FREIGHT_PLATFORM
		3: building_resource = Buildings.TRAIN_STATION
		4: building_resource = Buildings.TRUCK_STATION

	if (building_resource):
		is_new = true
		_set_ghost(building_resource, false)
		get_viewport().set_input_as_handled()
