extends AcerolaPanel

func on_pressed() -> void:
	get_node("../../.").encode_grid_to_neighborhood_bytes()
