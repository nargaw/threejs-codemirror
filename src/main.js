import './style.css';
import * as THREE from 'three';
import frag0 from './Shaders/frag0.glsl?raw';
import frag1 from './Shaders/frag1.glsl?raw';
import frag2 from './Shaders/frag2.glsl?raw';
import frag3 from './Shaders/frag3.glsl?raw';
import frag4 from './Shaders/frag4.glsl?raw';
import vertexShader from './Shaders/vertex.glsl';
import { basicSetup, EditorView } from 'codemirror';
import { EditorState } from '@codemirror/state';
import { glsl } from 'codemirror-lang-glsl';
import { oneDark } from '@codemirror/theme-one-dark';

//canvas
const canvas = document.querySelector('#webgl');

//scene
const scene = new THREE.Scene();

//sizes
let width = window.innerWidth;
let height = window.innerHeight;

//camera
const fov = 45;
const aspect = width / height;
const camera = new THREE.PerspectiveCamera(fov, aspect, 1, 100);

//renderer
const renderer = new THREE.WebGLRenderer({ canvas });
renderer.setSize(width, height);
renderer.setClearColor(new THREE.Color('#1f1f1f'));
renderer.setPixelRatio(Math.min(window.devicePixelRatio, 1));

const uniforms = {
  u_time: {
    value: new THREE.Uniform(),
  },
  u_resolution: {
    value: new THREE.Vector2(window.innerWidth, window.innerHeight),
  },
};

const fragments = {
  0: frag0,
  1: frag1,
  2: frag2,
  3: frag3,
  4: frag4,
};

//get fragment shader
let currentFragment = fragments[0];
let fragmentNumber = 0
const maxFragmentNumber = 4

//shader plane
const planeGeometry = new THREE.PlaneGeometry(2, 2);
const planeMaterial = new THREE.ShaderMaterial({
  uniforms: uniforms,
  fragmentShader: currentFragment,
  vertexShader: vertexShader,
});
const shaderPlane = new THREE.Mesh(planeGeometry, planeMaterial);
scene.add(shaderPlane);

const updateShader = (newFrag) => {
  const newMaterial = new THREE.ShaderMaterial({
    uniforms: uniforms,
    fragmentShader: newFrag,
    vertexShader: vertexShader,
  });
  shaderPlane.material.dispose(); // Clean up the old material
  shaderPlane.material = newMaterial;
};

const customDarkTheme = EditorView.theme(
  {
    '&': {
      backgroundColor: '#000000a0 !important', // Your custom background color
    },
  },
  { dark: true }
);

const view = new EditorView({
  lineWrapping: true,
  state: EditorState.create({
    doc: currentFragment,
    extensions: [
      basicSetup,
      glsl(),
      oneDark,
      customDarkTheme,
      EditorView.lineWrapping,
      EditorView.updateListener.of((update) => {
        if (update.docChanged) {
          const newFrag = view.state.doc.toString();
          updateShader(newFrag);
        }
      }),
    ],
  }),
  parent: document.querySelector('#editor'),
});

const toggleBtn = document.getElementById('toggle-btn');
const backBtn = document.getElementById('back-btn')
const nextBtn = document.getElementById('next-btn')
const formSubmitBtn = document.getElementById('myForm')
const editorElement = document.querySelector('#editor');
const label = document.querySelector('#current-shader-label')

label.innerHTML = 0

backBtn.addEventListener('click', () => {
  // console.log(getPageNumber() - 1)
  if(fragmentNumber > 0){
    fragmentNumber -= 1
  }
  
  const frag = fragments[fragmentNumber] || fragments[0];
  loadShader(frag);
  label.innerHTML = fragmentNumber || 0
  console.log(label.innerHTML)
})

nextBtn.addEventListener('click', () => {
  if(fragmentNumber < maxFragmentNumber){
    fragmentNumber += 1
  }
  
  const frag = fragments[fragmentNumber] || fragments[0];
  loadShader(frag);
  label.innerHTML = fragmentNumber || 0
})

formSubmitBtn.addEventListener('submit', (e) => {
  e.preventDefault()

  const form = e.target
  const formData = new FormData(form)
  const formJson = Object.fromEntries(formData.entries())
  const num = parseInt(formJson.shader)
  
  if(!Number.isNaN(num) && num >= 0 && num <= maxFragmentNumber){
      const frag = fragments[num] || fragments[0]; 
      loadShader(frag)
  }
  // label.innerHTML.replace(fragmentNumber)
  label.innerHTML = num || 0
  document.getElementById("myForm").reset();
})

toggleBtn.addEventListener('click', () => {
  const isHidden = editorElement.style.display === 'none';
  editorElement.style.display = isHidden ? 'block' : 'none';
  toggleBtn.textContent = isHidden ? 'Hide Editor' : 'Show Editor';
});

//update shader and page
const loadShader = (frag) => {
  view.dispatch({
    changes: { from: 0, to: view.state.doc.length, insert: frag },
  });
  planeMaterial.fragmentShader = frag;
  planeMaterial.needsUpdate = true;
};

//resize
window.onresize = () => {
  width = window.innerWidth;
  height = window.innerHeight;
  renderer.setSize(width, height);
  camera.aspect = width / height;
  camera.updateProjectionMatrix();
  uniforms.u_resolution.value = new THREE.Vector2(width, height);
};

//time
const clock = new THREE.Clock();

//animate
const animate = () => {
  window.requestAnimationFrame(animate);
  uniforms.u_time.value = clock.getElapsedTime();
  renderer.render(scene, camera);
};

animate();
