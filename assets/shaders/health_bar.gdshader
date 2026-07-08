shader_type canvas_item;

uniform vec4 good_color : source_color;
uniform vec4 medium_color : source_color;
uniform vec4 bad_color : source_color;

uniform float good_threshold = 50.;
uniform float bad_threshold = 20.;

instance uniform float health_percent = 50.;

void fragment() {
	vec4 color_to_use = medium_color;
	if (health_percent > good_threshold){
		color_to_use = good_color;
	}
	if (health_percent < bad_threshold){
		color_to_use = bad_color;
	}
	
	vec4 input_color = texture(TEXTURE, UV);
	
	if (input_color[0] < health_percent/100.) {
		COLOR = color_to_use;
	} else {
		COLOR = vec4(0.,0.,0.,1.);
	}
}
