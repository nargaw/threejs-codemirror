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

// create a grid of dots
float grid(vec2 coords) {
  float rows = 50.0;
  vec2 a = floor(coords * rows);
  a += vec2(1.0, floor(u_time * 10.0 * randFloat(a.x)));
  vec2 b = fract(coords * rows);
  float str = randVec2(a);
  float shape = circle(b - 0.5, 0.25);
  return shape * str;
}

vec2 warpCoords(vec2 coords, float time) {
  float radius = length(coords); //get euclidean distance
  float angle = atan(coords.y, coords.x); //get angle in radians
  vec2 warpedCoord = vec2(0.25 / radius + u_time * 0.25, angle / PI); //polar coordinate as (radius, angle)
  return warpedCoord;
}

void main(void ) {
  vec2 coords = (gl_FragCoord.xy - u_resolution.xy * 0.5) / u_resolution.y;

  vec2 warpedCoords = warpCoords(coords, u_time);

  float dotGrid = grid(vec2(warpedCoords.y, warpedCoords.x));

  vec3 color;

  color = mix(vec3(0.0, 1.0, 0.0), color, smoothstep(-0.05, 0.0, dotGrid));

  float circleMask = length(coords);

  color = mix(vec3(0.0), color, smoothstep(0.0, 0.45, circleMask));

  gl_FragColor = vec4(color, 1.0);
}
