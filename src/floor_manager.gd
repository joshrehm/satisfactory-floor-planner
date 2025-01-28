class_name FloorManager

var main_scene: Object

func _init(scene: Object) -> void:
	main_scene = scene

func create_building() -> FactoryBuilding:
	return FactoryBuilding.new()
