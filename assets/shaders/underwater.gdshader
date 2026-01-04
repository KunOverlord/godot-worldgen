shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform vec4 tint_color : source_color = vec4(0.0, 0.4, 0.6, 0.3);
uniform float wave_speed = 3.0;
uniform float wave_freq = 10.0;
uniform float wave_amp = 0.005;
uniform float blur_amount : hint_range(0.0, 5.0) = 1.0;

void fragment() {
    // 1. Create a "Wavy" distortion for the screen UVs
    vec2 uv = SCREEN_UV;
    uv.x += sin(uv.y * wave_freq + TIME * wave_speed) * wave_amp;
    uv.y += cos(uv.x * wave_freq + TIME * wave_speed) * wave_amp;

    // 2. Sample the screen with the distorted UVs and blur
    vec3 color = textureLod(SCREEN_TEXTURE, uv, blur_amount).rgb;

    // 3. Mix with the underwater tint
    vec3 final_color = mix(color, tint_color.rgb, tint_color.a);

    COLOR = vec4(final_color, 1.0);
}