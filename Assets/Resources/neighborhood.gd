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


func get_neighborhood_bytes() -> PackedByteArray:
	return neighborhood_bytes

func enable() -> void:
	enabled = true

func disable() -> void:
	enabled = false

func is_enabled() -> bool:
	return enabled
