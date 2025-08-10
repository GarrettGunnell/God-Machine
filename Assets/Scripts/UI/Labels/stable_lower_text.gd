extends RichTextLabel

func _process(delta: float) -> void:
	var current_seed = str(get_node("../../.").get_stable_range().x)
	
	text = "[center]" + str(current_seed) + "[/center]"
