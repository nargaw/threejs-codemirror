varying vec2 vUv;
uniform float u_time;
uniform vec2 u_resolution;

#define PI (3.1415926538)
#define TWO_PI (6.28318530718)

//Circle function
//The length function is a built in GLSL function that finds the Euclidean Distance
float circle(vec2 coords, float size) {
  return length(coords) - size;
}

float randFloat(float x) {
  return fract(sin(x) * 4748393.7585);
}

float randVec2(vec2 vUv) {
  return fract(sin(dot(vUv.yx, vec2(48.48929, 76.83929))) * 727827.3738);
}

vec3 matrix(vec2 vUv) {
  float rows = 15.0;
  vec2 a = floor(vUv * rows);
  a += vec2(1.0, floor(u_time * 10.0 * randFloat(a.x)));
  vec2 b = fract(vUv * rows);
  float str = randVec2(a);
  float shape = circle(b - 0.5, 0.25);
  shape = 1.0 - smoothstep(0.0, 0.05, shape);
  return vec3(shape * str);
}

vec2 warpUv(vec2 uv, float time) {
  float r1 = length(uv);
  float a = -atan(uv.x, uv.y) * 0.445;
  vec2 vUv = vec2(0.25 / r1 + -time * 0.15, a);
  return vUv;
}

void main(void ) {
  vec2 position = (gl_FragCoord.xy - u_resolution.xy * 0.5) / u_resolution.y;

  vec2 newUv = position;
  newUv = warpUv(newUv, u_time);

  vec3 mat = matrix(vec2(newUv.y, newUv.x));
  vec3 color = vec3(0.0, 0.0, 0.0);

  color.g += mat.g;
  float x = length(position);
  color = mix(vec3(0.0), color, smoothstep(0.0, 0.45, x));
  gl_FragColor = vec4(color, 1.0);
}
