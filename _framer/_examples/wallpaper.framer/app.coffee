# Project Info
# This info is presented in a widget when you share.
# http://framerjs.com/docs/#info.info
Framer.Info =
	title: "iOS Wallpaper"
	author: "Claudio Guglieri"
	twitter: "claudioguglieri"
	description: "Exploring how the 3D wallpaper on the MacOs Sierra website could work on iOS."


# Set device background
Canvas.backgroundColor = "#FFB38B"
Screen.backgroundColor = "#fff"
Framer.Defaults.Animation =
    curve: "spring(200,40,0)"
    
# Setup
fwidth=Framer.Device.screen.width
fheight=Framer.Device.screen.height

Bg = new Layer
	image: "images/Rock_bg.jpg"
	width: 1897
	height: 2052
	x:-200
	y:360
	scale: 1.8
# 	rotationX: 30
# 	z:-250

Mountain = new Layer
	width: 1000
	height: 1000
	x: 200
	y: 1280
	backgroundColor: "transparent"
	z:500
# 	rotationX: 20

# Mountain.draggable.enabled=true

Rock3 = new Layer
	image: "images/Rock_3.png"
	width: 1735
	height: 1220
	x:Align.center
	y:Align.center
	z:100
	superLayer: Mountain
	rotationX: 10
# 	opacity: 0
	
	
Rock2 = new Layer
	image: "images/Rock_2.png"
# 	backgroundColor:"white"
	width: 1676
	height: 983
	rotationX: 30
	x:-150
	y:80
	z:300
	superLayer: Mountain

	
Rock1 = new Layer
	image: "images/Rock_1.png"
	width: 1107
	height: 459
	y:300
	x:-500
# 	blur: 15
# 	x:-200
# 	y:1400
	z:500
	scale: 1.4
	superLayer: Mountain
	

Homescreen = new Layer
	width: 1242
	height: 2208
	image: "images/HomeScreenIcons.png"
	x:0
	y:0
	
Homescreen.states.add
	locked:
		z: 1000
		blur: 20
		opacity: 0
	unlocked:
		z: 0
		blur: 0
		opacity: 1

bottombar = new Layer
	width: 1242
	height: 288
	image: "images/bottomBar.png"
	x:0
	
	z:500
	scale: 0.59

bottombar.states.add
	locked:
		y:1900
	unlocked:
		y:1520


	
statusbarlocked = new Layer
	width: fwidth
	height: 29
	z:250
	scale: 0.79
	backgroundColor: "transparent"

statusbarlockedcontrolcenter = new Layer
	width: 108
	height: 22
	borderRadius: "10px"
	backgroundColor: "white"
	opacity: 0.8
	x:Align.center
	y:0
	superLayer: statusbarlocked

statusbarlockeded= new Layer
	width: 1242
	height: 29
	image: "images/statusBarLocked.png"
	
	superLayer: statusbarlocked

statusbarlocked.states.add
	locked:
		y:240
	unlocked:
		y:100


statusbar= new Layer
	width: 1242
	height: 29
	image: "images/statusBar.png"
	y:15
# 	y:240
# 	z:250
# 	scale: 0.8

statusbar.states.add
	locked:
		y:-80
	unlocked:
		y:15
controlcenter = new Layer
	width: 108
	height: 22
	borderRadius: "20px"
	backgroundColor: "white"
	opacity: 0.8
	x:Align.center
	z:700
	scale: 0.45
	y:1540

controlcenter.states.add
	locked:
		y:1540
		
	unlocked:
		y:1600
		
Bg.states.add
	locked:
		z:100
		rotationY: 20
	unlocked:
		z:-450
		rotationY: 0
		
Rock1.states.add
	locked:
		blur:50
	unlocked:
		blur: 0
	
Mountain.states.add
	locked:
		z:500
# 		rotationX:20
		rotationY:-15
		
		y:1200
		
	unlocked:
		
		y:1400
		z:-300
# 		rotationX: 0
		rotationY:0
		

# Time
time = new Layer
	image: "images/time.png"
	width: 562
	height: 317
	y:350
	x:Align.center
	z:200
	scale: 0.8

time.states.add
	locked:
		z:200
		y:350
		blur: 0
		opacity: 1
	unlocked:
		z:-400
		y:400
		blur: 50
		opacity: 0
		



# Initital setup
# 
Bg.states.switchInstant("locked")
Mountain.states.switchInstant("locked")
Rock1.states.switchInstant("locked")
time.states.switchInstant("locked")
Homescreen.states.switchInstant("locked")
bottombar.states.switchInstant("locked")
statusbar.states.switchInstant("locked")
controlcenter.states.switchInstant("locked")
statusbarlocked.states.switchInstant("locked")

# Bg.states.switchInstant("unlocked")
# Mountain.states.switchInstant("unlocked")
# Rock1.states.switchInstant("unlocked")
# time.states.switchInstant("unlocked")
# Homescreen.states.switchInstant("unlocked")
# bottombar.states.switchInstant("unlocked")
# statusbar.states.switchInstant("unlocked")
# controlcenter.states.switchInstant("unlocked")
# statusbarlocked.states.switchInstant("unlocked")




layerA = new Layer
	backgroundColor: "rgba(231,2,13,1)"
	height: fheight
	width: fwidth/2
	backgroundColor: "transparent"
layerB = new Layer
	backgroundColor: "#ff00ff"
	x:Align.right
	height: fheight
	width: fwidth/2
	backgroundColor: "transparent"

layerB.on Events.Click, (event, layer) ->
	Bg.states.switch("locked")
	Mountain.states.switch("locked")
	Rock1.states.switch("locked")
	time.states.switch("locked")
	Homescreen.states.switch("locked")
	bottombar.states.switch("locked")
	statusbar.states.switch("locked")
	controlcenter.states.switch("locked")
	statusbarlocked.states.switch("locked")
	
layerA.on Events.Click, (event, layer) ->
	Bg.states.switch("unlocked")
	Mountain.states.switch("unlocked")
	Rock1.states.switch("unlocked")
	time.states.switch("unlocked")
	Homescreen.states.switch("unlocked")
	bottombar.states.switch("unlocked")
	statusbar.states.switch("unlocked")
	controlcenter.states.switch("unlocked")
	statusbarlocked.states.switch("unlocked")

	
# 	time.states.next()

# Mountain.on Events.Move, ->
# 	Mountain.rotationY = Utils.modulate(Mountain.x, [-100, 700], [-15, 15], true)
# # 	Mountain.z = Utils.modulate(Mountain.y, [500, 1000], [0, 1000], true)
# 
delayed=2
Bg.states.switch("unlocked", delay:delayed)
Mountain.states.switch("unlocked", delay:delayed)
Rock1.states.switch("unlocked", delay:delayed)
time.states.switch("unlocked", delay:delayed)
Homescreen.states.switch("unlocked", delay:delayed)
bottombar.states.switch("unlocked", delay:delayed)
statusbar.states.switch("unlocked", delay:delayed)
controlcenter.states.switch("unlocked", delay:delayed)
statusbarlocked.states.switch("unlocked", delay:delayed)
# 
# delayeded=2
# Bg.states.switch("locked", delay:delayeded)
# Mountain.states.switch("locked", delay:delayeded)
# Rock1.states.switch("locked", delay:delayeded)
# time.states.switch("locked", delay:delayeded)
# Homescreen.states.switch("locked", delay:delayeded)
# bottombar.states.switch("locked", delay:delayeded)
# statusbar.states.switch("locked", delay:delayeded)
# controlcenter.states.switch("locked", delay:delayeded)
# statusbarlocked.states.switch("locked", delay:delayeded)

