extends AcerolaPanel

var grid : TileMapLayer

func _ready() -> void:
	grid = get_node("../../Grid/Actual Grid")

func on_pressed() -> void:
	for x in range(-7, 8):
		for y in range(-7, 8):
			var cell_coord = Vector2i(x, y)
			grid.set_cell(cell_coord, 1, Vector2i(0, 0), 0)

	get_node("../../.").encode_grid_to_neighborhood_bytes()
