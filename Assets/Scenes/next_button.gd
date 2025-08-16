extends AcerolaPanel

func on_pressed() -> void:
	get_parent().get_node("/root/Node3D/Slides").next_slide()
