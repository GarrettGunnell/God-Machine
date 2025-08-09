extends Node
class_name GameMaster

var automata_compositor_effect : CompositorEffect

var current_seed : int = 0

func _ready() -> void:
	var root_node = Engine.get_main_loop().root
	var environment = root_node.get_node_or_null("Node3D/WorldEnvironment")

	if not environment: 
		push_error("environment not found")
		return

	automata_compositor_effect = environment.compositor.compositor_effects[0]


func _process(delta: float) -> void:
	pass

func queue_reseed() -> void:
	automata_compositor_effect.reseed = true

func set_seed(new_seed : int) -> void:
	current_seed = new_seed
	automata_compositor_effect.set_seed(current_seed)

func get_seed() -> int:
	return current_seed
