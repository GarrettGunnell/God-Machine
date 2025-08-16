extends Panel
class_name GridPanel

var hovered = false

var panel_style : StyleBoxFlat

var neighborhood_grid : TileMapLayer
var cursor_grid : TileMapLayer

var grid_coords : Vector2i
var previous_grid_coords : Vector2i

func _ready() -> void:
	neighborhood_grid = get_child(0)
	cursor_grid = get_child(1)
	panel_style = StyleBoxFlat.new()
	panel_style.bg_color = Color(1.0, 1.0, 1.0, 0.0)
	add_theme_stylebox_override("panel", panel_style)	
	
func _process(delta: float) -> void:
	if get_parent().is_enabled():
		panel_style.bg_color = Color(0.0, 0.0, 0.0, 0.0)
	else:
		panel_style.bg_color = Color(0.0, 0.0, 0.0, 0.75)

	if hovered:
		var mouse_pos = get_global_mouse_position()
		cursor_grid.clear()
		
		grid_coords = cursor_grid.local_to_map(cursor_grid.to_local(mouse_pos))
		if grid_coords != previous_grid_coords: GameMaster.hover_input.emit()

		cursor_grid.set_cell(grid_coords, 1, Vector2i(1, 0), 0)

		previous_grid_coords = grid_coords


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

			if new_cell_value == 1: GameMaster.increment_input.emit()
			if new_cell_value == 0: GameMaster.decrement_input.emit()
			neighborhood_grid.set_cell(grid_coords, 1, Vector2i(new_cell_value, 0), 0)
			get_parent().encode_grid_to_neighborhood_bytes()
