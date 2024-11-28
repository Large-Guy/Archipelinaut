shader_type canvas_item;

uniform float percentage: hint_range(0.0, 1.0) = 0.5;

void vertex() {
	// Called for every vertex the material is visible on.
}

float atan2(vec2 uv) {
	float x = uv.x;
	float y = uv.y;
    if (x > 0.0) {
        return atan(y / x);
    } else if (x < 0.0 && y >= 0.0) {
        return atan(y / x) + 3.14159265359;
    } else if (x < 0.0 && y < 0.0) {
        return atan(y / x) - 3.14159265359;
    } else if (x == 0.0 && y != 0.0) {
        return (y > 0.0 ? 1.57079632679 : -1.57079632679);
    }
    return 0.0; // When x == 0 and y == 0
}

void fragment() {
	vec2 centered = normalize(UV - vec2(0.5));

	float angle = atan2(centered) + PI / 2.0;

	if(angle > TAU) {
		angle -= TAU;
	}
	else if(angle < 0.0) {
		angle += TAU;
	}

	if(angle < percentage * TAU)
	{
		COLOR = vec4(0);
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
