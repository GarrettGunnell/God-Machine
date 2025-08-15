extends AcerolaPanel

var grid : TileMapLayer
var cursor_grid : TileMapLayer

@export var base_radius = 0
@export var radius_increment = 1

var on_radius = 1
var off_radius = 1

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
				var in_radius = 0

				if -cursor_radius < x and x < cursor_radius and -cursor_radius < y and y < cursor_radius: in_radius = 1
				

				var old_radius = cursor_radius - radius_increment
				var in_old_radius = 0

				if -old_radius < x and x < old_radius and -old_radius < y and y < old_radius: in_old_radius = 1
				
				if in_radius and not in_old_radius: cursor_grid.set_cell(cell_coord, 1, Vector2i(1, 0), 0)


func on_pressed() -> void:
	off_radius = base_radius
	for x in range(-7, 8):
		for y in range(-7, 8):
			var cell_coord = Vector2i(x, y)
			var in_radius = 0

			if -on_radius < x and x < on_radius and -on_radius < y and y < on_radius: in_radius = 1

			var cell_value = grid.get_cell_atlas_coords(cell_coord).x
			
			grid.set_cell(cell_coord, 1, Vector2i(min(1, in_radius + cell_value), 0), 0)
			
	on_radius += radius_increment


func on_alternate_pressed() -> void:
	on_radius = base_radius
	for x in range(-7, 8):
		for y in range(-7, 8):
			var cell_coord = Vector2i(x, y)
			var in_radius = 0

			if -off_radius < x and x < off_radius and -off_radius < y and y < off_radius: in_radius = 1

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
