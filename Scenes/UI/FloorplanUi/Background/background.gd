extends CanvasLayer

@export var foundation_size:        = 8.0  # Foundation grid
@export var snap_size:              = 2    # Snapping grid
@export var foundation_grid_color:  = Color(0.5, 0.5, 0.5)
@export var foundation_grid_weight: = 2
@export var snap_grid_color:        = Color(0.3, 0.3, 0.3)
@export var snap_grid_weight:       = 1

var camera_position: = Vector2(0, 0)
var zoom_level: = 1.0

@onready var background_renderer = $BackgroundRenderer

func redraw_grid(camera_position: Vector2, zoom_level: float) -> void:
	self.camera_position = camera_position
	self.zoom_level = zoom_level
	background_renderer.queue_redraw()

func _on_background_renderer_draw() -> void:
	# Draw the blueprint background
	var origin = Vector2.ZERO
	var size = background_renderer.get_viewport_rect().size
	background_renderer.draw_rect(Rect2(origin, size), Color8(0x00, 0x3b, 0x6f))

	# Calculate our foundation grid size and grid position in world coordinates
	var foundation_grid_pixels = (foundation_size * Globals.PIXELS_PER_METER)
	var snap_grid_pixels = (snap_size * Globals.PIXELS_PER_METER)

	var left_world = floor(camera_position.x / foundation_grid_pixels) * foundation_grid_pixels
	var top_world = floor(camera_position.y / foundation_grid_pixels) * foundation_grid_pixels

	# Convert the grid location to screen coordinates
	var left = (left_world - camera_position.x) * zoom_level
	var top = (top_world - camera_position.y) * zoom_level
	
	# Render the grid
	while left < size.x:
		var current_x = left + snap_grid_pixels * zoom_level
		while current_x < size.x and current_x < left + foundation_grid_pixels * zoom_level:
			background_renderer.draw_dashed_line(Vector2(current_x, 0), Vector2(current_x, size.y), snap_grid_color, snap_grid_weight, 4)
			current_x += snap_grid_pixels * zoom_level
		background_renderer.draw_line(Vector2(left, 0), Vector2(left, size.y), foundation_grid_color, foundation_grid_weight)
		left += foundation_grid_pixels * zoom_level

	while top < size.y:
		var current_y = top + snap_grid_pixels * zoom_level
		while current_y < size.y and current_y < top + foundation_grid_pixels * zoom_level:
			background_renderer.draw_dashed_line(Vector2(0, current_y), Vector2(size.x, current_y), snap_grid_color, snap_grid_weight, 4)
			current_y += snap_grid_pixels * zoom_level
		background_renderer.draw_line(Vector2(0, top), Vector2(size.x, top), foundation_grid_color, foundation_grid_weight)
		top += foundation_grid_pixels * zoom_level
