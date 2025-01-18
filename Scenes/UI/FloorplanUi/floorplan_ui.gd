extends CanvasLayer

signal selection_dragging(position: Vector2, size: Vector2)
	
@onready var background = $Background
@onready var selection_box = $SelectionBox

func redraw_grid(camera_position: Vector2, camera_zoom: float) -> void:
	background.redraw_grid(camera_position, camera_zoom)	

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("select")):
		var position = get_viewport().get_mouse_position()
		print("Start select", position)

		selection_box.position = position
		selection_box.size = Vector2(0, 0)
		selection_box.visible = true
	elif (event.is_action_released("select")):
		print("End select")
		selection_box.visible = false
	elif (event is InputEventMouseMotion and selection_box.visible):
		var position = get_viewport().get_mouse_position()
		var size = position - selection_box.position
		selection_box.size = size
		selection_dragging.emit(selection_box.position, size)
