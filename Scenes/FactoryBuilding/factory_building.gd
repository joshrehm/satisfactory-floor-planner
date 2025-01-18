extends Area2D

signal selected
signal deselected

@export var building_width: float
@export var building_depth: float
@export var building_height: float
@export var building_name: String

@onready var factory_image = $FactorySprite
@onready var factory_label = $FactorySprite/FactoryLabel
@onready var collision = $CollisionBox

func factory_name() -> String:
	return factory_label.text

func _ready() -> void:
	var pixels_width = building_width * Globals.PIXELS_PER_METER
	var pixels_depth = building_depth * Globals.PIXELS_PER_METER

	factory_label.text = building_name

	factory_image.position = Vector2(0, 0)
	factory_image.size.x = pixels_width
	factory_image.size.y = pixels_depth

	# Collision boxes are centered around their origin, not top left like Area2D
	collision.position = Vector2(pixels_width / 2, pixels_depth / 2)
	collision.shape.set_size(Vector2(pixels_width, pixels_depth))

	print("Factory: ", position, " - ", factory_image.size)
