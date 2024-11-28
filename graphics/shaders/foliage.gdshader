shader_type canvas_item;

uniform float tree_height = -200;
uniform vec2 wind;


void vertex() {
	// Normalized vertex height (assuming the tree height is 1.0)
	float heightFactor = -VERTEX.y / tree_height; // If not normalized, divide by the tree height

	// Apply a smooth easing function
	float bendFactor = pow(heightFactor, 1.5); // Or try pow(heightFactor, 1.25)

	// Modify the vertex position
	VERTEX += (wind) * bendFactor;

}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
