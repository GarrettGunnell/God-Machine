extends AudioStreamPlayer


func _ready() -> void:
	GameMaster.increment_input.connect(play_sound)

func play_sound() -> void:
	print("Played sound")
	pitch_scale = lerp(0.9, 1.1, randf())
	playing = true
