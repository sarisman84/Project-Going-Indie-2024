shader_type spatial;

render_mode blend_mix;

group_uniforms Settings;
uniform float grid_scale = 50.0;
uniform float line_width = 0.01;
uniform vec4 gridColor : source_color = vec4(1.0);
uniform vec4 backgroundColor : source_color = vec4(1.0);

group_uniforms ScriptParams;
uniform vec3 plane_pos;
uniform vec2 plane_size;

float pristineGrid(vec2 uv, vec2 lineWidth) {
    vec2 ddx = dFdx(uv);
    vec2 ddy = dFdy(uv);
    vec2 uvDeriv = vec2(length(vec2(ddx.x, ddy.x)), length(vec2(ddx.y, ddy.y)));
    bvec2 invertLine = bvec2(lineWidth.x > 0.5, lineWidth.y > 0.5);
    vec2 targetWidth = vec2(
        invertLine.x ? .0 - lineWidth.x : lineWidth.x,
        invertLine.y ? 1.0 - lineWidth.y : lineWidth.y
    );
    vec2 drawWidth = clamp(targetWidth, uvDeriv, vec2(0.5));
    vec2 lineAA = uvDeriv * 1.5;
    vec2 gridUV = abs(fract(uv) * 2.0 - 1.0);
    gridUV.x = invertLine.x ? gridUV.x : 1.0 - gridUV.x;
    gridUV.y = invertLine.y ? gridUV.y : 1.0 - gridUV.y;
    vec2 grid2 = smoothstep(drawWidth + lineAA, drawWidth - lineAA, gridUV);

    grid2 *= clamp(targetWidth / drawWidth, 0.0, 1.0);
    grid2 = mix(grid2, targetWidth, clamp(uvDeriv * 2.0 - 1.0, 0.0, 1.0));
    grid2.x = invertLine.x ? 1.0 - grid2.x : grid2.x;
    grid2.y = invertLine.y ? 1.0 - grid2.y : grid2.y;
    return mix(grid2.x, 1.0, grid2.y);
}

void fragment() {
	// Adjust this to control the number of grid lines
    vec2 scaledUV = UV * grid_scale;

    // Adjust line width as needed
    vec2 lineWidth = vec2(line_width); 

    // Generate the grid pattern
    float gridValue = pristineGrid(scaledUV, lineWidth);

	vec3 cam_pos_local = plane_pos - CAMERA_POSITION_WORLD;
	vec2 cam_uv = vec2(0.5f + cam_pos_local.x / plane_size.x, 0.5f + cam_pos_local.z / plane_size.y);
    // Calculate distance falloff
	float centerDistance = length(UV - cam_uv);
    float falloffStart = 0.0; // Start of the falloff
    float falloffEnd = 0.5; // End of the falloff, after which the grid is completely faded out
    float falloff = 0.25 - smoothstep(falloffStart, falloffEnd, centerDistance);
    falloff = clamp(falloff, 0.0, 1.0); // Ensure falloff doesn't go below 0

    // Apply the distance falloff to the grid value
    float finalGridValue = gridValue * falloff;

    ALBEDO = vec3(finalGridValue) * gridColor.rgb + backgroundColor.rgb;
    ALPHA = gridValue * falloff + backgroundColor.a;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
