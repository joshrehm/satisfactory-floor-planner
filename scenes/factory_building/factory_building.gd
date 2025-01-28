extends Area2D

@export var building: BuildingResource
@onready var building_image = $BuildingSprite
@onready var building_label = $BuildingSprite/BuildingLabel
@onready var collision = $CollisionBox

func _ready() -> void:
	building_label.text = building.resource_name
	building_image.size = building.get_building_size()
	# TODO: This probably isn't appropriate for custom collision shapes, but we'll worry about that
	#       if we run into one.
	collision.position = building.get_building_size() / 2.0
	collision.shape = building.get_collision_shape()
