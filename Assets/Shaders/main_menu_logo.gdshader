shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform sampler2D logo_texture : source_color, filter_nearest, repeat_disable;

uniform vec3 first_color : source_color = vec3(0.0);
uniform vec3 second_color : source_color = vec3(1.0);

//void vertex() {
	//// Called for every vertex the material is visible on.
//}

void fragment() {
	vec4 logo = textureLod(logo_texture, UV, 0.0);
	float screen_color = textureLod(screen_texture, SCREEN_UV, 0.0).x;
	
	if (logo.a > 0.0) {
		screen_color = 1.0 - screen_color;
	}
	
	COLOR = vec4(screen_color, screen_color, screen_color, logo.a);
}
