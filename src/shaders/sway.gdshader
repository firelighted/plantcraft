shader_type canvas_item;


void fragment() {
	vec2 uv_2 = (UV +  cos(TIME)*0.01);
	COLOR = texture(TEXTURE, uv_2 );
}
