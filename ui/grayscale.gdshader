shader_type canvas_item;

uniform float enabled = 0.0;
uniform float alpha = 0.0;

void fragment() {
	vec4 main_tx = texture(TEXTURE, UV);
    float avg = (main_tx.r + main_tx.g + main_tx.b) / 3.0;
	COLOR.rgb = main_tx.rgb * (1.0 - enabled) + vec3(avg) * enabled;
	COLOR.a = main_tx.a - (1.0 - alpha);
}
