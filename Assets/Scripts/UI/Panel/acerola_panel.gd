extends Panel
class_name AcerolaPanel

var panel_style : StyleBoxFlat

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
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			panel_style.bg_color = Color(1.0, 1.0, 1.0, 0.0)

		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			panel_style.bg_color = Color(1.0, 1.0, 1.0, 0.2)
			on_pressed()


func on_pressed() -> void:
	pass
