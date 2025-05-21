import './style.css'
import * as THREE from 'three'
import { OrbitControls } from 'three/examples/jsm/Addons.js'
import fragmentShader from './Shaders/fragment.glsl'
import vertexShader from './Shaders/vertex.glsl'
import { basicSetup, EditorView } from "codemirror";
import { EditorState } from "@codemirror/state";
import { glsl } from 'codemirror-lang-glsl';

//canvas
const canvas = document.querySelector('#webgl')

//scene
const scene = new THREE.Scene()

//sizes
let width = window.innerWidth
let height = window.innerHeight

//camera
const fov = 45
const aspect = width/height
const camera = new THREE.PerspectiveCamera(fov, aspect, 1, 100)

//renderer
const renderer = new THREE.WebGLRenderer({canvas})
renderer.setSize(width, height)
renderer.setClearColor(new THREE.Color('#1f1f1f'))
renderer.setPixelRatio(Math.min(window.devicePixelRatio, 1))

//camera controls
const controls = new OrbitControls(camera, canvas)
controls.enableDamping = true
controls.update()

const uniforms = {
  u_time: {
    value: new THREE.Uniform()
  },
  u_resolution: { 
    value: new THREE.Vector2(window.innerWidth, window.innerHeight) 
  }
}

//shader plane
const planeGeometry = new THREE.PlaneGeometry(2, 2)
const planeMaterial = new THREE.ShaderMaterial({
  uniforms: uniforms,
 fragmentShader: fragmentShader,
 vertexShader: vertexShader 
})
const shaderPlane = new THREE.Mesh(planeGeometry, planeMaterial)
scene.add(shaderPlane)

const view = new EditorView({
    state: EditorState.create({
        doc: fragmentShader,
        extensions: [
            basicSetup, 
            glsl(), 
            EditorView.updateListener.of((update) => {
                if(update.docChanged){
                    const newFrag = view.state.doc.toString()
                    planeMaterial.fragmentShader = newFrag
                    planeMaterial.needsUpdate = true
                }
            }),
            
        ]
    }),
    parent: document.querySelector('#editor'),
})

//resize
window.onresize = () =>{
  width = window.innerWidth
  height = window.innerHeight
  renderer.setSize(width, height)
  camera.aspect = width/height
  camera.updateProjectionMatrix()
  uniforms.u_resolution.value = new THREE.Vector2(width, height)
}

//time
const clock = new THREE.Clock()

//animate
const animate = () => {
  window.requestAnimationFrame(animate)
  uniforms.u_time.value = clock.getElapsedTime()
  controls.update()
  renderer.render(scene, camera)
}

animate()

