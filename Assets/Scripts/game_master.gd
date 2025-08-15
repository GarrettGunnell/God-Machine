@tool
extends Node

signal loaded_preset


var automaton_cache = Array()

var automaton_index = 0

var active_automaton : Automaton

var current_seed : int = 0

var needs_reseed : bool = true

var paused = false

var zoom_setting = 0
var zoom_settings : Array = Array([1, 2, 4, 8])

var world_offset : Vector2i = Vector2i.ZERO

func _ready() -> void:
	active_automaton = Automaton.new()

	var automaton_cache_path = "user://automaton_cache"

	var automaton_dir = DirAccess.open(automaton_cache_path)

	if not automaton_dir:
		print("Creating automaton cache directory")
		var error = DirAccess.make_dir_absolute(automaton_cache_path)
		if error != OK: print(error)

		for i in range(100):
			var automaton_template = Automaton.new()

			# Game Of Life Template
			automaton_template.get_neighborhood(0).set_ranges(Vector4i(3, 3, 2, 3))
			automaton_template.get_neighborhood(0).set_quadrant_strings(Neighborhood.Quadrant.UPPER_LEFT, ["00000010", "00000011", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000"])
			automaton_template.get_neighborhood(0).set_quadrant_strings(Neighborhood.Quadrant.UPPER_RIGHT, ["01000000", "11000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000"])
			automaton_template.get_neighborhood(0).set_quadrant_strings(Neighborhood.Quadrant.LOWER_LEFT, ["00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000011", "00000010"])
			automaton_template.get_neighborhood(0).set_quadrant_strings(Neighborhood.Quadrant.LOWER_RIGHT, ["00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "11000000", "01000000"])
			automaton_template.get_neighborhood(1).disable()
			automaton_template.get_neighborhood(2).disable()
			automaton_template.get_neighborhood(3).disable()

			automaton_template.name = "CUSTOM " + str(i).pad_zeros(3)

			var error2 = ResourceSaver.save(automaton_template, "user://automaton_cache/automaton_" + str(i).pad_zeros(3) + ".tres")

			if error2 != OK: print(error2)


	for i in range(100):
		automaton_cache.append(ResourceLoader.load("user://automaton_cache/automaton_" + str(i).pad_zeros(3) + ".tres", "Automaton", ResourceLoader.CACHE_MODE_IGNORE) as Automaton)

	active_automaton.reflect(automaton_cache[0])


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
	active_automaton = robot.duplicate(true)


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


func previous_automaton_index() -> void:
	automaton_index = max(0, automaton_index - 1)

	
func next_automaton_index() -> void:
	automaton_index = min(automaton_cache.size() - 1, automaton_index + 1)


func get_preset_name() -> String:
	return automaton_cache[automaton_index].name


func save_active_automaton_to_preset() -> void:
	var error = ResourceSaver.save(active_automaton.duplicate(true), automaton_cache[automaton_index].resource_path)

	if error != OK: print(error)


func load_automaton_from_preset() -> void:
	active_automaton.reflect(ResourceLoader.load(automaton_cache[automaton_index].resource_path, "Automaton", ResourceLoader.CACHE_MODE_IGNORE) as Automaton)

	loaded_preset.emit()
