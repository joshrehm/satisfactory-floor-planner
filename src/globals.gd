extends Node

const PIXELS_PER_METER = 32

var _camera: Camera2D;

func set_camera(camera: Camera2D) -> void:
	_camera = camera

func camera_position() -> Vector2:
	return _camera.position

func camera_zoom() -> float:
	return _camera.zoom.x	
