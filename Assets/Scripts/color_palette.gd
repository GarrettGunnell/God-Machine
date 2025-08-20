extends ColorRect

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	GameMaster.seed_changed.connect(new_palette)

	new_palette()


func new_palette() -> void:
	rng.set_seed(hash(GameMaster.get_seed()))

	var palette_type = rng.randi_range(0, 2)

	if palette_type == 0: monochromatic()
	if palette_type == 1: complementary()
	if palette_type == 2: tertiary()


func monochromatic() -> void:
	var hue = rng.randf()

	var color1 = Color.from_ok_hsl(hue, rng.randf_range(0.1, 0.9), rng.randf_range(0.05, 0.4))
	var color2 = Color.from_ok_hsl(hue, rng.randf_range(0.1, 0.9), rng.randf_range(0.5, 0.9))

	material.set_shader_parameter("first_color", Vector3(color1.r, color1.g, color1.b))
	material.set_shader_parameter("second_color", Vector3(color2.r, color2.g, color2.b))




func complementary() -> void:
	var hue = rng.randf()

	var color1 = Color.from_ok_hsl(hue, rng.randf_range(0.1, 0.9), rng.randf_range(0.05, 0.4))
	var color2 = Color.from_ok_hsl(hue, rng.randf_range(0.1, 0.9), rng.randf_range(0.5, 0.9))

	var which_color_is_complemented = rng.randf()

	if (which_color_is_complemented > 0.5): color1.ok_hsl_h = color1.ok_hsl_h + 0.5
	else: color2.ok_hsl_h = color2.ok_hsl_h + 0.5


	material.set_shader_parameter("first_color", Vector3(color1.r, color1.g, color1.b))
	material.set_shader_parameter("second_color", Vector3(color2.r, color2.g, color2.b))


func tertiary() -> void:
	var hue = rng.randf()

	var color1 = Color.from_ok_hsl(hue, rng.randf_range(0.1, 0.9), rng.randf_range(0.05, 0.4))
	var color2 = Color.from_ok_hsl(hue, rng.randf_range(0.1, 0.9), rng.randf_range(0.5, 0.9))

	var which_color_is_tertiary = rng.randf()
	var color_distance = rng.randf_range(0.05, 0.25)
	var direction = rng.randf()
	if (direction < 0.5): color_distance *= -1.0

	if (which_color_is_tertiary > 0.5): color1.ok_hsl_h = color1.ok_hsl_h + color_distance
	else: color2.ok_hsl_h = color2.ok_hsl_h + color_distance


	material.set_shader_parameter("first_color", Vector3(color1.r, color1.g, color1.b))
	material.set_shader_parameter("second_color", Vector3(color2.r, color2.g, color2.b))
