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
  float rows = 10.0;
  vec2 gridCoords = fract(coords * rows);
  float shape = circle(gridCoords - 0.5, 0.25);
  return shape;
}

vec2 gridCoordsVisual(vec2 coords) {
  float gridSize = 3.0;
  vec2 gridCoords = fract(coords * gridSize);
  return gridCoords;
}

void main(void ) {
  vec2 coords = (gl_FragCoord.xy - u_resolution.xy * 0.5) / u_resolution.y;
  coords += 0.5;
  float dotGrid = grid(coords);

  vec3 color;

  // dotGrid <= 0.0 ? color = vec3(0., 1., 0.) : color = vec3(0.);
  color = mix(vec3(0.0, 1.0, 0.0), color, smoothstep(0.0, 0.05, dotGrid));

  vec2 newCoords = gridCoordsVisual(coords);

  gl_FragColor = vec4(vec2(newCoords), 0.0, 1.0);
  gl_FragColor = vec4(vec2(coords), 0.0, 1.0);
  gl_FragColor = vec4(color, 1.0);
}
