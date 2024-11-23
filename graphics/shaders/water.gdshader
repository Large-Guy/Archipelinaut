shader_type canvas_item;

uniform sampler2D noise;
uniform vec3 color_shallow: source_color;
uniform vec3 color_deep: source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR = vec4(color_shallow,1.0);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
