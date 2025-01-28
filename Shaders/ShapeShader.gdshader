shader_type canvas_item;

uniform int shape = 0;
uniform float poly_count = 3.0;
uniform float radius_scalor : hint_range(0.0, 1.0, 0.01) = 1.0;
uniform bool stroke_only  = false;

uniform vec4 my_color : source_color = vec4(1.0,1.0,1.0,1.0);

uniform int blending_mode :hint_range(-1, 10, 1) = -1;

//uniform float masking_range = 0.1;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

vec4 multiply(vec4 base, vec4 blend){return base * blend;}
vec4 screen(vec4 base, vec4 blend){return 1.0 - (1.0 - base) * (1.0 - blend);}
vec4 darken(vec4 base, vec4 blend){return min(base, blend);}
vec4 lighten(vec4 base, vec4 blend){return max(base, blend);}
vec4 difference(vec4 base, vec4 blend){return abs(base - blend);}
vec4 overlay(vec4 base, vec4 blend){
	vec4 limit = step(0.5, base);
	return mix(2.0 * base * blend, 1.0 - 2.0 * (1.0 - base) * (1.0 - blend), limit);}
vec4 exclusion(vec4 base, vec4 blend){return base + blend - 2.0 * base * blend;}
vec4 hard_light(vec4 base, vec4 blend){
	vec4 limit = step(0.5, blend);
	return mix(2.0 * base * blend, 1.0 - 2.0 * (1.0 - base) * (1.0 - blend), limit);}
vec4 soft_light(vec4 base, vec4 blend){
	vec4 limit = step(0.5, blend);
	return mix(2.0 * base * blend + base * base * (1.0 - 2.0 * blend), sqrt(base) * (2.0 * blend - 1.0) + (2.0 * base) * (1.0 - blend), limit);}
vec4 color_burn(vec4 base, vec4 blend){return 1.0 - (1.0 - base) / blend;}
vec4 linear_burn (vec4 base, vec4 blend){return base + blend - 1.0;}
vec4 color_dodge(vec4 base, vec4 blend){return base / (1.0 - blend);}
vec4 linear_dodge(vec4 base, vec4 blend){return base+blend;}


float Circle(vec2 st)
{
	vec2 center = vec2(0.5) - st;
	if(stroke_only){
		float draw = step(length(center), 0.5);
		float draw1 = step(length(center)/radius_scalor, 0.5);
		return draw-draw1;}
	else{
		float draw = step(length(center)/radius_scalor, 0.5);
		return draw;}
}

float Square(vec2 st)
{
	st = st*2.0 - 1.0;
	vec2 abs_uv = abs(st.xy);

	//if (stroke_only){width =1.0*radius_scalor;}
	//else {width = (1.0-radius_scalor);}
	float draw = step(1.0*radius_scalor, max(abs_uv.x, abs_uv.y));
	if(stroke_only){return draw;}
	else{ return 1.0-draw;}
}

float Triangle(vec2 st, float width)
{
	st = st * 2.0 - 1.0;

	if (poly_count > 2.0)
	{
		if (poly_count < 4.0)
		{
			st.y += 0.25;
		}
	}

	float angle = atan(st.x, st.y) + radians(180.0);
	float radius = TAU / float(poly_count);

	float dist = cos(floor(0.5 + angle / radius) * radius - angle) * length(st);
	float poly = step(width, dist);
	dist /= radius_scalor;
	float poly1 = step(width, dist);

	if(stroke_only){return (1.0-poly)-(1.0-poly1);}
	else{ return 1.0-poly1;}
}

void fragment()
{
	vec4 world_pixel = texture(SCREEN_TEXTURE, SCREEN_UV);

	vec2 st = UV;
	st.y = 1.0 - st.y;

	float sh;

	if (shape == 1){sh = Circle(st);}
	else if (shape == 0){sh = Square(st);}
	else if (shape == 2){sh = Triangle(st, 0.5);}

	vec4 color = vec4(sh/radius_scalor);
	color = 1.0 - color;
	float alpha = 1.0 - color.r;
	color = 1.0 - color;
	color.a = alpha;

	color *= my_color;


	if (blending_mode == 0) {color = multiply(color, world_pixel);}
	else if (blending_mode == 1) {color = multiply(color, world_pixel);}
	else if (blending_mode == 2) {color = screen(color, world_pixel);}
	else if (blending_mode == 3) {color = darken(color, world_pixel);}
	else if (blending_mode == 4) {color = lighten(color, world_pixel);}
	else if (blending_mode == 5) {color = difference(color, world_pixel);}
	else if (blending_mode == 6) {color = exclusion(color, world_pixel);}
	else if (blending_mode == 7) {color = overlay(color, world_pixel);}
	else if (blending_mode == 8) {color = hard_light(color, world_pixel);}
	else if (blending_mode == 9) {color = soft_light(color, world_pixel);}
	else if (blending_mode == 10) {color = color_dodge(color, world_pixel);}
	else if (blending_mode == 11) {color = linear_dodge(color, world_pixel);}
	else if (blending_mode == 12) {color = color_burn(color, world_pixel);}
	else if (blending_mode == 13) {color = linear_burn(color, world_pixel);}




	COLOR = color;

}