# Project Info
# This info is presented in a widget when you share.
# http://framerjs.com/docs/#info.info

Framer.Info =
	title: "Chat Example"
	author: "John Sherwin"
	twitter: "@johnmpsherwin"
	description: ""


# Import File "Chat" (sizes and positions are scaled 1:2)
$ = Framer.Importer.load("imported/Chat@2x")

Framer.Extras.Hints.disable()

#Set Defaults ---------------------------------
bounce = "spring(400,40,0)"
messageCount = 0

#Create Scroll ---------------------------------
contentArea = new Layer
	superLayer: $.contentArea
	size: $.contentArea.size
	backgroundColor: null

contentScroll = new ScrollComponent
	wrap: $.contentArea
	contentInset: 
		bottom: 30
contentScroll.scrollHorizontal = false

#Create Input ---------------------------------

inputField = document.createElement("input")

#Input Field Style
inputField.style["width"] = $.inputBox.width
inputField.style["height"] = "50px"
inputField.style["padding-left"] = "30px"
inputField.style["padding-top"] = "15px"
inputField.style["font-weight"] = 400
inputField.style["line-height"] = "36px"
inputField.style["font-size"] = "32px"
inputField.style["font-family"] = "-apple-system, helvetica"
inputField.style["background-color"] = "rgba(255,255,255,0)"
inputField.style["outline-width"] = 0

#Input Field Defaults
inputField.value = ""
inputField.placeholder = "Type a message..."
inputField.maxLength = "30"

$.inputBox._element.appendChild(inputField)

#Animate Input ---------------------------------
$.inputBox.onClick ->
	inputField.focus()
	$.inputUI.animate
		properties:
			y: Align.bottom
			options:
				time: .3
				curve: "ease"

$.contentArea.onClick ->
	inputField.blur()
	$.inputUI.animate
		properties:
			y: 1334 - $.bottomBarBackground.height
			options:
				time: .3
				curve: "ease"

#Send Button Events ---------------------------------
$.sendBtnActive.onClick ->
	inputField.focus()
	
	#Define Style
	style = fontSize: "32px", fontFamily: "-apple-system, helvetica", letterSpacing: "0.4px", textAlign: "center", paddingTop: "22px", lineHeight: "36px", color: "#FFFFFF"
	
	message = inputField.value
	inputField.value = ""
	
	#Calculate Width & Height
	size = Utils.textSize(message, style)

	if inputField.value != 0
		messageCount += 1
		messageBubble = new Layer
			superLayer: contentArea
			height: 75
			y: Align.bottom
			x: Align.right (-30)
			borderRadius: 100
			backgroundColor: "#22B4F7"
			html: message
			style: style

#Animate Message ---------------------------------
		for i in [0...messageCount]
			messageBubble.animate
				properties:
					width: size.width + 50
					height: size.height + 25
					x: Screen.width - size.width - 80
					y: 30 + i * (messageBubble.height + 30)
					options:
						time: .4
						curve: bounce
