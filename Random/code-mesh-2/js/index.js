'use strict';

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

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

        this.update = this.update.bind(this);

        this.addListeners();

        requestAnimationFrame(this.update);
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

        requestAnimationFrame(this.update);
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
            u_amplitude: { value: this.options.amplitude },
            u_frequency: { value: this.options.frequency },
            u_time: { value: 0.0 }
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

var Scene = function (_THREE$Scene) {
    _inherits(Scene, _THREE$Scene);

    /**
     * @constructor
     */

    function Scene(width, height) {
        _classCallCheck(this, Scene);

        var _this = _possibleConstructorReturn(this, _THREE$Scene.call(this));

        _this.renderer = new THREE.WebGLRenderer({ antialias: true });
        _this.renderer.setSize(width, height);
        _this.renderer.setClearColor(0x000000);

        _this.camera = new THREE.PerspectiveCamera(50, width / height, 1, 2000);
        _this.camera.position.z = 100;

        _this.controls = new THREE.OrbitControls(_this.camera);

        return _this;
    }

    /**
     * @method
     * @name render
     * @description Renders/Draw the scene
     */

    Scene.prototype.render = function render() {

        this.renderer.autoClearColor = true;
        this.renderer.render(this, this.camera);
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
}(THREE.Scene);

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

new App();