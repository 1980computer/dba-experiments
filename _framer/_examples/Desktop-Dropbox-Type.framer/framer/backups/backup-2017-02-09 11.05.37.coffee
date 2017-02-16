# Project Info
# This info is presented in a widget when you share.
# http://framerjs.com/docs/#info.info

Framer.Info =
	title: "Paper Onboarding"
	author: "Ryhan Hassan"
	twitter: "@ryhanhassan"
	description: "An early onboarding experiment for Dropbox Paper"


# Springs
bigSpring = "spring(200,15, -3)"
gentleSpring = "spring(40,5, 0)"
swingSpring = "spring(120,15, 0)"
smoothSpring = "spring(100,20, 0)"
slowSpring = "spring(100,15, -3)"
snapSpring = "spring(200, 20, 0)"
tightSpring = "spring(300, 25, 0)"
straightSpring = "spring(500, 40, 0)"
superSlowSpring = "spring(30,20,0)"

Framer.Defaults.Animation.curve = smoothSpring

# Common Variables
document.body.style.cursor = "auto"
Screen.backgroundColor = "#FFF"
screenW = Framer.Device._device.screenWidth || window.innerWidth
screenH = Framer.Device._device.screenHeight || window.innerHeight

############################################
# Spinner
############################################

spinner = new Layer 
	x:0, y:0, width:66, height:66, image:"images/spinner.png", opacity: 1
	
spinner.center()
	
spinner.states.add
	hidden: {opacity: 0, scale: 1}
	visible: {opacity: 1, scale: 1}
	
spinner.rotationZ = 10

rotation = 0
Utils.interval 0.4, () ->
	rotation = rotation + 180
	spinner.animate
		properties: 
			rotationZ: rotation
		curve: "linear"
		time: 0.4

############################################
# Basic Layers
############################################

editor_onboarding = new Layer
	x:0, y:0, width: screenW, height: screenH, backgroundColor: 'white', opacity:0
	
marketing_site = new Layer	
	x:0, y:0, width: screenW, height: screenH, backgroundColor: 'white', opacity:1

############################################
# Marketing
############################################

main_cta = new Layer
	x:0, y:0, width:836/2, height:460/2, image:"images/main_cta.png", superLayer: marketing_site
main_cta.center()
main_cta.y = 96

site_doc = new Layer
	x:(screenW-1100)/2, y:420, width:2278/2, height:1052/2, image:"images/site_doc.png", superLayer: marketing_site

############################################
# Text Layer
############################################

backdropImageText = new Layer
	x:226, y:256, width:720, height: 192, backgroundColor: "rgba(0,0,0,0)", clip: false, superLayer: editor_onboarding


fake_comment = new Layer
	x:720+16, y:16*4, width:546/2, height:276/2, image:"images/fake_comment.png", superLayer: backdropImageText, originX: 0, originY: 0.3
	
fake_comment.states.add
	collapsed: {opacity: 0, scale: 0.2}
	shown: {opacity: 1, scale: 1}
fake_comment.states.animationOptions.curve = snapSpring

fake_comment.states.switchInstant "collapsed"

backdropImageText.style =
	fontSize: '16px'
	textAlign: 'left'
	fontFamily: 'Atlas Grotesk'
	fontWeight: '200'
	lineHeight: '32px'
	wordSpacing: '.25px'
	color: "#393E3F"
	padding: '0px'

backdropImageText.center()
#backdropImageText.y = 256
	
backdropImageText.html = 
	"<span style='font-size:40px; line-height: 48px; margin-bottom: 38px;'>My first note</span><br/><br/>" +
	"<textarea style='background-color: rgba(0,0,0,0); width: 720px; padding: 0; height: 640px; outline: none; font-size: 16px; font-family: Atlas Grotesk, grotesk,helvetica,arial,sans-serif; font-weight:200; line-height:28px; word-spacing:.25px; color: #393E3F'>Notes lets you create, edit, and collaborate real-time on beautiful documents in your browser. We've seen Notes used across various scenarios ranging from a private place for note-taking to a shared hub for brainstorming and providing feedback.</textarea> "
	



formatting_bar_normal = new Layer
	x:0, y:0, width:528/2, height:112/2, image:"images/formatting_bar_normal.png", superLayer: editor_onboarding, opacity: 0, clip: false
	
focus_circle_normal = new Layer
	x:23, y:-17, width:160/2, height:160/2, image:"images/focus_circle.png", superLayer: formatting_bar_normal, scale: 1, opacity: 1
	
focus_time = 1.2

Utils.interval focus_time, ->
	focus_circle_normal.animate
		properties: {scale: 0.9}
		curve: "ease-in"
		time: focus_time/2
	Utils.delay focus_time/2, ->
		focus_circle_normal.animate
			properties: {scale: 1}
			curve: "ease-in-out"
			time: focus_time/2
	
	
dismiss_bar = Utils.debounce 2.5, ->
	
	focus_circle_normal.animate
		properties: {opacity:0}
		curve: snapSpring
		
	Utils.delay 1, ->
		formatting_bar_normal.animate
			properties: {opacity: 0}
			curve: snapSpring
			
lastTouched = -1
window.addEventListener "keydown", () ->
	formatting_bar_normal.animate
		properties: {opacity: 0}
		curve: snapSpring

editor_onboarding.on Events.TouchStart, (e) ->
	formatting_bar_normal.opacity = 0
	lastTouched = e.timeStamp
	
editor_onboarding.on Events.TouchEnd, (e)->
	if (e.timeStamp - lastTouched < 200)
		formatting_bar_normal.opacity = 0
		return
		
		
	y = e.y + 16 -  (window.innerHeight - Framer.Device.screen.height)/2
	x = e.x - 132 -  (window.innerWidth - Framer.Device.screen.width)/2
	
	formatting_bar_normal.scale = 1
	formatting_bar_normal.x =x #e.clientX - 132
	formatting_bar_normal.y = y - 16
	
	
	formatting_bar_normal.opacity = 0
	Utils.delay 3.2, -> dismiss_bar()
	focus_circle_normal.opacity = 0
	#focus_circle_normal.scale = 2
	formatting_bar_normal.animate
		properties: {opacity: 1, y: y, scale: 1}
		curve: snapSpring
		
	Utils.delay 0.5, -> dismissBanner()
###
	Utils.delay 0.5, ->
		focus_circle_normal.animate
			properties: {opacity:1, scale: 1}
			curve: snapSpring
	#Utils.delay 0.5, -> dismissBanner()
	
###

############################################
# Banner
############################################

header = new Layer
	x:0, y:0, width: screenW, height: 64, clip: false, backgroundColor: "transparent", superLayer: editor_onboarding

header_left = new Layer
	x:24, y:24, width:128/2, height:30/2, image:"images/header_left.png", superLayer: header
	
header_right = new Layer
	x:screenW-240/2-24, y:16, width:240/2, height:64/2, image:"images/header_right_0.png", superLayer: header, clip: false
	
link_flyout = new Layer
	x:-255, y:48, width:764/2, height:182/2, image:"images/link_flyout.png", superLayer: header_right, opacity: 0

banner = new Layer
	x:0, y: screenH-192, height: 192 + 64, width: screenW, superLayer: editor_onboarding, backgroundColor: "#007EE5"
	
banner.states.add
	hidden: {y: screenH + 64}
	shown: {y: screenH - 192}	
banner.states.switchInstant "hidden"
banner.states.animationOptions.curve = smoothSpring

banner_success = new Layer
	x:0, y: 0, height: 192 + 64, width: screenW, superLayer: banner, backgroundColor: "#48AC68", opacity: 0

banner_messages = new Layer
	x:0, y:-192, width:screenW, height: 192*2, superLayer: banner, backgroundColor: "transparent"

banner_messages.states.add
	0: {y:-192}
	1: {y:0}
banner_messages.states.animationOptions.curve = snapSpring

success = new Layer
	x:0, y:0, width:180/2, height:200/2, image:"images/success.png", superLayer: banner_messages
success.center()
success.y = 48 


bannerSuccess = ->
	banner_success.animate
		properties: {opacity: 1}
		curve: smoothSpring

	Utils.delay 0, -> banner_messages.states.switch "1"


	
close = new Layer
	x:24, y:24, width:10, height:10, image:"images/close.png", superLayer: banner
	
	

highlight_text = new Layer
	x:0, y:0, width:744/2, height:50/2, image:"images/highlight_text2.png", superLayer: banner_messages, clip: false
	
highlight_text.center()
highlight_text.y = 64+192




highlight_selection = new Layer
	x:-4, y:-2, width: 147, height: 27, backgroundColor: "rgba(255,255,255,0.3)", superLayer: highlight_text
	
	
highlight_selection.style.borderRight = "1px solid white"
	
highlight_selection.states.add
	0: {width: 2, opacity: 0}
	1: {width: 2, opacity: 1}
	2: {width: 147, opacity: 1}
	3: {width: 147, opacity: 0}
	
	
highlight_selection.states.switchInstant "0"




formatting_bar = new Layer
	x:32, y:42, width:528/2, height:112/2, image:"images/formatting_bar_normal.png", superLayer: highlight_text, clip: false

formatting_bar.states.add
	0: {opacity: 0}
	1: {opacity: 0, y: 24}
	2: {opacity: 1, y:42}
	3: {opacity: 0, y: 56}
	
	
formatting_bar.states.switchInstant "0"
formatting_bar.states.animationOptions.curve = swingSpring

focus_circle = new Layer
	x:23, y:-17, width:160/2, height:160/2, image:"images/focus_circle.png", superLayer: formatting_bar, scale: 0.5, opacity: 0.7
	
focus_circle.states.add
	0: {scale: 0.2, opacity: 0}
	1: {scale: 0.2, opacity: 0}
	2: {scale: 1, opacity: 1}
	3: {scale: 0.2, opacity: 0}

focus_circle.states.animationOptions.curve = swingSpring
	
focus_time = 1.2
###
Utils.interval focus_time, ->
	focus_circle.animate
		properties: {scale: 0.9}
		curve: "ease-in"
		time: focus_time/2
	Utils.delay focus_time/2, ->
		focus_circle.animate
			properties: {scale: 1}
			curve: "ease-in-out"
			time: focus_time/2
			
###

showTip = ->
	highlight_selection.states.switchInstant "0"
	formatting_bar.states.switchInstant "0"
	focus_circle.states.switchInstant "0"
	highlight_selection.states.switch "1"
	formatting_bar.states.switch "1"
	
	Utils.delay 0.5, ->
		highlight_selection.states.switch "2"
		Utils.delay 0.5, ->
			formatting_bar.states.switch "2"

		
	Utils.delay 8, ->
		highlight_selection.states.switch "3"
		Utils.delay 0.1, -> formatting_bar.states.switch "3"

showBanner = ->
	banner.states.switch "shown"
	Utils.delay 0.5, ->
		showTip()
		Utils.interval 9, showTip
		
		
dismissBanner = ->
	bannerSuccess()
	Utils.delay 3, -> banner.states.switch "hidden"
	
	
formatting_bar_normal.on Events.Click, -> 
	y = formatting_bar_normal.y
	formatting_bar_normal.animate
		properties: {y: y+8, opacity: 0}
		curve: "linear"
		time: 0.1
	Utils.delay 0.4, -> dismissBanner()
	Utils.delay 0, -> fake_comment.states.switch "shown"
#body.on Events.Click, showBanner




marketing_site_dismissed = false
marketing_site.on Events.Click, ->
	return if marketing_site_dismissed == true
	marketing_site_dismissed = true
	Utils.delay 0.2, ->
		marketing_site.animate
			properties: {opacity: 0}
			curve: snapSpring

		Utils.delay 1.2, ->
			marketing_site.index = -1
			editor_onboarding.animate
				properties: {opacity: 1}
				curve: snapSpring
		Utils.delay 2, -> showBanner()



