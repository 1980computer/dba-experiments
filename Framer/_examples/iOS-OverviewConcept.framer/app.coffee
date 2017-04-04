# Set Device background
Canvas.backgroundColor = "white"


background = new Layer
	width: 750
	height: 1334
	image: "images/ Test.jpg",
	opacity: 0.5
	
header = new Layer
	width: 750
	height: 135
	backgroundColor: "rgba(31, 54, 88, 0.48)",
	opacity: 0.8

title = new Layer
	parent: header
	width: 750
	height: 135
	backgroundColor: "none"
	html: "Overview"
	style: "color" : "#4a4a4a", "text-align" : "center", "padding-top" : "50px","font-family" : "avenir next", "font-weight" : "500","font-size" : "45px", "text-transform" : "uppercase", "color" : "#fff", "letter-spacing" : "13px",

loader = new Layer
	height: 138
	image: "images/loader.gif"
	style: "visibility" : "hidden"
	width: 138
	x: 306
	y: 135

scroll = new ScrollComponent
	scrollHorizontal: false
	y: 135
	height: 1199
	width: 750


dashBlock1 = new Layer
	parent: scroll.content
	y: 47
	height: 328
	width: 328
	x: 31
	backgroundColor: "rgba(255, 255, 255, 0.89)"
	shadowSpread: 0
	shadowColor: "rgba(228, 228, 228, 0.78)"
	borderRadius: 10
	blur: 0
	brightness: 100
	invert: 0

invitessent = new Layer
	parent: dashBlock1
	height: 214
	image: "images/invitessent.svg"
	width: 328
	y: 61

dashBlock2 = new Layer
	parent: scroll.content
	x: 393
	y: 47
	width: 328
	height: 328
	backgroundColor: "rgba(255, 255, 255, 0.89)"
	shadowSpread: 0
	shadowColor: "rgba(228, 228, 228, 0.78)"
	borderRadius: 10
	blur: 0
	brightness: 100
	invert: 0
	

invitesaccepted = new Layer
	parent: dashBlock2
	height: 206
	image: "images/invitesaccepted.svg"
	width: 352
	y: 61
	x: -12

dashBlock3 = new Layer
	parent: scroll.content
	y: 957
	x: 31
	width: 690
	height: 441
	backgroundColor: "rgba(255, 255, 255, 0.89)"
	shadowSpread: 0
	shadowColor: "rgba(228, 228, 228, 0.78)"
	borderRadius: 10
	blur: 0
	brightness: 100
	invert: 0


graph1 = new Layer
	parent: dashBlock3
	image: "images/Graph1.svg"
	width: 576
	height: 361
	x: 56
	y: 40


dashBlock4 = new Layer
	parent: scroll.content
	y: 1777
	x: 31
	height: 361
	width: 690
	backgroundColor: "rgba(255, 255, 255, 0.89)"
	shadowSpread: 0
	shadowColor: "rgba(228, 228, 228, 0.78)"
	borderRadius: 10
	blur: 0
	brightness: 100
	invert: 0



onlineviewsgraph = new Layer
	parent: dashBlock4
	image: "images/onlineviewsgraph.svg"
	width: 565
	height: 256
	y: 68
	x: 62

dashBlock5 = new Layer
	parent: scroll.content
	y: 1424
	x: 31
	height: 328
	width: 328
	backgroundColor: "rgba(255, 255, 255, 0.89)"
	shadowSpread: 0
	shadowColor: "rgba(228, 228, 228, 0.78)"
	borderRadius: 10
	blur: 0
	brightness: 100
	invert: 0
	
socialMentions = new Layer
	parent: dashBlock5
	image: "images/socialmentions.svg"
	width: 308
	height: 195
	y: 66
	x: 13
	
dashBlock6 = new Layer
	parent: scroll.content
	y: 1424
	x: 393
	height: 328
	width: 328
	backgroundColor: "rgba(255, 255, 255, 0.89)"
	shadowSpread: 0
	shadowColor: "rgba(228, 228, 228, 0.78)"
	borderRadius: 10
	blur: 0
	brightness: 100
	invert: 0

	
teammembers = new Layer
	parent: dashBlock6
	image: "images/teammembers.svg"
	width: 309
	height: 196
	x: 10
	y: 66
	
dashBlock7 = new Layer
	parent: scroll.content
	y: 399
	height: 532
	width: 690
	backgroundColor: "rgba(255, 255, 255, 0.89)"
	shadowSpread: 0
	shadowColor: "rgba(228, 228, 228, 0.78)"
	borderRadius: 10
	blur: 0
	brightness: 100
	invert: 0
	x: 31
	
completion = new Layer
	parent: dashBlock7
	image: "images/completion.svg"
	width: 513
	height: 445
	x: 87
	y: 43


menuIcon = new Layer
	parent: header
	image: "images/HamburgerIcon.svg"
	width: 80
	height: 80
	x: 31
	y: 28

alerts = new Layer
	parent: header
	image: "images/alerts.svg"
	x: 659
	y: 24
	width: 62
	height: 70

menuFlyout = new Layer
	width: 500
	height: 1199
	backgroundColor: "rgba(17, 29, 47, 0.98)"
	y: 135
	x: -500
	style: "box-shadow" : "7px 0px 31px 0px rgba(0,0,0,0.58)", 
	
contentFlyup = new Layer
	height: 1334
	width: 750
	y: 1334
	backgroundColor: "rgba(17, 29, 47, 0.98)"
	style: "box-shadow" : "7px 0px 31px 0px rgba(0,0,0,0.58)", 
	
close = new Layer
	parent: contentFlyup
	image: "images/close.svg"
	width: 80
	height: 80
	x: 641
	y: 27
	
flydupgraph = new Layer
	parent: contentFlyup
	image: "images/flyupgraph.svg"
	width: 661
	height: 1183
	y: 107
	x: 45
	
alertsFlyleft = new Layer
	width: 500
	height: 1199
	backgroundColor: "rgba(17, 29, 47, 0.98)"
	y: 135
	x: 750
	style: "box-shadow" : "7px 0px 31px 0px rgba(0,0,0,0.58)", 
	
notifications = new Layer
	parent: alertsFlyleft
	image: "images/notifications.svg"
	y: 19
	width: 427
	height: 912
	x: 12
	
mfcontent = new Layer
	parent: menuFlyout
	image: "images/mfcontent.svg"
	x: 45
	y: 174
	width: 435
	height: 1003
	
profilepic = new Layer
	parent: menuFlyout
	height: 105
	image: "images/profilepic.JPG"
	x: 181
	borderRadius: 400
	width: 105
	y: 79
	opacity: 1.00

menuprofile = new Layer
	parent: menuFlyout
	height: 125
	image: "images/menuprofile.svg"
	width: 375
	y: 38
	x: 30


menuIcon.onClick ->
	menuFlyout.animate
				curve: "easeInOutQuint"
				time:  1
				x: 1

dashBlock1.onClick ->
	contentFlyup.animate
				curve: "easeInOutQuint"
				time:  1
				y: 1
close.onClick ->
	contentFlyup.animate
				curve: "easeInOutQuint"
				time:  1
				y: 2000
				
alerts.onClick ->
	alertsFlyleft.animate
				curve: "easeInOutQuint"
				time:  1
				x: 300
				

#Gives menuIcon the ability to Toggle
menuIcon.states = 
  stateA: {rotation:180}
  stateB: {rotation:0}
  stateC: {rotation:180}

# Toggles Flyout Motion
menuIcon.onClick ->
  menuIcon.stateCycle()
  menuFlyout.stateCycle()
  alertsFlyleft.stateCycle()

alerts.onClick ->
  alertsFlyleft.stateCycle()
  menuFlyout.stateCycle()
  
dashBlock1.onClick ->
  menuFlyout.stateCycle()
  alertsFlyleft.stateCycle()