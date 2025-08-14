extends AcerolaPanel

var grid : TileMapLayer

func _ready() -> void:
	grid = get_node("../../Grid/Actual Grid")

func on_pressed() -> void:
	randomize()
	
	var cell_coord = Vector2i(randi() % 15 - 7, randi() % 15 - 7)
	grid.set_cell(cell_coord, 1, Vector2i(1, 0), 0)
	get_node("../../.").encode_grid_to_neighborhood_bytes()

func on_alternate_pressed() -> void:
	randomize()
	
	var cell_coord = Vector2i(randi() % 15 - 7, randi() % 15 - 7)
	grid.set_cell(cell_coord, 1, Vector2i(0, 0), 0)
	get_node("../../.").encode_grid_to_neighborhood_bytes()