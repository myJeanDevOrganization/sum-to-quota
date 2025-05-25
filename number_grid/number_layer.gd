extends TileMapLayer

var tile_to_elements: Dictionary = {}


func generate_random_number():
	return randi_range(0,9)


func _ready() -> void:
	for cell in get_used_cells():
		var cell_number_data = generate_random_number()
		var cell_global_position = to_global(map_to_local(cell))
		get_cell_tile_data(cell).set_custom_data("value", cell_number_data)
		set_cell(cell, 1, Vector2(cell_number_data, 0))
		
		var number_element = load("res://number_grid/number.tscn").instantiate()
		tile_to_elements[cell] = number_element
		number_element.set_value(cell_number_data)
		number_element.set_coordinate_visual(cell)
		number_element.set_global_position(cell_global_position) 
		$PopulateTimer.start()
		await $PopulateTimer.timeout
		$PopulateTimer.wait_time /= 1.5
		get_parent().add_child(number_element)


var start_selection = Vector2.ZERO
var end_selection = Vector2.ZERO
var is_selecting = false


func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			start_selection = event.position
			is_selecting = true
		elif is_selecting:
			is_selecting = false
			end_selection = event.position
			var selected_cells: Array[Vector2i] = get_selected_cells(start_selection, end_selection)
			set_cells_to_selected(selected_cells)


var quota_sum = 10
func set_cells_to_selected(selected_cells: Array[Vector2i]):
	if sum_selection(selected_cells) == quota_sum:
		print("we did it, we summed to quota")
		await get_tree().create_timer(0.1).timeout
		collect_selection(selected_cells)
	else:
		await get_tree().create_timer(0.5).timeout
		deselect(selected_cells)


func sum_selection(selected_cells: Array[Vector2i]):
	var selected_sum = 0
	for coordinate in selected_cells:
		if tile_to_elements.has(coordinate):
			var cell_number_element = tile_to_elements[coordinate]
			selected_sum += cell_number_element.num_value
			print(selected_sum)
			cell_number_element.set_selected(true)
	return selected_sum


func collect_selection(selected_cells: Array[Vector2i]):
	for coordinate in selected_cells:
		if tile_to_elements.has(coordinate):
			erase_cell(coordinate)
			var cell_number_element = tile_to_elements[coordinate]
			tile_to_elements.erase(coordinate)
			cell_number_element.collect()


func deselect(selected_cells: Array[Vector2i]):
	for coordinate in selected_cells:
		if tile_to_elements.has(coordinate):
			var cell_number_element = tile_to_elements[coordinate]
			cell_number_element.set_selected(false)


func get_selected_cells(start: Vector2, end: Vector2) -> Array[Vector2i]:
	var selected_cells: Array[Vector2i] = []
	var start_grid:Vector2i = local_to_map(to_global(start))
	var end_grid:Vector2i = local_to_map(to_global(end))
	var minx = min(start_grid.x, end_grid.x)
	var maxx = max(start_grid.x, end_grid.x)
	var miny = min(start_grid.y, end_grid.y)
	var maxy = max(start_grid.y, end_grid.y)
	
	for x in range(minx, maxx+1):
		for y in range(miny, maxy+1):
			var cell = get_cell_source_id(Vector2i(x,y))
			if cell != -1:
				selected_cells.append(Vector2i(x,y))
	return selected_cells
