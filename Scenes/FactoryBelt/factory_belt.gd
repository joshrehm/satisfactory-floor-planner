extends Node2D

# Constants
const RECT_WIDTH: float = Globals.PIXELS_PER_METER  # Width of the belt rectangle in pixels

# State
var belt_segments: Array = []  # Array of { "anchor": Vector2, "vector": Vector2 }
var current_anchor: Vector2 = Vector2.ZERO
var is_drawing: bool = false

# Input Handling
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if not is_drawing:
				# Start drawing a new belt
				is_drawing = true
				current_anchor = event.position
			else:
				# Place the next anchor point and add a segment
				add_segment(event.position)

	elif event is InputEventMouseMotion and is_drawing:
		# Redraw to update the dynamic preview
		queue_redraw()

# Add a segment to the belt
func add_segment(next_anchor: Vector2) -> void:
	var direction = (next_anchor - current_anchor).normalized()
	var distance = current_anchor.distance_to(next_anchor)

	# Add the segment as an anchor and vector
	belt_segments.append({
		"anchor": current_anchor,
		"vector": direction * distance
	})

	# Update the anchor for the next segment
	current_anchor = next_anchor
	queue_redraw()

# Draw the belt
func _draw() -> void:
	# Draw finalized segments
	for segment in belt_segments:
		draw_belt_segment(segment["anchor"], segment["vector"])

	# Draw the dynamic segment
	if is_drawing:
		var mouse_position = get_viewport().get_mouse_position()
		var direction = (mouse_position - current_anchor).normalized()
		var distance = current_anchor.distance_to(mouse_position)
		draw_belt_segment(current_anchor, direction * distance)

# Helper function to draw a single belt segment
func draw_belt_segment(anchor: Vector2, vector: Vector2) -> void:
	var length = vector.length()
	var angle = vector.angle()

	# Calculate the rectangle's corners in local space
	var half_width = RECT_WIDTH / 2
	var top_left = Vector2(0, -half_width)
	var top_right = Vector2(0, half_width)
	var bottom_left = Vector2(length, -half_width)
	var bottom_right = Vector2(length, half_width)

	# Create the transformation matrix
	var transform = Transform2D(angle, anchor)

	# Transform the corners to world space
	top_left = transform * top_left
	top_right = transform * top_right
	bottom_left = transform * bottom_left
	bottom_right = transform * bottom_right

	# Draw the rectangle using the transformed corners
	draw_polygon([top_left, top_right, bottom_right, bottom_left], [Color(1, 1, 1)])
