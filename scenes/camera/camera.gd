extends Camera2D

const MAX_ZOOM: float = 6.0     # Up to 600%
const MIN_ZOOM: float = 0.01    # Down to 1%

signal zooming_in(percentage: float)
signal zooming_out(percentage: float)

signal panning_started(position: Vector2)
signal panning_finished(position: Vector2)
signal panning(delta: Vector2)

var is_panning: bool = false    # True if we're panning, false otherwise
var last_pan_position: Vector2  # The last position we calculated panning distance
var zoom_speed: float = 0.2     # The rate at which we can zoom in or out

func zoom_in(factor: float) -> void:
	_apply_zoom(factor)
	
func zoom_out(factor: float) -> void:
	_apply_zoom(-factor)

# Set the zoom level as a percentage (e.g. 56 would be 56%, 5.6 would be 5.6%).
# Range is automatically clamped to MIN_ZOOM and MAX_ZOOM.
func set_zoom_percentage(percentage: float) -> void:
	zoom = Vector2(percentage / 100.0, percentage / 100.0).clampf(MIN_ZOOM, MAX_ZOOM)

# Applies the specified zoom delta. Note that the camera is adjusted so that the
# camera zooms towards or away from the mouse cursor.
func _apply_zoom(delta_zoom: float) -> void:
	# We grab the current world mouse position so we can zoom towards or away
	# from the mouse cursor
	var start_mouse_position = get_global_mouse_position()

	zoom += Vector2(delta_zoom, delta_zoom)
	zoom = zoom.clampf(MIN_ZOOM, MAX_ZOOM)
	
	# Move the camera towards the mouse cursor
	position -= (get_global_mouse_position() - start_mouse_position)
	
	if delta_zoom > 0:
		zooming_in.emit(zoom.x * 100.0)
	else:
		zooming_out.emit(zoom.x + 100.0)

func _input(event: InputEvent) -> void:
	if (event is InputEventMouseMotion and Input.is_action_pressed("pan_camera")):
		if (!is_panning):
			is_panning = true
			last_pan_position = event.position
			panning_started.emit(event.position)
		else:
			var mouse_position = get_viewport().get_mouse_position()
			var delta = (last_pan_position - mouse_position) / zoom
			last_pan_position = mouse_position

			position += delta
			panning.emit(delta)

	if event.is_action_released("pan_camera"):
		is_panning = false
		panning_finished.emit(event.position)
	elif event.is_action_pressed("zoom_in"):
		_apply_zoom(zoom_speed)
	elif event.is_action_pressed("zoom_out"):
		_apply_zoom(-zoom_speed)
