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
  float rows = 10.0;
  vec2 a = floor(vUv * rows);
  a += vec2(1.0, floor(u_time * 10.5 * randFloat(a.x)));
  vec2 b = fract(vUv * rows);
  vec2 newUv = 0.5 - b;
  float str = randVec2(a);

  float shape = circle(b - 0.5, 0.25);
  shape = 1.0 - smoothstep(0.0, 0.05, shape);

  return vec3(shape * str);
}

void main(void ) {
  vec2 position = (gl_FragCoord.xy - u_resolution.xy * 0.5) / u_resolution.y;

  vec2 newUv = position;
  float r1 = length(newUv);
  float a = -atan(newUv.x, newUv.y) * 0.445;
  newUv = vec2(0.25 / r1 + -u_time * 0.15, a);

  vec3 mat = matrix(vec2(newUv.y, newUv.x));
  vec3 color = vec3(0.0, 0.0, 0.0);

  color.g += mat.g;
  float x = length(position);
  color = mix(vec3(0.0), color, smoothstep(0.0, 0.45, x));
  gl_FragColor = vec4(color, 1.0);
}
