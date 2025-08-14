@tool
extends Node


var active_automaton : Automaton

var current_seed : int = 0

var needs_reseed : bool = true

var paused = false

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