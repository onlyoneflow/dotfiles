// Smooth idle fade for the block cursor.
// This is intentionally separate from the movement/ripple shaders so the
// cursor can breathe without changing its size or position.

const float FADE_PERIOD = 1.10;
const float FADE_MINIMUM = 0.0;
const float CURSOR_CORNER_RADIUS = 0.0018;

vec2 cursor_normalize(vec2 value, float is_position) {
    return (value * 2.0 - iResolution.xy * is_position) / iResolution.y;
}

float cursor_rect(vec2 point, vec2 center, vec2 half_size) {
    vec2 edge = abs(point - center) - half_size + vec2(CURSOR_CORNER_RADIUS);
    return length(max(edge, 0.0)) + min(max(edge.x, edge.y), 0.0) - CURSOR_CORNER_RADIUS;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    fragColor = texture(iChannel0, fragCoord.xy / iResolution.xy);

    vec4 cursor = vec4(
        cursor_normalize(iCurrentCursor.xy, 1.0),
        cursor_normalize(iCurrentCursor.zw, 0.0)
    );
    cursor.z *= 0.84;
    vec2 center = cursor.xy - cursor.zw * vec2(-0.5, 0.5);
    float distance_to_cursor = cursor_rect(
        cursor_normalize(fragCoord, 1.0),
        center,
        cursor.zw * 0.5
    );
    float pixel = cursor_normalize(vec2(1.0), 0.0).x;
    float mask = 1.0 - smoothstep(-pixel, pixel, distance_to_cursor);

    // Smoothstep gives acceleration/deceleration rather than a hard blink.
    float phase = fract(iTime / FADE_PERIOD);
    float wave = 0.5 + 0.5 * sin(phase * 6.28318530718);
    float eased = wave * wave * (3.0 - 2.0 * wave);
    float opacity = mix(FADE_MINIMUM, 1.0, eased);

    // The cursor covers the cell underneath it. Replace the complete rounded
    // cursor footprint while fading, including its antialiased edge. This
    // prevents a bright outline from remaining when opacity reaches zero.
    vec4 terminal_background = vec4(0.0196078, 0.0196078, 0.0196078, 1.0);
    vec4 faded_cursor = mix(terminal_background, fragColor, opacity);
    fragColor = mix(fragColor, faded_cursor, mask);
}
