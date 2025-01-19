extends Area2D

var building_type: String : 
	get: return building_type

var building_position: Vector2 : 
	set(value):
		building_position = value
		if (is_node_ready()):
			position = building_position * Globals.PIXELS_PER_METER
	get: return building_position

var building_size: Vector2 :
	get: return building_size

@onready var building_image = $BuildingSprite
@onready var building_label = $BuildingSprite/BuildingLabel
@onready var collision = $CollisionBox

func initialize(type: String, position: Vector2, size: Vector2) -> void:
	building_type = type
	building_position = position
	building_size = size

func _ready() -> void:
	building_label.text = building_type
	
	position = building_position * Globals.PIXELS_PER_METER
	building_image.size = building_size * Globals.PIXELS_PER_METER
	
	collision.position = building_image.size / 2.0
	collision.shape.set_size(building_image.size)
