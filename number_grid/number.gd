extends Node2D

var num_value = 0
var is_selected = false
var coordinate: Vector2i = Vector2i.ZERO


func set_selected(state: bool):
	is_selected = state
	if is_selected:
		set_modulate(Color(1.0, 0.0, 0.0))
	else:
		set_modulate(Color(1.0, 1.0, 1.0))


func set_value(value:int):
	num_value = value
	$ValueText.set_text("[center]" + str(num_value) + "[/center]")


func set_coordinate_visual(coordinate:Vector2i):
	coordinate = coordinate
	$CoordinateDebug.set_text("[center]" + str(coordinate) + "[/center]")


func collect():
	print("im going to die now")
	queue_free()
