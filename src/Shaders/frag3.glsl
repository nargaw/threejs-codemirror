uniform float u_time;
uniform vec2 u_resolution;

#define PI (3.1415926538)

//Circle function
//The length function is a built in GLSL function that finds the Euclidean Distance from the center to each fragment
float circleSDF(vec2 coords, float radius) {
  return length(coords) - radius;
}

///create a Coordinate of grids
//first multiply by the gridSize
//second take only the fractional part of the coordinate system
vec2 convertToGrid(vec2 coords, float gridSize) {
  vec2 gridCoords = fract(coords * gridSize);
  return gridCoords;
}

//Convert from Cartesian coordinate system to a Polar Coordinate System
//first find length of each fragment from the center
//second find the angle in radians
//return (radius, angle) instead of (x, y)
vec2 toPolarCoords(vec2 coords, float time) {
  float radius = length(coords); //get euclidean distance
  float angle = atan(coords.y, coords.x); //get angle in radians
  vec2 polarCoords = vec2(0.25 / radius + time * 0.25, angle / PI); //polar coordinate as (radius, angle)
  return polarCoords;
}

void main(void ) {
  //Cartesian Coordinates of fragments
  vec2 coords = (gl_FragCoord.xy - u_resolution.xy * 0.5) / u_resolution.y;

  //Convert cartesian coordinates to polar coordinates
  vec2 polarCoords = toPolarCoords(coords, u_time);

  //Turn coordinates into a grid
  vec2 dotGridCoords = convertToGrid(polarCoords, 10.);

  //Draw circles inside gird of coordinates
  float circles = circleSDF(dotGridCoords - 0.5, 0.25);

  //Color Value
  vec3 color;

  //color the circles green and smooth the edges
  color = mix(vec3(0.0, 1.0, 0.0), color, smoothstep(0.0, 0.05, circles));

  //final shader output
  gl_FragColor = vec4(color, 1.0);
}
