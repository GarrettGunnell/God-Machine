shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform vec3 first_color : source_color = vec3(0.0);
uniform vec3 second_color : source_color = vec3(1.0);

//void vertex() {
	//// Called for every vertex the material is visible on.
//}

void fragment() {
	float screen_color = textureLod(screen_texture, SCREEN_UV, 0.0).x;
	
	COLOR = vec4(mix(first_color, second_color, screen_color), 1.0);
}
