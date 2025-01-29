extends Area2D
class_name Placeable

@export var tag: String

signal placeable_input_event(viewport: Node, event: InputEvent, building: Placeable)

const scene: PackedScene = preload("res://scenes/placeable/placeable.tscn")

var building: BuildingResource

@onready var building_image = $BuildingSprite
@onready var building_label = $BuildingSprite/BuildingLabel
@onready var collision = $CollisionBox

static func create_building(resource: BuildingResource):
	var instance = scene.instantiate()
	instance.building = resource
	return instance

func _ready() -> void:
	building_label.text = building.resource_name
	building_image.size = building.get_building_size()
	# TODO: This probably isn't appropriate for custom collision shapes, but we'll worry about that
	#       if we run into one.
	collision.position = building.get_building_size() / 2.0
	collision.shape = building.get_collision_shape()

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	placeable_input_event.emit(viewport, event, self)
