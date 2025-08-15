extends Node
class_name NeighborhoodWizard

@export var neighborhood_id = 0

var neighborhood : Neighborhood

var grid : TileMapLayer

var upper_left_quadrant : PackedByteArray

func _ready() -> void:
	neighborhood = GameMaster.get_active_automaton().get_neighborhood(neighborhood_id)

	GameMaster.loaded_preset.connect(load_neighborhood_to_grid)

	grid = get_node("Grid/Actual Grid")

	load_neighborhood_to_grid()


func get_spawn_range() -> Vector2i:
	return neighborhood.get_spawn_range()


func get_stable_range() -> Vector2i:
	return neighborhood.get_stable_range()


func add_to_spawn_range(v : Vector2i) -> void:
	neighborhood.add_to_spawn_range(v)


func add_to_stable_range(v : Vector2i) -> void:
	neighborhood.add_to_stable_range(v)


func toggle_neighborhood() -> void:
	if neighborhood.is_enabled():
		neighborhood.disable()
	else:
		neighborhood.enable()


func is_enabled() -> bool:
	return neighborhood.is_enabled()


func load_neighborhood_to_grid() -> void:
	neighborhood = GameMaster.get_active_automaton().get_neighborhood(neighborhood_id)

	if not grid or not neighborhood: return

	var upper_left_data = neighborhood.get_quadrant_strings(neighborhood.Quadrant.UPPER_LEFT)

	# Top Left Quadrant
	for y in range(0, 8):
		var byte_string = upper_left_data[y]
		for x in range(-7, 1):
			var grid_coord = Vector2i(x, -y)

			var bit = byte_string[x + 7]

			grid.set_cell(grid_coord, 1, Vector2i(0 if bit == "0" else 1, 0), 0)

	# Top Right Quadrant
	var upper_right_data = neighborhood.get_quadrant_strings(neighborhood.Quadrant.UPPER_RIGHT)
	for y in range(0, 8):
		var byte_string = upper_right_data[y]
		for x in range(0, 8):
			var grid_coord = Vector2i(x, -y)

			var bit = byte_string[x]

			grid.set_cell(grid_coord, 1, Vector2i(0 if bit == "0" else 1, 0), 0)

	# Lower Left Quadrant
	var lower_left_data = neighborhood.get_quadrant_strings(neighborhood.Quadrant.LOWER_LEFT)
	for y in range(-7, 1):
		var byte_string = lower_left_data[y + 7]
		for x in range(-7, 1):
			var grid_coord = Vector2i(x, -y)

			var bit = byte_string[x + 7]

			grid.set_cell(grid_coord, 1, Vector2i(0 if bit == "0" else 1, 0), 0)

	
	# Lower Right Quadrant
	var lower_right_data = neighborhood.get_quadrant_strings(neighborhood.Quadrant.LOWER_RIGHT)
	for y in range(-7, 1):
		var byte_string = lower_right_data[y + 7]
		for x in range(0, 8):
			var grid_coord = Vector2i(x, -y)

			var bit = byte_string[x]

			grid.set_cell(grid_coord, 1, Vector2i(0 if bit == "0" else 1, 0), 0)



func encode_grid_to_neighborhood_bytes() -> void:
	if not grid: return
	neighborhood = GameMaster.get_active_automaton().get_neighborhood(neighborhood_id)
	var byte_strings = Array()
	var byte_array = PackedByteArray()
	byte_array.resize(8)

	# Top Left Quadrant
	for y in range(0, 8):
		var byte_string = ""
		for x in range(-7, 1):
			var grid_coord = Vector2i(x, -y)

			var cell = grid.get_cell_atlas_coords(grid_coord).x
			
			byte_string += "0" if cell == 0 else "1"

		
		byte_strings.append(byte_string)
		neighborhood.encode_quadrant_byte(neighborhood.Quadrant.UPPER_LEFT, byte_string.bin_to_int(), y)
		byte_array.encode_u8(y, byte_string.bin_to_int())

	neighborhood.set_quadrant_strings(neighborhood.Quadrant.UPPER_LEFT, byte_strings.duplicate())


	# Top Right Quadrant
	byte_strings.clear()
	for y in range(0, 8):
		var byte_string = ""
		for x in range(0, 8):
			var grid_coord = Vector2i(x, -y)

			var cell = grid.get_cell_atlas_coords(grid_coord).x
			
			byte_string += "0" if cell == 0 else "1"

		
		byte_strings.append(byte_string)
		neighborhood.encode_quadrant_byte(neighborhood.Quadrant.UPPER_RIGHT, byte_string.bin_to_int(), y)
		byte_array.encode_u8(y, byte_string.bin_to_int())

	neighborhood.set_quadrant_strings(neighborhood.Quadrant.UPPER_RIGHT, byte_strings.duplicate())



	# Lower Left Quadrant
	byte_strings.clear()
	for y in range(-7, 1):
		var byte_string = ""
		for x in range(-7, 1):
			var grid_coord = Vector2i(x, -y)

			var cell = grid.get_cell_atlas_coords(grid_coord).x
			
			byte_string += "0" if cell == 0 else "1"

		
		byte_strings.append(byte_string)
		neighborhood.encode_quadrant_byte(neighborhood.Quadrant.LOWER_LEFT, byte_string.bin_to_int(), y + 7)
		byte_array.encode_u8(y + 7, byte_string.bin_to_int())


	neighborhood.set_quadrant_strings(neighborhood.Quadrant.LOWER_LEFT, byte_strings.duplicate())


	# Lower Right Quadrant
	byte_strings.clear()
	for y in range(-7, 1):
		var byte_string = ""
		for x in range(0, 8):
			var grid_coord = Vector2i(x, -y)

			var cell = grid.get_cell_atlas_coords(grid_coord).x
			
			byte_string += "0" if cell == 0 else "1"

		
		byte_strings.append(byte_string)
		neighborhood.encode_quadrant_byte(neighborhood.Quadrant.LOWER_RIGHT, byte_string.bin_to_int(), y + 7)
		byte_array.encode_u8(y + 7, byte_string.bin_to_int())


	neighborhood.set_quadrant_strings(neighborhood.Quadrant.LOWER_RIGHT, byte_strings.duplicate())





func get_quadrant() -> PackedByteArray:
	return neighborhood.get_neighborhood_bytes()

func get_rule_ranges() -> Vector4i:
	var spawn = neighborhood.get_spawn_range()
	var stable = neighborhood.get_stable_range()

	return Vector4i(spawn.x, spawn.y, stable.x, stable.y)
