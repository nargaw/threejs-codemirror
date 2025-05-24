varying vec2 vUv;
uniform float u_time;
uniform vec2 u_resolution;

void main() {
  vec2 uv = (gl_FragCoord.xy - u_resolution.xy * 0.5) / u_resolution.y;
  float radius = 0.25;

  // Compute distance from the center (origin)
  float dist = length(uv);

  // Signed Distance Field (SDF) for a circle
  float sdf = dist - radius;

  // Visualize: map distance to color
  vec3 color;
  color = mix(vec3(0.0, 1.0, 0.0), color, smoothstep(0.0, 0.005, abs(sdf)));
  gl_FragColor = vec4(color, 1.0);
}
