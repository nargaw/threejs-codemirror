uniform float u_time;
uniform vec2 u_resolution;

//Circle function
//The length function is a built in GLSL function that finds the Euclidean Distance from the center to each fragment
float circleSDF(vec2 coords, float size) {
  return length(coords) - size;
}

//create a Coordinate of grids
//first multiply by the gridSize
//second take only the fractional part of the coordinate system
vec2 convertToGrid(vec2 coords) {
  float gridSize = 10.0;
  vec2 gridCoords = fract(coords * gridSize);
  return gridCoords;
}

void main(void ) {
  //Cartesian Coordinates of fragments
  vec2 coords = (gl_FragCoord.xy - u_resolution.xy * 0.5) / u_resolution.y;

  //Turn coordinates into a grid
  vec2 dotGridCoords = convertToGrid(coords);

  //Draw circles inside gird of coordinates
  float circles = circleSDF(dotGridCoords - 0.5, 0.25);

  //Color Value
  vec3 color;

  //all fragments on the coordinate system that are 0 and negative will be colored green
  //all fragments on the coordinate system that are greater than 0 will be colored black
  circles <= 0.0
    ? color = vec3(0.0, 1.0, 0.0)
    : color = vec3(0.0, 0.0, 0.0);

  //visualize dotGridCoords
  gl_FragColor = vec4(vec2(dotGridCoords), 0.0, 1.0);

  //final shader output
  gl_FragColor = vec4(color, 1.0);
}
