extends Resource

class_name BuildingResource

@export var building_type: String
@export var building_icon: Texture2D

@export var building_width: float: set = _set_building_width
@export var building_depth: float: set = _set_building_depth
@export var building_height: float

@export var collision_shape: Shape2D : set = _set_collision_shape, get = get_collision_shape

var default_shape: Shape2D = RectangleShape2D.new()

func get_collision_shape() -> Shape2D:
	if (collision_shape == null):
		return default_shape

	return collision_shape

func get_building_size() -> Vector2:
	return Vector2(building_width * Globals.PIXELS_PER_METER, building_depth * Globals.PIXELS_PER_METER)

func _set_building_width(width: float) -> void:
	building_width = width
	_update_collision()
	
func _set_building_depth(depth: float) -> void:
	building_depth = depth
	_update_collision()

func _set_collision_shape(shape: Shape2D):
	collision_shape = shape

func _update_collision() -> void:
	if (collision_shape == null):
		return
	default_shape.set_size(Vector2(building_width * Globals.PIXELS_PER_METER,
								  building_depth * Globals.PIXELS_PER_METER))
