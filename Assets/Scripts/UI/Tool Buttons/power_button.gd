extends AcerolaPanel

func on_pressed() -> void:
	get_node("../../.").toggle_neighborhood()
