shader_type canvas_item;

uniform float scale : hint_range(0, 1) = 1.0;
uniform vec4 color : source_color;

void fragment() {

	vec2 uvCoords = UV;
	vec2 middleCoords = vec2(0.5, 0.5);

	float dist = distance(uvCoords,middleCoords);

	if (dist <= scale)
	{
		vec4 c = texture(TEXTURE, UV);
		COLOR = c * color;
	}
	else
	{
		COLOR = vec4(0,0,0,0);
	}


	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
