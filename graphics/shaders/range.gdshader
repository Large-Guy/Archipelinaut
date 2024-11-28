shader_type canvas_item;

uniform float radius;
uniform vec4 fill: source_color;
uniform vec4 outline: source_color;

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
	COLOR = vec4(0);
	if(distance(UV,vec2(0.5)) < radius)
	{
		COLOR = fill;

		int angle = int(floor((atan2(UV - vec2(0.5)) + TIME) * 7.0)) % 2;

		float size = 0.015;

		if(distance(UV,vec2(0.5)) > radius-size && angle == 0)
		{
			COLOR = outline;
		}
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
