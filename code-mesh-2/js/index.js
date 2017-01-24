'use strict';

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

var App = function () {

    /**
     * @constructor
     */

    function App() {
        _classCallCheck(this, App);

        this.width = window.innerWidth;
        this.height = window.innerHeight;

        this.DELTA_TIME = 0;
        this.LAST_TIME = Date.now();

        this.scene = new Scene(this.width, this.height);
        this.plane = new Plane();

        this.scene.add(this.plane.mesh);

        var root = document.body.querySelector('.app');
        root.appendChild(this.scene.renderer.domElement);

        this.addListeners();
    }

    /**
     * @method
     * @name onResize
     * @description Triggered when window is resized
     */

    App.prototype.onResize = function onResize() {

        this.width = window.innerWidth;
        this.height = window.innerHeight;

        this.scene.resize(this.width, this.height);
    };

    /**
     * @method
     * @name addListeners
     */

    App.prototype.addListeners = function addListeners() {

        window.addEventListener('resize', this.onResize.bind(this));
        TweenMax.ticker.addEventListener('tick', this.update.bind(this));
    };

    /**
     * @method
     * @name update
     * @description Triggered on every TweenMax tick
     */

    App.prototype.update = function update() {

        this.DELTA_TIME = Date.now() - this.LAST_TIME;
        this.LAST_TIME = Date.now();

        this.plane.update(this.DELTA_TIME);
        this.scene.render();
    };

    return App;
}();

var Plane = function () {

    /**
     * @constructor
     */

    function Plane() {
        _classCallCheck(this, Plane);

        this.size = 1000;
        this.segments = 200;

        this.options = new Options();
        this.options.initGUI();

        this.uniforms = {
            u_amplitude: { type: '1f', value: this.options.amplitude },
            u_frequency: { type: '1f', value: this.options.frequency },
            u_time: { type: '1f', value: 0 }
        };

        this.geometry = new THREE.PlaneBufferGeometry(this.size, this.size, this.segments, this.segments);
        this.material = new THREE.ShaderMaterial({
            uniforms: this.uniforms,
            vertexShader: document.getElementById('planeVS').innerHTML,
            fragmentShader: document.getElementById('planeFS').innerHTML,
            side: THREE.DoubleSide,
            wireframe: true
        });

        this.mesh = new THREE.Mesh(this.geometry, this.material);
        this.mesh.rotation.x = 360;
    }

    /**
     * @method
     * @name update
     * @description Triggered on every TweenMax tick
     * @param {number} dt - DELTA_TIME
     */

    Plane.prototype.update = function update(dt) {

        this.uniforms.u_amplitude.value = this.options.amplitude;
        this.uniforms.u_frequency.value = this.options.frequency;
        this.uniforms.u_time.value += dt / 1000;
    };

    return Plane;
}();

var Options = function () {

    /**
    * @constructor
    */

    function Options() {
        _classCallCheck(this, Options);

        this.amplitude = 10.0;
        this.frequency = 0.05;

        this.gui = new dat.GUI();
    }

    /**
    * @method
    * @name initGUI
     * @description Initialize the dat-gui
    */

    Options.prototype.initGUI = function initGUI() {

        this.gui.close();

        this.gui.add(this, 'amplitude', 1.0, 15.0);
        this.gui.add(this, 'frequency', 0.01, 0.1);
    };

    return Options;
}();

var Scene = function () {

    /**
     * @constructor
     */

    function Scene(width, height) {
        _classCallCheck(this, Scene);

        this.scene = new THREE.Scene();

        this.renderer = new THREE.WebGLRenderer({ antialias: true });
        this.renderer.setSize(width, height);
        this.renderer.setClearColor(0x000000);

        this.camera = new THREE.PerspectiveCamera(50, width / height, 1, 2000);
        this.camera.position.z = 100;

        this.controls = new THREE.OrbitControls(this.camera);
    }

    /**
     * @method
     * @name add
     * @description Add a child to the scene
     * @param {object} child - A THREE object
     */

    Scene.prototype.add = function add(child) {

        this.scene.add(child);
    };

    /**
     * @method
     * @name remove
     * @description Remove a child from the scene
     * @param {object} child - A THREE object
     */

    Scene.prototype.remove = function remove(child) {

        this.scene.remove(child);
    };

    /**
     * @method
     * @name render
     * @description Renders/Draw the scene
     */

    Scene.prototype.render = function render() {

        this.renderer.autoClearColor = true;
        this.renderer.render(this.scene, this.camera);
    };

    /**
     * @method
     * @name resize
     * @description Resize the scene according to screen size
     * @param {number} newWidth
     * @param {number} newHeight
     */

    Scene.prototype.resize = function resize(newWidth, newHeight) {

        this.camera.aspect = newWidth / newHeight;
        this.camera.updateProjectionMatrix();

        this.renderer.setSize(newWidth, newHeight);
    };

    return Scene;
}();

new App();