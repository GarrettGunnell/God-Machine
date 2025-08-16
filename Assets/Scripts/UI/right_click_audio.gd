extends AudioStreamPlayer


func _ready() -> void:
	GameMaster.decrement_input.connect(play_sound)
	
	
func play_sound() -> void:
	playing = true
