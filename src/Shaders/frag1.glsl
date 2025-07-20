uniform float u_time;
uniform vec2 u_resolution;

//Circle function
//The length function is a built in GLSL function that finds the Euclidean Distance from the center to each fragment
float circleSDF(vec2 coords, float size) {
  return length(coords) - size;
}

void main() {
  //Cartesian Coordinates of fragments
  //the center is (0, 0)
  vec2 coords = (gl_FragCoord.xy - u_resolution.xy * 0.5) / u_resolution.y;

  //Color of fragments
  //(r, g, b) - vector 3
  vec3 color;

  //radius
  float radius = 0.25;

  //inside the circle is negative
  //outside the circle is positive
  //on the cirlce is 0
  float circle = circleSDF(coords, radius);

  //all fragments on the coordinate system that are 0 and negative will be colored green
  //all fragments on the coordinate system that are greater than 0 will be colored black
  if (circle <= 0.0) {
    color = vec3(0.0, 1.0, 0.0); //green
  } else {
    color = vec3(0.0, 0.0, 0.0); //black
  }

  gl_FragColor = vec4(color, 1.0);
}
