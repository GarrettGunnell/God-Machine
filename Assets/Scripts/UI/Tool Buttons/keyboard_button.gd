extends AcerolaPanel

func on_pressed() -> void:
	GameMaster.queue_reseed()
