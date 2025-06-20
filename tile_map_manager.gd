extends Node2D

var tile_map_layer : TileMapLayer = null
var tile_to_elements: Dictionary = {}
var start_selection = Vector2.ZERO
var end_selection = Vector2.ZERO
var is_selecting = false


func _ready() -> void:
	tile_map_layer = $TileMapLayer
	populate_cells()
	$SelectorVisual.set_up()


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


func generate_random_number():
	return randi_range(-1,9)


func populate_cells():
	for cell in tile_map_layer.get_used_cells():
		var cell_number_data = generate_random_number()
		var cell_global_position = to_global(tile_map_layer.map_to_local(cell))
		tile_map_layer.get_cell_tile_data(cell).set_custom_data("value", cell_number_data)
		tile_map_layer.set_cell(cell, 1, Vector2(max(0, cell_number_data), 0))
		
		var number_element = load("res://number_grid/number.tscn").instantiate()
		tile_to_elements[cell] = number_element
		number_element.set_value(cell_number_data)
		number_element.set_coordinate_visual(cell)
		number_element.set_global_position(cell_global_position) 
		$PopulateTimer.start()
		await $PopulateTimer.timeout
		$PopulateTimer.wait_time /= 1.5
		get_parent().add_child(number_element)


func set_cells_to_selected(selected_cells: Array[Vector2i]):
	var levelManager = get_tree().get_first_node_in_group("levelManager")
	if sum_selection(selected_cells) == levelManager.current_quota:
		print("we did it, we summed to quota")
		await get_tree().create_timer(0.1).timeout
		levelManager.reduce_quota()
		levelManager.add_to_score(len(selected_cells))
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
			tile_map_layer.erase_cell(coordinate)
			var cell_number_element = tile_to_elements[coordinate]
			tile_to_elements.erase(coordinate)
			cell_number_element.collect()
			$CollectionBetweenTimer.start()
			await $CollectionBetweenTimer.timeout


func deselect(selected_cells: Array[Vector2i]):
	for coordinate in selected_cells:
		if tile_to_elements.has(coordinate):
			var cell_number_element = tile_to_elements[coordinate]
			cell_number_element.set_selected(false)


func get_selected_cells(start: Vector2, end: Vector2) -> Array[Vector2i]:
	var selected_cells: Array[Vector2i] = []
	var start_grid:Vector2i = tile_map_layer.local_to_map(to_global(start))
	var end_grid:Vector2i = tile_map_layer.local_to_map(to_global(end))
	var minx = min(start_grid.x, end_grid.x)
	var maxx = max(start_grid.x, end_grid.x)
	var miny = min(start_grid.y, end_grid.y)
	var maxy = max(start_grid.y, end_grid.y)
	
	for x in range(minx, maxx+1):
		for y in range(miny, maxy+1):
			var cell = tile_map_layer.get_cell_source_id(Vector2i(x,y))
			if cell != -1:
				selected_cells.append(Vector2i(x,y))
	return selected_cells
