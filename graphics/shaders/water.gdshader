shader_type canvas_item;

uniform sampler2D depth: filter_linear;
uniform vec2 position;
uniform float size;
uniform float waves_sin_size: hint_range(0.0,1.0,0.0001);
uniform float waves_amplitude: hint_range(0.0, 1.0, 0.001);
uniform float gradient_sample_size: hint_range(0.0,1.0,0.01);
uniform vec3 color_shallow: source_color;
uniform vec3 color_deep: source_color;
uniform float water_depth: hint_range(0.0, 1.0, 0.001);
uniform sampler2D depth_noise: repeat_enable;
uniform float depth_noise_intensity;

uniform vec2 region_start;
uniform vec2 region_end;

uniform float foam: hint_range(0.0, 1.0, 0.001);
uniform vec3 foam_color: source_color;
uniform sampler2D foam_noise: repeat_enable;
uniform vec2 foam_noise_pan_speed;

void vertex() {
	// Called for every vertex the material is visible on.
}

vec2 getDepthIncreaseDirection(sampler2D depthMap, vec2 uv, vec2 texelSize) {
    // Sample the depth (alpha channel) at the current and neighboring texels
    float depthCenter = texture(depthMap, uv).a;
    float depthRight = texture(depthMap, uv + vec2(texelSize.x, 0.0)).a;
    float depthLeft = texture(depthMap, uv - vec2(texelSize.x, 0.0)).a;
    float depthUp = texture(depthMap, uv + vec2(0.0, texelSize.y)).a;
    float depthDown = texture(depthMap, uv - vec2(0.0, texelSize.y)).a;

    // Calculate the gradient
    vec2 gradient;
    gradient.x = depthRight - depthLeft;  // Horizontal gradient
    gradient.y = depthUp - depthDown;    // Vertical gradient

    // Normalize the gradient to get the direction
    return normalize(gradient);
}

void fragment() {
	vec2 uv = UV;

	uv.x *= abs(region_start.x - region_end.x);
	uv.y *= abs(region_start.y - region_end.y);

	uv += region_start;

	float d = texture(depth,uv).a + texture(depth_noise,UV).r * depth_noise_intensity;
	vec3 color = mix(color_deep,color_shallow,d);

	COLOR = vec4(color,1.0);

	float clipping_depth = texture(depth,uv).a;

	if(clipping_depth > water_depth + sin(TIME) * waves_amplitude) {
		COLOR.a = 0.0;
	}

	float approximate_distance_to_land = clipping_depth * 180.0;

	if((sin(approximate_distance_to_land - TIME) + 1.0) / 2.0 < 0.6 * texture(foam_noise,UV + TIME * foam_noise_pan_speed).r) {
		COLOR.rgb = mix(COLOR.rgb,foam_color,approximate_distance_to_land / 700.0 + 0.1);
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
