extends Resource
class_name Automaton


@export var name : String = "NULL_NAME"


@export var neighborhoods : Array = Array()

func _init() -> void:
	neighborhoods.append(Neighborhood.new())
	neighborhoods.append(Neighborhood.new())
	neighborhoods.append(Neighborhood.new())
	neighborhoods.append(Neighborhood.new())


func add_neighborhood(n : Neighborhood) -> void:
	neighborhoods.append(n.duplicate(true))


func update_neighorhood(i : int, n : Neighborhood) -> void:
	if (neighborhoods.size() < i):
		push_error("Index out of bounds")
		return
	
	neighborhoods[i] = n.duplicate(true)


func get_neighborhoods() -> Array:
	return neighborhoods

func get_neighborhood(i : int) -> Neighborhood:
	return neighborhoods[i]

func get_rule_ranges() -> Array:
	var ranges : Array = Array()

	for neighborhood in neighborhoods:
		var spawn_range : Vector2i = neighborhood.get_spawn_range()
		var stable_range : Vector2i = neighborhood.get_stable_range()

		ranges.append_array([spawn_range.x, spawn_range.y, stable_range.x, stable_range.y])

	return ranges


func get_neighorhood_bytes() -> PackedByteArray:
	var byte_array = PackedByteArray()
	for neighborhood in neighborhoods:
		byte_array.append_array(neighborhood.get_neighborhood_bytes())

	return byte_array



func save_automaton_to_disk() -> void:
	var error = ResourceSaver.save(self, "user://" + name + ".tres")

	if error != OK: print(error)


func reflect(a : Automaton) -> void:
	self.name = a.name
	self.neighborhoods.clear()

	for i in a.neighborhoods:
		add_neighborhood(i)
