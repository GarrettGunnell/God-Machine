extends Panel
class_name AcerolaPanel


var panel_style : StyleBoxFlat
var draggable = false
var pressed = false
var cached_pos = Vector2.ZERO


func _init() -> void:
	panel_style = StyleBoxFlat.new()

	panel_style.bg_color = Color(1.0, 1.0, 1.0, 0.0)
	add_theme_stylebox_override("panel", panel_style)	


func _on_mouse_entered() -> void:
	panel_style.bg_color = Color(1.0, 1.0, 1.0, 0.2)


func _on_mouse_exited() -> void:
	panel_style.bg_color = Color(1.0, 1.0, 1.0, 0.0)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			pressed = true
			cached_pos = get_global_mouse_position()
			panel_style.bg_color = Color(1.0, 1.0, 1.0, 0.0)
		else:
			pressed = false
			panel_style.bg_color = Color(1.0, 1.0, 1.0, 0.2)

			if draggable:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
				get_node("/root").warp_mouse(cached_pos)

		if event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT: 
				on_pressed()
			if event.button_index == MOUSE_BUTTON_RIGHT: 
				on_alternate_pressed()
			
	if event is InputEventMouseMotion && pressed && draggable:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		on_drag(event.relative)


func on_pressed() -> void:
	pass

func on_alternate_pressed() -> void:
	pass

func on_drag(motion : Vector2) -> void:
	pass
