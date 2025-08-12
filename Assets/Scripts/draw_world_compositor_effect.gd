@tool
extends CompositorEffect
class_name DrawWorldEffect


var rd : RenderingDevice

@export var transform : Transform3D
var light : DirectionalLight3D

var p_framebuffer : RID
var cached_framebuffer_format : int

var p_render_pipeline : RID
var p_render_pipeline_uniform_set : RID
var p_wire_render_pipeline : RID
var p_vertex_buffer : RID
var vertex_format : int
var p_vertex_array : RID
var p_index_buffer : RID
var p_index_array : RID
var p_shader : RID
var p_sampler_state : RID
var clear_colors := PackedColorArray([Color.DARK_BLUE])

var root_node : Node
var compositor : Compositor

var world_texture_rid : RID

func _init():
	effect_callback_type = EFFECT_CALLBACK_TYPE_POST_TRANSPARENT
	rd = RenderingServer.get_rendering_device()



func compile_shader(vertex_shader : String, fragment_shader : String) -> RID:
	var src := RDShaderSource.new()
	src.source_vertex = vertex_shader
	src.source_fragment = fragment_shader
	
	var shader_spirv : RDShaderSPIRV = rd.shader_compile_spirv_from_source(src)
	
	var err = shader_spirv.get_stage_compile_error(RenderingDevice.SHADER_STAGE_VERTEX)
	if err: push_error(err)
	err = shader_spirv.get_stage_compile_error(RenderingDevice.SHADER_STAGE_FRAGMENT)
	if err: push_error(err)
	
	var shader : RID = rd.shader_create_from_spirv(shader_spirv)
	
	return shader

func initialize_render(framebuffer_format : int):
	var side_length = 2

	p_shader = compile_shader(source_vertex, source_fragment)

	var vertex_buffer := PackedFloat32Array([])

	# Generate plane vertices on the xz plane
	for x in side_length:
		for z in side_length:
			var xz : Vector2 = Vector2(x, z) * Vector2(0.9481, 0.9481)

			var pos : Vector3 = Vector3(xz.x, xz.y, 0)

			# Vertex color is not used but left as a demonstration for adding more vertex attributes
			var color : Vector4 = Vector4(x, z, randf(), 1)

			# For some reason godot doesn't make it easy to append vectors to arrays
			for i in 3: vertex_buffer.push_back(pos[i])
			for i in 4: vertex_buffer.push_back(color[i])



	var vertex_count = vertex_buffer.size() / 7


	var index_buffer := PackedInt32Array([])


	for row in range(0, side_length * side_length - side_length, side_length):
		for i in side_length - 1:
			var v = i + row # shift to row we're actively triangulating

			var v0 = v
			var v1 = v + side_length
			var v2 = v + side_length + 1
			var v3 = v + 1

			index_buffer.append_array([v0, v1, v3, v1, v2, v3])

	
	var vertex_buffer_bytes : PackedByteArray = vertex_buffer.to_byte_array()
	p_vertex_buffer = rd.vertex_buffer_create(vertex_buffer_bytes.size(), vertex_buffer_bytes)
	
	var vertex_buffers := [p_vertex_buffer, p_vertex_buffer]
	
	var sizeof_float := 4
	var stride := 7
	
	# The GPU needs to know the memory layout of the vertex data, in this case each vertex has a position (3 component vector) and a color (4 component vector)
	var vertex_attrs = [RDVertexAttribute.new(), RDVertexAttribute.new()]
	vertex_attrs[0].format = rd.DATA_FORMAT_R32G32B32_SFLOAT
	vertex_attrs[0].location = 0
	vertex_attrs[0].offset = 0
	vertex_attrs[0].stride = stride * sizeof_float

	vertex_attrs[1].format = rd.DATA_FORMAT_R32G32B32A32_SFLOAT
	vertex_attrs[1].location = 1
	vertex_attrs[1].offset = 3 * sizeof_float
	vertex_attrs[1].stride = stride * sizeof_float

	vertex_format = rd.vertex_format_create(vertex_attrs)


	p_vertex_array = rd.vertex_array_create(vertex_buffer.size() / stride, vertex_format, vertex_buffers)

	var index_buffer_bytes : PackedByteArray = index_buffer.to_byte_array()
	p_index_buffer = rd.index_buffer_create(index_buffer.size(), rd.INDEX_BUFFER_FORMAT_UINT32, index_buffer_bytes)
	p_index_array = rd.index_array_create(p_index_buffer, 0, index_buffer.size())

	var sampler_state := RDSamplerState.new()
	p_sampler_state = rd.sampler_create(sampler_state)
	

	initialize_render_pipelines(framebuffer_format)


func initialize_render_pipelines(framebuffer_format : int) -> void:
	var raster_state = RDPipelineRasterizationState.new()
	
	raster_state.cull_mode = RenderingDevice.POLYGON_CULL_BACK
	raster_state.front_face = RenderingDevice.POLYGON_FRONT_FACE_COUNTER_CLOCKWISE
	
	var depth_state = RDPipelineDepthStencilState.new()
	
	depth_state.enable_depth_write = true
	depth_state.enable_depth_test = true
	depth_state.depth_compare_operator = RenderingDevice.COMPARE_OP_GREATER
	
	var blend = RDPipelineColorBlendState.new()
	
	blend.attachments.push_back(RDPipelineColorBlendStateAttachment.new())

	p_render_pipeline = rd.render_pipeline_create(p_shader, framebuffer_format, vertex_format, rd.RENDER_PRIMITIVE_TRIANGLES, raster_state, RDPipelineMultisampleState.new(), depth_state, blend)

var regenerate = true
var uniform_buffer_data = Array()
func _render_callback(_effect_callback_type : int, render_data : RenderData):
	if not enabled: return
	if _effect_callback_type != effect_callback_type: return

	root_node = Engine.get_main_loop().root
	var environment = root_node.get_node_or_null("Node3D/WorldEnvironment")

	if not environment: return

	compositor = environment.compositor

	if (compositor.compositor_effects.size() > 1):
		world_texture_rid = compositor.compositor_effects[0].get_world_texture()
	
	var render_scene_buffers : RenderSceneBuffersRD = render_data.get_render_scene_buffers()
	var render_scene_data : RenderSceneData = render_data.get_render_scene_data()
	
	if not render_scene_buffers: return

	if regenerate or not p_render_pipeline.is_valid():
		_notification(NOTIFICATION_PREDELETE)
		p_framebuffer = FramebufferCacheRD.get_cache_multipass([render_scene_buffers.get_color_texture(), render_scene_buffers.get_depth_texture()], [], 1)
		initialize_render(rd.framebuffer_get_format(p_framebuffer))
		regenerate = false

	var current_framebuffer = FramebufferCacheRD.get_cache_multipass([render_scene_buffers.get_color_texture(), render_scene_buffers.get_depth_texture()], [], 1)

	# If the framebuffer has changed then we need to reinitialize the render pipeline objects, this happens when the editor window changes or the game window changes
	if p_framebuffer != current_framebuffer:
		p_framebuffer = current_framebuffer
		initialize_render_pipelines(rd.framebuffer_get_format(p_framebuffer))

	if uniform_buffer_data.size() == 0:
		var model = transform
		var view = render_scene_data.get_cam_transform().inverse()
		var projection = render_scene_data.get_view_projection(0)

		var model_view = Projection(view * model)
		var MVP = projection * model_view;
		
		for i in range(0,16):
			uniform_buffer_data.push_back(MVP[i / 4][i % 4])
	

		# All of our settings are stored in a single uniform buffer, certainly not the best decision, but it's easy to work with
		var buffer_bytes : PackedByteArray = PackedFloat32Array(uniform_buffer_data).to_byte_array()

		var p_uniform_buffer_rid : RID = rd.uniform_buffer_create(buffer_bytes.size(), buffer_bytes)


		var uniforms = []
		var uniform_buffer_uniform := RDUniform.new()
		
		# The gpu needs to know the layout of the uniform variables, even though we have many variables here on the cpu, they're all in one uniform buffer, and so there is technically only one shader uniform
		uniform_buffer_uniform.binding = 0
		uniform_buffer_uniform.uniform_type = rd.UNIFORM_TYPE_UNIFORM_BUFFER
		uniform_buffer_uniform.add_id(p_uniform_buffer_rid)
		uniforms.push_back(uniform_buffer_uniform)

		var world_texture_uniform := RDUniform.new()
		world_texture_uniform.binding = 1
		world_texture_uniform.uniform_type = rd.UNIFORM_TYPE_SAMPLER_WITH_TEXTURE
		world_texture_uniform.add_id(p_sampler_state)
		world_texture_uniform.add_id(world_texture_rid)
		uniforms.push_back(world_texture_uniform)
		
		# Currently we just free the previously instantiated uniform set and then make a new one, ideally this is only done when the uniform variables change
		if p_render_pipeline_uniform_set.is_valid():
			rd.free_rid(p_render_pipeline_uniform_set)
		
		p_render_pipeline_uniform_set = rd.uniform_set_create(uniforms, p_shader, 0)

	# If you frame capture the program with something like NVIDIA NSight you will see this label show up so you can easily see the render time of the terrain
	rd.draw_command_begin_label("Terrain Mesh", Color(1.0, 1.0, 1.0, 1.0))

	# The rest of this code is the creation of the draw call command list whether we are doing wireframe mode or not
	var draw_list = rd.draw_list_begin(p_framebuffer, rd.DRAW_IGNORE_ALL, clear_colors, 1.0,  0,  Rect2(), 0)

	rd.draw_list_bind_render_pipeline(draw_list, p_render_pipeline)
		
	rd.draw_list_bind_vertex_array(draw_list, p_vertex_array)

	rd.draw_list_bind_index_array(draw_list, p_index_array)

	rd.draw_list_bind_uniform_set(draw_list, p_render_pipeline_uniform_set, 0)
	rd.draw_list_draw(draw_list, true, 1)
	rd.draw_list_end()

	rd.draw_command_end_label()
	


func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		if p_render_pipeline.is_valid():
			rd.free_rid(p_render_pipeline)
		if p_wire_render_pipeline.is_valid():
			rd.free_rid(p_wire_render_pipeline)
		if p_vertex_array.is_valid():
			rd.free_rid(p_vertex_array)
		if p_vertex_buffer.is_valid():
			rd.free_rid(p_vertex_buffer)
		if p_index_array.is_valid():
			rd.free_rid(p_index_array)
		if p_index_buffer.is_valid():
			rd.free_rid(p_index_buffer)
		if p_sampler_state.is_valid():
			rd.free_rid(p_sampler_state)


const source_vertex = "
		#version 450

		layout(set = 0, binding = 0, std140) uniform UniformBufferObject {
			mat4 MVP;
		};

		layout(set = 0, binding = 1) uniform sampler2D _WorldTexture;
		
		layout(location = 0) in vec3 a_Position;
		layout(location = 1) in vec4 a_Color;

		layout(location = 2) out vec3 v_uv;

		
		void main() {
			v_uv = a_Color.rgb;

			vec3 pos = a_Position;
			
			gl_Position = MVP * vec4(pos, 1);
		}
		"


const source_fragment = "
		#version 450

		layout(set = 0, binding = 0, std140) uniform UniformBufferObject {
			mat4 MVP;
		};
		
		layout(set = 0, binding = 1) uniform sampler2D _WorldTexture;
		
		layout(location = 2) in vec3 v_uv;
		
		layout(location = 0) out vec4 frag_color;

		
		void main() {
			float cell = texture(_WorldTexture, v_uv.xy).r;

			frag_color = vec4(cell, cell, cell, 1.0);
		}
		"
