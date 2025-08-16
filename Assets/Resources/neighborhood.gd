extends Resource
class_name Neighborhood

@export var enabled = true
@export var spawn_range : Vector2i
@export var stable_range : Vector2i

enum Quadrant { UPPER_LEFT, UPPER_RIGHT, LOWER_LEFT, LOWER_RIGHT }

@export var quadrant_strings : Array = Array([[], [], [], []])

@export var neighborhood_bytes : PackedByteArray = PackedByteArray()

func _init() -> void:
	var empty_byte_string = "00000000"
	var empty_byte_strings = Array()
	empty_byte_strings.resize(8)
	empty_byte_strings.fill(empty_byte_string)

	spawn_range = Vector2(1, 1)
	stable_range = Vector2(0, 1)

	set_quadrant_strings(Quadrant.UPPER_LEFT, empty_byte_strings)
	set_quadrant_strings(Quadrant.UPPER_RIGHT, empty_byte_strings)
	set_quadrant_strings(Quadrant.LOWER_LEFT, empty_byte_strings)
	set_quadrant_strings(Quadrant.LOWER_RIGHT, empty_byte_strings)

	neighborhood_bytes.resize(32)

func get_spawn_range() -> Vector2i:
	if not enabled: return Vector2i(255, 255)
	return spawn_range


func get_stable_range() -> Vector2i:
	if not enabled: return Vector2i(0, 255)
	return stable_range

func set_ranges(v : Vector4i) -> void:
	spawn_range.x = v.x
	spawn_range.y = v.y
	stable_range.x = v.z
	stable_range.y = v.w

func add_to_spawn_range(v : Vector2i) -> void:
	spawn_range = spawn_range + v

	spawn_range.x = max(0, min(spawn_range.x, 255))
	spawn_range.y = max(0, min(spawn_range.y, 255))


func add_to_stable_range(v : Vector2i) -> void:
	stable_range = stable_range + v

	stable_range.x = max(0, min(stable_range.x, 255))
	stable_range.y = max(0, min(stable_range.y, 255))
	

func set_quadrant_strings(quadrant : Quadrant, byte_strings : Array) -> void:
	quadrant_strings[quadrant] = byte_strings.duplicate()

func get_quadrant_strings(quadrant : Quadrant) -> Array:
	return quadrant_strings[quadrant]


func encode_quadrant_byte(quadrant : Quadrant, value : int, byte_offset : int) -> void:
	var index = quadrant * 8 + byte_offset

	neighborhood_bytes.encode_u8(index, value)

func set_neighorhood_bytes(byte_array : PackedByteArray):
	neighborhood_bytes = byte_array.duplicate()


func get_neighborhood_bytes() -> PackedByteArray:
	return neighborhood_bytes

func enable() -> void:
	enabled = true

func disable() -> void:
	enabled = false

func is_enabled() -> bool:
	return enabled


func reflect(n : Neighborhood) -> void:
	self.enabled = n.enabled
	self.spawn_range = n.spawn_range
	self.stable_range = n.stable_range

	self.quadrant_strings[0] = n.quadrant_strings[0].duplicate()
	self.quadrant_strings[1] = n.quadrant_strings[1].duplicate()
	self.quadrant_strings[2] = n.quadrant_strings[2].duplicate()
	self.quadrant_strings[3] = n.quadrant_strings[3].duplicate()

	self.neighborhood_bytes = n.neighborhood_bytes.duplicate()
