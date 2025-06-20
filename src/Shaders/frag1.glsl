varying vec2 vUv;
uniform float u_time;
uniform vec2 u_resolution;

void main() {
  //our coordinate system
  vec2 uv = (gl_FragCoord.xy - u_resolution.xy * 0.5) / u_resolution.y;
  //each point on this coordinate system is centered at (0, 0)

  // Visualize: map distance to color
  vec3 color; //(x, y, z or r, g, b)

  //circle sdf

  //radius
  float radius = abs(sin(u_time)) / 4.0 + 0.125;

  // Compute distance from the center (origin)
  float dist = length(uv) - radius;

  if (dist <= 0.0) {
    color = vec3(0.0, 1.0, 0.0);
  } else {
    color = vec3(1.0, 0.0, 0.0);
  }

  gl_FragColor = vec4(color, 1.0);
}
