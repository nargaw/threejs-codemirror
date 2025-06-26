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

//create a grid of dots
float grid(vec2 coords) {
  float rows = 15.0;
  vec2 gridCoords = fract(coords * rows);
  float shape = circle(gridCoords - 0.5, 0.25);
  return shape;
}

vec2 warpCoords(vec2 coords, float time) {
  float radius = length(coords);
  float angle = -atan(coords.x, coords.y) * 0.445;
  // vec2 warpedCoord = vec2(0.25 / radius + -time * 0.15, angle);
  vec2 warpedCoord = vec2(mod(0.25/ radius + time * 0.25, 1.), angle);
  return warpedCoord;
}

void main(void ) {
  vec2 coords = (gl_FragCoord.xy - u_resolution.xy * 0.5) / u_resolution.y;

  vec2 warpedCoords = warpCoords(coords, u_time);

  float dotGrid = grid(warpedCoords);

  vec3 color;

  color = mix(vec3(0.0, 1.0, 0.0), color, smoothstep(0.0, 0.1, dotGrid));

  float circleMask = length(coords);

  color = mix(vec3(0.0), color, smoothstep(0.0, 0.45, circleMask));

  gl_FragColor = vec4(color, 1.0);
}
