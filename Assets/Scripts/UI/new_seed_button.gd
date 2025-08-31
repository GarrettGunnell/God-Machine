extends AcerolaPanel

func on_pressed() -> void:
	GameMaster.set_seed(randi() % 100000)
