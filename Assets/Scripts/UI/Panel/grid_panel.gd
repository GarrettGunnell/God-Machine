extends Panel
class_name GridPanel

var hovered = false

var neighborhood_grid : TileMapLayer
var cursor_grid : TileMapLayer

var grid_coords : Vector2i

func _ready() -> void:
	neighborhood_grid = get_child(0)
	cursor_grid = get_child(1)
	
func _process(delta: float) -> void:
	if hovered:
		var mouse_pos = get_global_mouse_position()
		cursor_grid.clear()
		
		grid_coords = cursor_grid.local_to_map(cursor_grid.to_local(mouse_pos))

		cursor_grid.set_cell(grid_coords, 1, Vector2i(1, 0), 0)


	cursor_grid.set_cell(Vector2i.ZERO, 1, Vector2i(1, 0), 0)
	

func _on_mouse_entered() -> void:
	hovered = true
	# panel_style.bg_color = Color(1.0, 1.0, 1.0, 0.0)


func _on_mouse_exited() -> void:
	hovered = false
	# panel_style.bg_color = Color(1.0, 1.0, 1.0, 0.1)
	cursor_grid.clear()


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			var new_cell_value = 1 if neighborhood_grid.get_cell_atlas_coords(grid_coords).x == 0 else 0
			neighborhood_grid.set_cell(grid_coords, 1, Vector2i(new_cell_value, 0), 0)
