extends AudioStreamPlayer


func _ready() -> void:
	GameMaster.increment_input.connect(play_sound)
	
	
func play_sound() -> void:
	playing = true
