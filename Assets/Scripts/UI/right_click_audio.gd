extends AudioStreamPlayer


func _ready() -> void:
	GameMaster.decrement_input.connect(play_sound)
	

func play_sound() -> void:
	pitch_scale = lerp(0.9, 1.1, randf())
	playing = true
