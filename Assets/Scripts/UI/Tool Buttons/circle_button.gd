extends AcerolaPanel

var grid : TileMapLayer
var cursor_grid : TileMapLayer

@export var base_radius = 0.15
@export var radius_increment = 0.15

var on_radius = 0.0
var off_radius = 0.0

var hovered = false

func _ready() -> void:
	grid = get_node("../../Grid/Actual Grid")
	cursor_grid = get_node("../../Grid/Cursor Grid")

	on_radius = base_radius
	off_radius = base_radius

func _process(delta: float) -> void:
	if hovered:
		cursor_grid.clear()
		
		for x in range(-7, 8):
			for y in range(-7, 8):
				var cell_coord = Vector2i(x, y)
				var cursor_radius = max(on_radius, off_radius)
				var in_radius = 1 if Vector2(x * 0.25, y * 0.25).length_squared() < cursor_radius * cursor_radius else 0

				var old_radius = cursor_radius - radius_increment
				var in_old_radius = 1 if Vector2(x * 0.25, y * 0.25).length_squared() < old_radius * old_radius else 0
				
				if in_radius and not in_old_radius: cursor_grid.set_cell(cell_coord, 1, Vector2i(1, 0), 0)

func on_pressed() -> void:
	off_radius = base_radius
	for x in range(-7, 8):
		for y in range(-7, 8):
			var cell_coord = Vector2i(x, y)
			var in_radius = 1 if Vector2(x * 0.25, y * 0.25).length_squared() < on_radius * on_radius else 0

			var cell_value = grid.get_cell_atlas_coords(cell_coord).x
			
			grid.set_cell(cell_coord, 1, Vector2i(min(1, in_radius + cell_value), 0), 0)
			
	on_radius += radius_increment

func on_alternate_pressed() -> void:
	on_radius = base_radius
	for x in range(-7, 8):
		for y in range(-7, 8):
			var cell_coord = Vector2i(x, y)
			var in_radius = 1 if Vector2(x * 0.25, y * 0.25).length_squared() < off_radius * off_radius else 0

			var cell_value = grid.get_cell_atlas_coords(cell_coord).x

			grid.set_cell(cell_coord, 1, Vector2i(max(0, cell_value - in_radius), 0), 0)
			
	off_radius += radius_increment



func _on_mouse_entered() -> void:
	hovered = true
	panel_style.bg_color = Color(1.0, 1.0, 1.0, 0.2)
	on_radius = base_radius
	off_radius = base_radius
	cursor_grid.clear()
	
func _on_mouse_exited() -> void:
	hovered = false
	panel_style.bg_color = Color(1.0, 1.0, 1.0, 0.0)
	on_radius = base_radius
	off_radius = base_radius
	cursor_grid.clear()
	get_node("../../.").encode_grid_to_neighborhood_bytes()
