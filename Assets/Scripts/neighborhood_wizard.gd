extends Node

var neighborhood : Neighborhood

var grid : TileMapLayer

func _ready() -> void:
	neighborhood = Neighborhood.new()
	grid = get_node("Grid/Actual Grid")


func get_spawn_range() -> Vector2i:
	return neighborhood.get_spawn_range()


func get_stable_range() -> Vector2i:
	return neighborhood.get_stable_range()


func add_to_spawn_range(v : Vector2i) -> void:
	neighborhood.add_to_spawn_range(v)


func add_to_stable_range(v : Vector2i) -> void:
	neighborhood.add_to_stable_range(v)


func encode_grid_to_bit_string() -> void:
	var bit_string = ""
	var full_bit_string = ""
	var byte_array = PackedByteArray()
	byte_array.resize(8)

	# Top Left Quadrant
	var row = 0;
	for y in range(-7, 1):
		bit_string = ""
		for x in range(-7, 1):
			var grid_coord = Vector2i(x, y)

			var cell = grid.get_cell_atlas_coords(grid_coord).x
			
			bit_string += "0" if cell == 0 else "1"

		
		print(bit_string + " -> " + str(bit_string.bin_to_int()))
		byte_array.encode_u8(row, bit_string.bin_to_int())
		row += 1
		full_bit_string += bit_string


	print(byte_array)
	print(full_bit_string)
