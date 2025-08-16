extends Node2D

var slide_index = 0

var slides = []

func _ready() -> void:
	slides = get_children()
	
	slides[slide_index].show()


func previous_slide() -> void:
	if slide_index == 0: return
	
	slides[slide_index].hide()
	
	slide_index -= 1
	
	slides[slide_index].show()
	

func next_slide() -> void:
	if slide_index == (slides.size() - 1): return
	
	slides[slide_index].hide()
	
	slide_index += 1
	
	slides[slide_index].show()
