extends RichTextLabel

func _process(delta: float) -> void:
	text = "[center]" + str(GameMaster.get_preset_name()) + "[/center]"
