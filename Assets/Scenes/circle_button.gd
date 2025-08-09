extends AcerolaPanel

var grid : TileMapLayer

var radius = 0.15

func _ready() -> void:
	grid = get_node("../../Grid/Actual Grid")

func on_pressed() -> void:
	for x in range(-7, 8):
		for y in range(-7, 8):
			var cell_coord = Vector2i(x, y)
			var in_radius = 1 if Vector2(x * 0.25, y * 0.25).length_squared() < radius * radius else 0
			grid.set_cell(cell_coord, 1, Vector2i(in_radius, 0), 0)
			
	radius += 0.15

func _on_mouse_entered() -> void:
	panel_style.bg_color = Color(1.0, 1.0, 1.0, 0.2)
	radius = 0.15
	
func _on_mouse_exited() -> void:
	panel_style.bg_color = Color(1.0, 1.0, 1.0, 0.0)
	radius = 0.15
