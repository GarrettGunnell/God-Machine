extends RichTextLabel

func _process(delta: float) -> void:
	var current_seed = str(get_node("/root/Node3D/Game Master").get_seed()).pad_zeros(8)
	
	text = "[center]" + str(current_seed) + "[/center]"
