extends Resource
class_name Neighborhood

@export var spawn_range : Vector2i
@export var stable_range : Vector2i


func get_spawn_range() -> Vector2i:
    return spawn_range


func get_stable_range() -> Vector2i:
    return stable_range


func add_to_spawn_range(v : Vector2i):
    spawn_range = spawn_range + v


func add_to_stable_range(v : Vector2i):
    stable_range = stable_range + v