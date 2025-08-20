extends CompositorEffect
class_name AutomataCompositorEffect

@export var main_menu : bool = false

@export_range(0.001, 0.5) var update_speed = 0.05

var reseed = true

var rd : RenderingDevice
var exposure_compute : ACompute

var automaton_texture1 : RID
var automaton_texture2 : RID

var world_texture : RID

var previous_generation : RID
var next_generation : RID

var world_image_texture : ImageTexture

var timer = 0.0

var current_seed : int = 0
var needs_seeding = true

@export var cook_time = 1

func _init():
	effect_callback_type = EFFECT_CALLBACK_TYPE_POST_TRANSPARENT
	rd = RenderingServer.get_rendering_device()

	# To make use of an existing ACompute shader we use its filename to access it, in this case, the example compute shader file is 'exposure_example.acompute'
	exposure_compute = ACompute.new('automata')

	var automaton_resolution = 1024

	var automaton_format : RDTextureFormat = RDTextureFormat.new()

	automaton_format.height = automaton_resolution
	automaton_format.width = automaton_resolution
	automaton_format.format = RenderingDevice.DATA_FORMAT_R16_UNORM
	automaton_format.usage_bits = RenderingDevice.TEXTURE_USAGE_SAMPLING_BIT | RenderingDevice.TEXTURE_USAGE_STORAGE_BIT | RenderingDevice.TEXTURE_USAGE_CAN_COPY_FROM_BIT | RenderingDevice.TEXTURE_USAGE_CAN_COPY_TO_BIT 

	automaton_texture1 = rd.texture_create(automaton_format, RDTextureView.new(), [])
	automaton_texture2 = rd.texture_create(automaton_format, RDTextureView.new(), [])

	previous_generation = automaton_texture1
	next_generation = automaton_texture2

	needs_seeding = true

	var world_format : RDTextureFormat = RDTextureFormat.new()

	world_format.height = 1024
	world_format.width = 1024
	world_format.format = RenderingDevice.DATA_FORMAT_R8G8B8A8_UNORM
	world_format.usage_bits = RenderingDevice.TEXTURE_USAGE_SAMPLING_BIT | RenderingDevice.TEXTURE_USAGE_STORAGE_BIT | RenderingDevice.TEXTURE_USAGE_CAN_COPY_FROM_BIT | RenderingDevice.TEXTURE_USAGE_CAN_COPY_TO_BIT 

	world_texture = rd.texture_create(world_format, RDTextureView.new(), [])
	


func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		# ACompute will handle the freeing of any resources attached to it
		exposure_compute.free()
		rd.free_rid(automaton_texture1)
		rd.free_rid(automaton_texture2)
		rd.free_rid(world_texture)


func _render_callback(p_effect_callback_type, p_render_data):
	if not enabled: return
	if p_effect_callback_type != EFFECT_CALLBACK_TYPE_POST_TRANSPARENT: return
	
	if not rd:
		push_error("No rendering device")
		return
	
	var render_scene_buffers : RenderSceneBuffersRD = p_render_data.get_render_scene_buffers()

	if not render_scene_buffers:
		push_error("No buffer to render to")
		return

	
	var size = render_scene_buffers.get_internal_size()
	if size.x == 0 and size.y == 0:
		push_error("Rendering to 0x0 buffer")
		return
	
	var x_groups = (size.x - 1) / 8 + 1
	var y_groups = (size.y - 1) / 8 + 1
	var z_groups = 1

	if (GameMaster.get_reseed()):
		needs_seeding = true
		GameMaster.finish_reseed()

	# Vulkan has a feature known as push constants which are like uniform sets but for very small amounts of data
	var push_constant := PackedByteArray()
	
	var automaton = GameMaster.get_active_automaton()
	if not automaton: return

	# print("neighborhood_bytes: ")
	# print(neighborhood_bytes)
	push_constant.append_array(automaton.get_neighorhood_bytes())
	
	# print(push_constant)

	for view in range(render_scene_buffers.get_view_count()):
		var input_image = render_scene_buffers.get_color_layer(view)
		
		var uniform_array = PackedInt32Array(automaton.get_rule_ranges())
		uniform_array.append_array([GameMaster.get_seed() if not main_menu else 56745, GameMaster.get_zoom_setting() if not main_menu else 4, GameMaster.get_horizontal_offset(), GameMaster.get_vertical_offset()])

		exposure_compute.set_texture(0, world_texture if not main_menu else input_image)
		exposure_compute.set_texture(2, previous_generation)
		exposure_compute.set_texture(3, next_generation)
		exposure_compute.set_uniform_buffer(1, uniform_array.to_byte_array())
		exposure_compute.set_push_constant(push_constant)

		# Dispatch the compute kernel
		if (needs_seeding):
			exposure_compute.dispatch(0, 1024 / 8, 1024 / 8, 1)
			needs_seeding = false

			for i in range(0, cook_time - 1):
				exposure_compute.dispatch(1, 1024 / 8, 1024 / 8, 1)

				var temp : RID = previous_generation
				previous_generation = next_generation
				next_generation = temp

				exposure_compute.set_texture(2, previous_generation)
				exposure_compute.set_texture(3, next_generation)


		if (timer > GameMaster.get_time_setting()):
			timer = 0.0

			exposure_compute.dispatch(1, 1024 / 8, 1024 / 8, 1)

			var temp : RID = previous_generation
			previous_generation = next_generation
			next_generation = temp

		
		exposure_compute.dispatch(2, x_groups, y_groups, z_groups)

		if not GameMaster.is_paused():
			timer += Engine.get_main_loop().root.get_process_delta_time()

func set_seed(new_seed : int):
	current_seed = new_seed

func get_world_texture() -> RID:
	return world_texture;
