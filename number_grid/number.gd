extends Node2D

const SPEED = 4
var num_value = 0
var is_selected = false
var being_collected = false
var coordinate: Vector2i = Vector2i.ZERO
var collection_point = Vector2.ZERO


func set_selected(state: bool):
	is_selected = state
	if is_selected:
		set_modulate(Color(1.0, 0.0, 0.0))
	else:
		set_modulate(Color(1.0, 1.0, 1.0))


func set_value(value:int):
	num_value = value
	$Panel.modulate = get_custom_color(value)
	$ValueText.set_text("[center]" + str(num_value) + "[/center]")


func get_custom_color(value: float) -> Color:
	value = clamp(value, -1.0, 9.0)
	var normalized = (value + 1.0) / 10.0

	if normalized < 0.5:
		var local_t = normalized * 2.0
		return Color.BLUE.lerp(Color.MAGENTA, local_t)
	else:
		var local_t = (normalized - 0.5) * 2.0
		return Color.MAGENTA.lerp(Color.RED, local_t)


func set_coordinate_visual(coordinate:Vector2i):
	coordinate = coordinate
	$CoordinateDebug.set_text("[center]" + str(coordinate) + "[/center]")


func collect():
	print("im going to die now")
	z_index += 1
	collection_point = get_tree().get_first_node_in_group("collectionPoint").position
	being_collected = true
	$Area2D.set_collision_layer_value(1, true)
	$Area2D.set_collision_mask_value(1, true)


func _process(delta: float) -> void:
	if(being_collected):
		position = lerp(position, collection_point, delta * SPEED)
		if position.distance_to(collection_point) <= 100.0:
			being_collected = false
			queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	var other_object = area.get_parent()
	if other_object.is_in_group("number"):
		if other_object.being_collected:
			if get_instance_id() > other_object.get_instance_id():
				var new_num_value = num_value + other_object.num_value
				print("NEW: ",new_num_value)
				set_value(new_num_value)
				other_object.queue_free()
