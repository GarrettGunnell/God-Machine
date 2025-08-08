extends AcerolaPanel

func on_pressed() -> void:
	get_node("/root/Node3D/Game Master").queue_reseed()
