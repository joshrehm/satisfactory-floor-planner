class_name FloorManager

var main_scene: Object

func _init(scene: Object) -> void:
	main_scene = scene

func add_building(building_resource: BuildingResource) -> Placeable:
	var building = Placeable.create_building(building_resource)
	main_scene.add_child(building)
	return building

func destroy_building(building: Placeable) -> void:
	main_scene.remove_child(building)
