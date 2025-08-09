extends AcerolaPanel

func on_pressed() -> void:
	get_node("/root/Node3D/Game Master").set_seed(randi() % 10000)
