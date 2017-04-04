# Project Info
# This info is presented in a widget when you share.
# http://framerjs.com/docs/#info.info

Framer.Info =
	title: ""
	author: "Aalok  Trivedi "
	twitter: ""
	description: ""

#global variables
screenW = Screen.frame.width
screenH = Screen.frame.height
screenX = Screen.frame.x
screenY = Screen.frame.y
gutter = 16

mySpring = "spring-dho(150, 17, 1, 0)"
easeOut = "ease-out"
easeIn = "ease-in"
easeInOut = "ease-in-out"
baseTime = .25
tapDelay = .2

buttons = []
for i in [0..2]
	circle = new Layer
		size: 200
		y: Align.center
		x: ((200 + 10) * i) + 70
		backgroundColor: "white"
		borderRadius: 100
	circle.states =
		goAway:
			scale: 0
			opacity: 0
			y: circle.y + 200
			animationOptions:
				curve: easeIn
				time: baseTime
		comeBack:
			scale: 1
			opacity: 1
			y: Align.center
			x: ((200 + 10) * i) + 70
			animationOptions:
				curve: easeOut
				time: baseTime
		selected:
			y: 0
			x: 0
			width: screenW
			height: (screenW * 3) / 4
			borderRadius: 0
			animationOptions:
				curve: easeOut
				time: baseTime
			
	buttons.push(circle)
	
scaleButtons = (exception) ->
	for b in buttons
		if b isnt exception
			b.stateCycle("goAway", "comeBack")
		if b is exception
			b.stateCycle("selected", "default", curve: easeOut, time: baseTime)
				
for button in buttons
	button.onClick ->
		scaleButtons(@)
		
	
		

