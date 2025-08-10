extends AcerolaPanel

var grid : TileMapLayer

func _ready() -> void:
	grid = get_node("../../Grid/Actual Grid")

func on_pressed() -> void:
	randomize()
	for x in range(-7, 8):
		for y in range(-7, 8):
			var cell_coord = Vector2i(x, y)
			var random_cell_value = 1 if randf() > randf() else 0
			grid.set_cell(cell_coord, 1, Vector2i(random_cell_value, 0), 0)
