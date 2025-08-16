extends Node2D

var slide_index = 0

var slides = []

var tutorial_automaton : Automaton

func _ready() -> void:
	GameMaster.tutorial_setup()
	slides = get_children()
	
	slides[slide_index].show()

	tutorial_automaton = Automaton.new()


func previous_slide() -> void:
	if slide_index == 0: return
	GameMaster.loaded_preset.emit()
	
	slides[slide_index].hide()
	
	slide_index -= 1
	
	slides[slide_index].show()
	
	if slide_index == 0: 
		GameMaster.load_automaton_from_preset()
		GameMaster.queue_reseed()


func next_slide() -> void:
	if slide_index == (slides.size() - 1): return
	GameMaster.loaded_preset.emit()
	
	slides[slide_index].hide()
	
	slide_index += 1
	
	slides[slide_index].show()

	if slide_index == 1: GameMaster.set_active_automaton(tutorial_automaton)
