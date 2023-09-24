shader_type canvas_item;

uniform float invincibility_time : hint_range(0.1, 10.0) = 3.0;
uniform float flash_interval : hint_range(0.1, 2.0) = 0.2;

void fragment() {
    float time = mod(TIME, invincibility_time);
    float flash = mod(time, flash_interval) < (flash_interval * 0.5) ? 1.0 : 0.0;
    COLOR.a = flash;
}