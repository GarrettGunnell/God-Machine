@tool
extends Node


var active_automaton : Automaton

var current_seed : int = 0

var needs_reseed : bool = true

var paused = false

var zoom_setting = 0
var zoom_settings : Array = Array([1, 2, 4, 8])

var world_offset : Vector2i = Vector2i.ZERO

func _ready() -> void:
	active_automaton = Automaton.new()


func _process(delta: float) -> void:
	pass


func queue_reseed() -> void:
	needs_reseed = true

func get_reseed() -> bool:
	return needs_reseed

func finish_reseed() -> void:
	needs_reseed = false


func set_seed(new_seed : int) -> void:
	current_seed = new_seed


func get_seed() -> int:
	return current_seed


func set_active_automaton(robot : Automaton) -> void:
	active_automaton = robot.duplicate()


func get_active_automaton() -> Automaton:
	return active_automaton


func pause_automaton() -> void:
	paused = !paused

func is_paused() -> bool:
	return paused

func cycle_zoom() -> void:
	zoom_setting += 1
	if zoom_setting > zoom_settings.size() - 1: zoom_setting = 0

func get_zoom_setting() -> int:
	return zoom_settings[zoom_setting]


func get_horizontal_offset() -> int:
	return world_offset.x

func get_vertical_offset() -> int:
	return world_offset.y


func move(v : Vector2i) -> void:
	world_offset += v
