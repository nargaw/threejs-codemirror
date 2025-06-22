varying vec2 vUv;
uniform float u_time;
uniform vec2 u_resolution;

//circle sdf function
  float circleSdf(vec2 coords, float radius){
    float distValue = length(coords) - radius;
    return distValue;
  }

void main() {
  //our coordinate system
  //the center is (0, 0)
  vec2 coords = (gl_FragCoord.xy - u_resolution.xy * 0.5) / u_resolution.y;
  
  // Visualize: map distance to color
  vec3 color; //(x, y, z or r, g, b)

  //radius
  float radius = 0.25;

  //circle signed distance field
  //inside the circle is negative
  //outside the circle is positive
  //on the cirlce is 0
  float circle = circleSdf(coords, radius);

  //all the positions on the coordinate system that are 0 and negative will be colored green
  //all the positions on the coordinate system that are greater than 0 will be colored red
  if (circle <= 0.0) {
    color = vec3(0.0, 1.0, 0.0); //green
  } else {
    color = vec3(0.0, 0.0, 1.0); //red
  }

  gl_FragColor = vec4(color, 1.0);
}
