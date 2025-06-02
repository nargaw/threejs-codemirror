varying vec2 vUv;
uniform float u_time;
uniform vec2 u_resolution;

void main() {
  vec2 uv = (gl_FragCoord.xy - u_resolution.xy * 0.5) / u_resolution.y;
  
  vec2 vUv = uv;
  vec3 color = vec3(0.0);

  float an = -u_time * 0.15;
  float r1 = length(vUv);
  float a = atan(vUv.y, vUv.x);
  a = abs(a);
  // vUv = vec2(0.3 / r1 + 0.5 * u_time, a);
  vUv = vec2(0.3 / r1 + 0.5, a);


  float mask = length(uv) - 0.05;

  color = mix(vec3(vUv.x, vUv.y, .0), color, smoothstep(0.0, 0.5, mask));

  gl_FragColor = vec4(color, 1.0);
}
