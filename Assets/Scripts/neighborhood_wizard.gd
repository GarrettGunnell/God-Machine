extends Node
class_name NeighborhoodWizard

var neighborhood : Neighborhood

var grid : TileMapLayer

var upper_left_quadrant : PackedByteArray

func _ready() -> void:
	neighborhood = Neighborhood.new()
	grid = get_node("Grid/Actual Grid")
	encode_grid_to_neighborhood_bytes()


func get_spawn_range() -> Vector2i:
	return neighborhood.get_spawn_range()


func get_stable_range() -> Vector2i:
	return neighborhood.get_stable_range()


func add_to_spawn_range(v : Vector2i) -> void:
	neighborhood.add_to_spawn_range(v)


func add_to_stable_range(v : Vector2i) -> void:
	neighborhood.add_to_stable_range(v)


func encode_grid_to_neighborhood_bytes() -> void:
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


	for i in range(0, 8): print(byte_strings[7 - i])

	print(byte_array)
	print(neighborhood.get_neighborhood_bytes())

	upper_left_quadrant = PackedByteArray(byte_array)


func get_quadrant() -> PackedByteArray:
	return neighborhood.get_neighborhood_bytes()

func get_rule_ranges() -> Vector4i:
	var spawn = neighborhood.get_spawn_range()
	var stable = neighborhood.get_stable_range()

	return Vector4i(spawn.x, spawn.y, stable.x, stable.y)
