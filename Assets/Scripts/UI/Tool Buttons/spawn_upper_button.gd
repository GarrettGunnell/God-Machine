extends AcerolaPanel

func _ready() -> void:
	draggable = true

func on_pressed() -> void:
	get_node("../../.").add_to_spawn_range(Vector2i(0, 1))


func on_alternate_pressed() -> void:
	get_node("../../.").add_to_spawn_range(Vector2i(0, -1))


func on_drag(motion : Vector2) -> void:
	get_node("../../.").add_to_spawn_range(Vector2i(0, -1 * sign(motion.y)))
