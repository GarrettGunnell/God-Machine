extends Node

var neighborhood : Neighborhood

func _ready() -> void:
	neighborhood = Neighborhood.new()


func get_spawn_range() -> Vector2i:
	return neighborhood.get_spawn_range()


func get_stable_range() -> Vector2i:
	return neighborhood.get_stable_range()
