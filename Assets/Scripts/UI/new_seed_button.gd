extends AcerolaPanel

func on_pressed() -> void:
	GameMaster.set_seed(randi() % 10000)
