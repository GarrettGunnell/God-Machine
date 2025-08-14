extends RichTextLabel

func _process(delta: float) -> void:
	var current_seed = str(get_node("../../.").neighborhood.stable_range.x)
	
	text = "[center]" + str(current_seed) + "[/center]"
