shader_type canvas_item;
const int width = 8;
const int height = 8;

uniform int tiles[64];

void vertex() {
	// Called for every vertex the material is visible on.
}

float sample(vec2 point)
{
	point.x *= float(width);
	point.y *= float(height);
	return float(tiles[int(point.y) * width + int(point.x)]);
}

void fragment() {
	COLOR = vec4(0);

	float tileW = 1.0/float(width);
	float tileH = 1.0/float(height);

	float ctl = sample(UV + vec2(-tileH, -tileW));
	float ctc = sample(UV + vec2(-tileH, 0));
	float ctr = sample(UV + vec2(-tileH, tileW));

	float ccl = sample(UV + vec2(0, -tileW));
	float ccc = sample(UV);
	float ccr = sample(UV + vec2(0, tileW));

	float cbl = sample(UV + vec2(tileH, -tileW));
	float cbc = sample(UV + vec2(tileH, 0));
	float cbr = sample(UV + vec2(tileH, tileW));

	//Average
	float avg = ctl + ctc + ctr + ccl + ccc + ccr + cbl + cbc + cbr;
	avg /= 9.0;

	COLOR = vec4(avg);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
