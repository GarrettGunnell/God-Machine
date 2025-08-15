extends AcerolaPanel

func on_pressed() -> void:
	GameMaster.save_active_automaton_to_preset()
