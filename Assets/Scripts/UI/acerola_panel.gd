extends Panel
class_name AcerolaPanel


func _on_mouse_entered() -> void:
	print("enter")
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	print("exit")
	pass # Replace with function body.


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			on_pressed()


func on_pressed() -> void:
	pass
