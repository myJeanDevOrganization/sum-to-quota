extends Node2D

var snap_size : float = 0.0
var is_pressed = false
var start_position = Vector2.ZERO
var end_position = Vector2.ZERO


func _enter_tree() -> void:
	set_process_input(false)


func set_up() -> void:
	var new_snap_size = get_parent().tile_map_layer.tile_set.tile_size.x
	set_snap_size(new_snap_size)
	set_process_input(true)


func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			is_pressed = true
			start_position = event.position
			set_box_position(event.position)
		else:
			is_pressed = false
			end_position = event.position
			set_box_position(Vector2.ZERO)
	elif event is InputEventMouseMotion:
		$Polygon2D.global_position = event.position
		if is_pressed:
			end_position = event.position
			update_box(start_position, end_position)


func set_snap_size(new_snap_size):
	snap_size = new_snap_size


func set_box_position(new_position: Vector2):
	$SelectionBox.points[0] = new_position
	$SelectionBox.points[1] = new_position
	$SelectionBox.points[2] = new_position
	$SelectionBox.points[3] = new_position


func update_box(start_position: Vector2, end_position: Vector2):
	var min_x = min(start_position.x, end_position.x)
	var max_x = max(start_position.x, end_position.x)
	var min_y = min(start_position.y, end_position.y)
	var max_y = max(start_position.y, end_position.y)
	
	var s_min_x = snappedf(min_x, snap_size) if snappedf(min_x, snap_size) <= min_x else snappedf(min_x-snap_size, snap_size)
	var s_max_x = snappedf(max_x, snap_size) if snappedf(max_x, snap_size) >= max_x else snappedf(max_x+snap_size, snap_size)
	var s_min_y = snappedf(min_y, snap_size) if snappedf(min_y, snap_size) <= min_y else snappedf(min_y-snap_size, snap_size)
	var s_max_y = snappedf(max_y, snap_size) if snappedf(max_y, snap_size) >= max_y else snappedf(max_y+snap_size, snap_size)
	
	$SelectionBox.points[0] = Vector2(s_min_x, s_min_y)
	$SelectionBox.points[1] = Vector2(s_max_x, s_min_y)
	$SelectionBox.points[2] = Vector2(s_max_x, s_max_y)
	$SelectionBox.points[3] = Vector2(s_min_x, s_max_y)
