extends Node2D

# Constants
const BELT_PIXELS_WIDTH: = 1 * Globals.PIXELS_PER_METER 
const BELT_TURN_RADIUS:  = 2 * Globals.PIXELS_PER_METER

var supports = []
var building = false
var angle = 0.0
var step = deg_to_rad(10)

func get_snapped_position():
	var position = get_global_mouse_position()
	return floor((position / Globals.PIXELS_PER_METER)) * Globals.PIXELS_PER_METER

func draw_arrow(position: Vector2, magnitude: Vector2, color: Color, width: float = -1.0) -> void:
	var end = position + magnitude
	draw_line(position, end, color, width)

	var direction = magnitude.normalized()
	var end1 = end + (direction.rotated(deg_to_rad(30)) * -20)
	var end2 = end + (direction.rotated(-deg_to_rad(30)) * -20)
	
	draw_line(end, end1, color, width)
	draw_line(end, end2, color, width)

func draw_support(position: Vector2, angle: float) -> void:
	var direction = Vector2(cos(angle), sin(angle))
	var perpendicular = direction.rotated(-PI / 2)

	var half_length = BELT_PIXELS_WIDTH / 2
	var half_width = BELT_PIXELS_WIDTH / 4

	var corners = [
		position + perpendicular * half_length + direction * half_width,
		position + perpendicular * half_length - direction * half_width,
		position - perpendicular * half_length - direction * half_width,
		position - perpendicular * half_length + direction * half_width
	]

	draw_polygon(corners, [Color(1.0, 1.0, 1.0)])
	draw_arrow(position, direction * Globals.PIXELS_PER_METER, Color(1.0, 0.0, 0.0), 3)

func tangent_lines(x1: float, y1: float, r1: float, x2: float, y2: float, r2: float) -> Array:
	var delta1 = (x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2) - (r1 + r2) * (r1 + r2);
	var delta2 = (x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2) - (r1 - r2) * (r1 - r2);
	var p1 = r1 * (x1 * x2 + y1 * y2 - x2 * x2 - y2 * y2);
	var p2 = r2 * (x1 * x1 + y1 * y1 - x1 * x2 - y1 * y2);
	var q = x1 * y2 - x2 * y1;
	var results = []

	if (delta1 >= 0):
		var l11 = [
			(x2 - x1) * (r1 + r2) + (y1 - y2) * sqrt(delta1),
			(y2 - y1) * (r1 + r2) + (x2 - x1) * sqrt(delta1),
			p1 + p2 + q * sqrt(delta1)
		]

		var l12 = [
			(x2 - x1) * (r1 + r2) - (y1 - y2) * sqrt(delta1),
			(y2 - y1) * (r1 + r2) - (x2 - x1) * sqrt(delta1),
			p1 + p2 - q * sqrt(delta1)
		]

		results.append(l11)
		results.append(l12)

	if (delta2 >= 0):
		var l21 = [
			(x2 - x1) * (r1 - r2) + (y1 - y2) * sqrt(delta2),
			(y2 - y1) * (r1 - r2) + (x2 - x1) * sqrt(delta2),
			p1 - p2 + q * sqrt(delta2)
		]

		var l22 = [
			(x2 - x1) * (r1 - r2) - (y1 - y2) * sqrt(delta2),
			(y2 - y1) * (r1 - r2) - (x2 - x1) * sqrt(delta2),
			p1 - p2 - q * sqrt(delta2)
		]

		results.append(l21)
		results.append(l22)
		
	return results
	
#func tangent_to_line(a: float, b: float, c: float) -> Array:
	#var pointA: Vector2
	#var pointB: Vector2
	#
	#if (abs(a) < abs(b)):
		#pointA = Vector2(-10000, (-c - a * -10000) / b)
		#pointB = Vector2( 10000, (-c - a * 10000) / b)
	#else:
		#pointA = Vector2((-c - b * -10000) / a, -10000)
		#pointB = Vector2((-c - b * 10000) / a, 10000)
#
	#return [ pointA, pointB ]
func tangent_to_line(center_a: Vector2, radius_a: float, center_b: Vector2, radius_b: float, a: float, b: float, c: float) -> Array:
	# Find the tangent point on circle A
	var x_a = center_a.x
	var y_a = center_a.y
	var r_a = radius_a
	
	# Calculate the tangent point on circle A
	var denom_a = a * a + b * b
	var px_a = (b * (b * x_a - a * y_a) - a * c) / denom_a
	var py_a = (a * (-b * x_a + a * y_a) - b * c) / denom_a
	var tangent_point_a = Vector2(px_a, py_a)
	
	# Find the tangent point on circle B
	var x_b = center_b.x
	var y_b = center_b.y
	var r_b = radius_b
	
	# Calculate the tangent point on circle B
	var denom_b = a * a + b * b
	var px_b = (b * (b * x_b - a * y_b) - a * c) / denom_b
	var py_b = (a * (-b * x_b + a * y_b) - b * c) / denom_b
	var tangent_point_b = Vector2(px_b, py_b)
	
	# Return the tangent segment
	return [tangent_point_a, tangent_point_b]

func draw_belt():
	for support_index in supports.size():
		var start_support = supports[support_index]
		var start_position = start_support[0]
		var start_belt_direction = Vector2(cos(start_support[1]), sin(start_support[1]))

		if (support_index + 1 < supports.size()):
			var end_support = supports[support_index + 1]
			var end_position = end_support[0]
			var end_belt_direction = Vector2(cos(end_support[1]), sin(end_support[1]))

			var start_arc_center
			var to_end = (end_position - start_position).normalized()
			var to_end_cross = start_belt_direction.cross(to_end)
			if (to_end_cross == 0):
				# Go straight there
				draw_line(start_position, end_position, Color(0.7, 0.7, 0.7, 1.0), BELT_PIXELS_WIDTH)
			else:
				if (to_end_cross < 0):
					# Turn to the left to get to end
					start_arc_center = start_position + start_belt_direction.rotated(-PI / 2) * BELT_TURN_RADIUS
				else:
					# Turn to the right to get to end
					start_arc_center = start_position + start_belt_direction.rotated(PI / 2) * BELT_TURN_RADIUS

				# Draw red line to show arc center for turn
				draw_line(start_arc_center, start_position, Color(1.0, 0.0, 0.0), 2)
				draw_circle(start_arc_center, BELT_TURN_RADIUS, Color(1.0, 0.0, 0.0), false, 2)

				var end_arc_center
				var to_start = (start_position - end_position).normalized()
				var to_start_cross = end_belt_direction.cross(to_start)
				if (to_start_cross == 0):
					# Curve from start, but straight to this point, so no curve on this side
					pass 
				else:
					if (to_start_cross < 0):
						# Turn to the left to get back to start
						end_arc_center = end_position + end_belt_direction.rotated(-PI / 2) * BELT_TURN_RADIUS
					else:
						# Turn to the right to get back to start
						end_arc_center = end_position + end_belt_direction.rotated(PI / 2) * BELT_TURN_RADIUS

					# Draw green for the turn we're coming into
					draw_line(end_arc_center, end_position, Color(0.0, 1.0, 0.0), 2)
					draw_circle(end_arc_center, BELT_TURN_RADIUS, Color(0.0, 1.0, 0.0), false, 2)

					var tangents = tangent_lines(start_arc_center.x, start_arc_center.y, BELT_TURN_RADIUS, end_arc_center.x, end_arc_center.y, BELT_TURN_RADIUS)
					for tangent_index in tangents.size():
						var tangent = tangents[tangent_index]
						var line = tangent_to_line(start_arc_center, BELT_TURN_RADIUS, end_arc_center, BELT_TURN_RADIUS, tangent[0], tangent[1], tangent[2])
						draw_line(line[0], line[1], Color(0.0, 0.0, 1.0), 2)
						var arc_direction = (line[0] - start_position).normalized()
						var tangent_cross = start_belt_direction.cross(arc_direction)
						print("Tangent[", tangent_index, "] : ", line[0], " Cross: ", tangent_cross, " To End Cross: ", to_end_cross)
						if ((tangent_cross > 0 and to_end_cross > 0) or
							(tangent_cross < 0 and to_end_cross < 0)):
							draw_line(line[0], line[1], Color(0.0, 0.0, 1.0), 2)
					

		draw_support(start_position, start_belt_direction.angle())

func _unhandled_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton):	
		if (event.pressed == true):
			if (event.button_index == MOUSE_BUTTON_RIGHT):
				building = !building
				queue_redraw()
			elif (event.button_index == MOUSE_BUTTON_MIDDLE):
				supports = []
				queue_redraw()
			elif (building == true):
				if (event.button_index == MOUSE_BUTTON_WHEEL_UP):
					angle += step
					queue_redraw()
				elif (event.button_index == MOUSE_BUTTON_WHEEL_DOWN):
					angle -= step
					queue_redraw()
				elif (event.button_index == MOUSE_BUTTON_LEFT):
					supports.append([ get_snapped_position(), angle ])
					queue_redraw()
				print("Angle: ", rad_to_deg(angle))
	elif (building == true and event is InputEventMouseMotion):
		queue_redraw()
	else:
		pass

func _draw() -> void:
	if (building == true):
		draw_support(get_snapped_position(), angle)

	draw_belt()
