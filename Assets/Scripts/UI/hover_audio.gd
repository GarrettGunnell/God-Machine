extends AudioStreamPlayer


func _ready() -> void:
	GameMaster.hover_input.connect(play_sound)
	
	
func play_sound() -> void:
	pitch_scale = randf() * 0.5 + 1.0
	playing = true
