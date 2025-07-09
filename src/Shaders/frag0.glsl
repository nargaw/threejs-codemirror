uniform float u_time;
uniform vec2 u_resolution;

#define PI (3.1415926538)

//Circle function
//The length function is a built in GLSL function that finds the Euclidean Distance
float circle(vec2 coords, float size) {
  return length(coords) - size;
}

//create a grid of dots
float grid(vec2 coords) {
  float gridSize = 10.0;
  vec2 gridCoords = fract(coords * gridSize);
  float shape = circle(gridCoords - 0.5, 0.25);
  return shape;
}

//Convert from Cartesian coordinate system to a Polar Coordinate System
vec2 toPolarCoords(vec2 coords, float time) {
  float radius = length(coords); //get euclidean distance
  float angle = atan(coords.y, coords.x); //get angle in radians
  vec2 polarCoords = vec2(0.25 / radius + time * 0.25, angle / PI); //polar coordinate as (radius, angle)
  return polarCoords;
}

void main(void ) {
  //Cartesian Coordinates of fragments
  vec2 coords = (gl_FragCoord.xy - u_resolution.xy * 0.5) / u_resolution.y;
  
  //instantiate color of fragments 
  vec3 color;
  
  //first convert to Polar Coordinate system
  vec2 polarCoords = toPolarCoords(coords, u_time);

  //second draw dot of grids on polar coordinate system
  float dotGrid = grid(polarCoords);

  //color dots
  color = mix(vec3(0.0, 1.0, 0.0), color, smoothstep(0.0, 0.05, dotGrid));

  //mask the moire effect on cartesian coords
  float circleMask = length(coords);
  color = mix(vec3(0.0), color, smoothstep(0.0, 0.45, circleMask));

  gl_FragColor = vec4(color, 1.0);
}
