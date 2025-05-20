varying vec2 vUv;
uniform float u_time;

void main(){
  gl_FragColor = vec4(vUv.x * sin(u_time * 2.), vUv.y * cos(u_time), 0., 1.);
}