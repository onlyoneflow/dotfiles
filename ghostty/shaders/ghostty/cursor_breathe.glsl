// A small, always-running breathing halo for the terminal cursor.
// The base cursor remains crisp; the halo expands and contracts around it.

vec2 normalize_cursor(vec2 value, float isPosition) {
    return (value * 2.0 - (iResolution.xy * isPosition)) / iResolution.y;
}

float rectangle_sdf(vec2 point, vec2 center, vec2 half_size) {
    vec2 distance_to_edge = abs(point - center) - half_size;
    return length(max(distance_to_edge, 0.0)) + min(max(distance_to_edge.x, distance_to_edge.y), 0.0);
}

float antialias_cursor(float distance_value) {
    float pixel = normalize_cursor(vec2(1.2), 0.0).x;
    return 1.0 - smoothstep(-pixel, pixel, distance_value);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    fragColor = texture(iChannel0, fragCoord.xy / iResolution.xy);

    vec4 cursor = vec4(
        normalize_cursor(iCurrentCursor.xy, 1.0),
        normalize_cursor(iCurrentCursor.zw, 0.0)
    );

    vec2 center = cursor.xy - cursor.zw * vec2(-0.5, 0.5);
    float pulse = 0.5 + 0.5 * sin(iTime * 7.0);
    float expansion = mix(0.0, 2.2, pulse);
    vec2 half_size = cursor.zw * 0.5 + vec2(expansion) / iResolution.y;
    float distance_value = rectangle_sdf(
        normalize_cursor(fragCoord, 1.0),
        center,
        half_size
    );

    // Only draw a thin breathing outline, so the normal cursor stays readable.
    float inner_distance = rectangle_sdf(
        normalize_cursor(fragCoord, 1.0),
        center,
        max(cursor.zw * 0.5 + vec2(expansion - 1.4) / iResolution.y, vec2(0.0))
    );
    float ring = antialias_cursor(distance_value) * (1.0 - antialias_cursor(inner_distance));
    vec4 pulse_color = vec4(iCurrentCursorColor.rgb, 0.75 * (1.0 - pulse * 0.55));
    fragColor = mix(fragColor, pulse_color, ring);
}
