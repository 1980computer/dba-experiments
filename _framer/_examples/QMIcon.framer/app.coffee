# Project Info
# This info is presented in a widget when you share.
# http://framerjs.com/docs/#info.info

Framer.Info =
	title: "QMUI Icon"
	author: "Airytram"
	twitter: "ayritria"
	description: "Icon animations for QMUI!"


# Modules

Android = require "androidRipple"
# Variable

cardBodyPaddingHorizontal = 32
cardBodyPaddingTop = 44

cardBodyImageMarginHorizontal = 110

cardDetailLabelMarginBottom = 80
cardDetailLabelMarginTop = 12

contentBorderWidth = 2

pageIndicatorDotSize = 8
pageIndicatorDotMargin = 8
pageIndicatorMarginBottom = 24
pageNumber = 3
pageCurrentNumber = 0

puzzleBorderRadius = 8
puzzleEllipseRadius = 7
puzzleBorderColor = "#03C0E6"
puzzleBackgroundColor = "#D5F8FF"

paperBorderRadius = 6

illustration00Changing = false
illustration01Changing = false
illustration02Changing = false
illustration03Changing = false
# Style Sheet

cardButton_style = {color:"white"; fontSize:"18px" ;lineHeight:"22px"; textAlign:"center"; fontFamily:"DIN-Bold, -apple-system"}
cardBodyTitleLabel_style = {color:"#4C6073"; fontSize:"20px" ;lineHeight:"24px"; textAlign:"center"; fontFamily:"DIN-Medium, -apple-system"}
cardBodyDetailLabel_style = {color:"#80909E"; fontSize:"16px" ;lineHeight:"24px"; textAlign:"center"; fontFamily:"DIN-Regular, -apple-system"}

# Background

Canvas.backgroundColor = "#F0F1F3"
background = new Layer x: Align.center, y: Align.center, width: 800, height: 600
background.style.background = "linear-gradient(-45deg, #F2FDFF 0%, #F6FDFF 100%)"
# Card Body

shadow = new Layer parent: background, x: Align.center, y: Align.center, width: 340, height: 470, backgroundColor: "null", shadowY: 16, shadowBlur: 32, shadowColor: "#91CFDC"
card = new Layer parent: background, x: Align.center, y: Align.center, width: 380, height: 470, backgroundColor: "null", clip: true, borderRadius: 4
cardButton = new Layer parent: card, y: Align.bottom, width: card.width, height: 64, backgroundColor: "#03C0E6", clip: true
cardBody = new Layer parent: card, width: card.width, height: card.height - cardButton.height, backgroundColor: "white", shadowY: 1, shadowBlur: 2, shadowColor: "rgba(0, 0, 0, 0.1)"

cardButton.on(Events.TapStart, Android.Ripple)
# Card Label

cardButtonLabel = new Layer parent: cardButton, y: Align.center(-1), width: cardButton.width, height: 22, backgroundColor: "null"
cardButtonLabel.style = cardButton_style
cardButtonLabel.html = "Next →"

cardLabelArray = []

cardLabelShow = (currentPage) ->

	cardBodyDetailLabel = new Layer 
		parent: cardBody
		x: Align.center(72)
		y: Align.bottom(-cardDetailLabelMarginBottom)
		height: 72
		width: cardBody.width - cardBodyPaddingHorizontal * 2
		backgroundColor: "null"
		opacity: 0
		
	cardBodyDetailLabel.style = cardBodyDetailLabel_style
	cardBodyDetailLabel.html = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In ut laoreet augue. Donec gravida."
	
	cardBodyTitleLabel = new Layer
		parent: cardBody
		x: Align.center(48)
		maxY: cardBodyDetailLabel.minY - cardDetailLabelMarginTop
		height: 24
		width: cardBody.width - cardBodyPaddingHorizontal * 2
		backgroundColor: "null"
		opacity: 0
		
	cardBodyTitleLabel.style = cardBodyTitleLabel_style
	
	if currentPage == 0
		cardBodyTitleLabel.html = "Basic config and components"
	else if currentPage == 1
		cardBodyTitleLabel.html = "Sass and Compass supported"
	else if currentPage == 2
		cardBodyTitleLabel.html = "Powerful built-in workflow"
	else if currentPage == 3
		cardBodyTitleLabel.html = "Extension"
		
	Utils.delay 0.6, ->
		
		cardBodyDetailLabel.animate
			properties:
				x: Align.center
				opacity: 1
			time: 0.5
			
		cardBodyTitleLabel.animate
			properties:
				x: Align.center
				opacity: 1
			time: 0.5
		
	cardLabelArray.push cardBodyDetailLabel, cardBodyTitleLabel
	
cardLabelHide = () ->
	
	cardLabelArray[0].animate
		properties:
			x: Align.center(-72)
			opacity: 0
		time: 0.5
		
	cardLabelArray[1].animate
		properties:
			x: Align.center(-48)
			opacity: 0
		time: 0.5
		
	cardLabelArray[0].onAnimationEnd ->
		@.destroy()
	cardLabelArray[1].onAnimationEnd ->
		@.destroy()
	cardLabelArray = []
# Page Indicator

pageIndicator = new Layer parent: cardBody, x: Align.center, y: Align.bottom(-pageIndicatorMarginBottom), width: (pageNumber + 1) * pageIndicatorDotSize + pageNumber * pageIndicatorDotMargin, height: pageIndicatorDotSize, backgroundColor: "null"

pageIndicatorDotArray = []
for i in [0..pageNumber]
	pageIndicatorDot = new Layer parent: pageIndicator, id: "pageIndicatorDot#{i}", name: "pageIndicatorDot#{i}", size: pageIndicatorDotSize, borderRadius: 4, x: i * (pageIndicatorDotSize + pageIndicatorDotMargin)
	pageIndicatorDotArray.push pageIndicatorDot
	
pageIndicatorSwitch = () ->
	for pageIndicatorDot, i in pageIndicatorDotArray
		if i == pageCurrentNumber
			pageIndicatorDot.backgroundColor = "#03C0E6"
		else
			pageIndicatorDot.backgroundColor = "#D8DCE4"
			
pageIndicatorSwitch()

# Show Illustration 00

puzzleArray = []
puzzleBackgroundArray = []
puzzleLineArray = []
illustration00Array = []

illustration00Show = () ->

	illustration00 = new Layer parent: cardBody, x: Align.center, y: cardBodyPaddingTop, width: 160, height: 160, backgroundColor: "null", clip: false
	illustration00Array.push illustration00
	
	puzzleTopLeft = new Layer
		parent: illustration00
		width: 61
		height: 54
		x: 27
		y: 27
		backgroundColor: "null"
		index: 1
	puzzleTopLeft.html = """
		<svg version="1.1"
			 x="0px" y="0px" width="61px" height="54px" viewBox="0 0 61 54" style="enable-background:new 0 0 61 54;" xml:space="preserve">
		<style type="text/css">
			.puzzle_tl{fill:none;stroke:#03C0E6;stroke-width:2;stroke-linecap:square;stroke-miterlimit:10;}
			.puzzle_tl{stroke-dashoffset:250;stroke-dasharray:250;animation:puzzle_tl_dash 1s cubic-bezier(0.215, 0.61, 0.355, 1) normal forwards;}
			@keyframes puzzle_tl_dash{to{stroke-dashoffset:0;}}
		</style>
		<path class="puzzle_tl" d="M53,1H8C4.1,1,1,4.1,1,8v45h52V34c3.9,0,7-3.1,7-7s-3.1-7-7-7V2"/>
		</svg>"""
	puzzleTopLeftAnimation = """.puzzle_tl{animation-play-state:paused;}"""
	Utils.insertCSS(puzzleTopLeftAnimation)

	puzzleTopLeftBackground = new Layer
		parent: illustration00
		width: 57
		height: 50
		x: puzzleTopLeft.x + contentBorderWidth
		y: puzzleTopLeft.y + contentBorderWidth
		backgroundColor: "null"
		opacity: 0
		index: 0
	puzzleTopLeftBackground.html = """
		<svg version="1.1"
			 x="0px" y="0px" width="57px" height="50px" viewBox="0 0 57 50" style="enable-background:new 0 0 57 50;" xml:space="preserve">
		<style type="text/css">
			.puzzle_tl_bg{fill-rule:evenodd;clip-rule:evenodd;fill:#D5F8FF;}
		</style>
		<path class="puzzle_tl_bg" d="M0,50V6c0-3.3,2.7-6,6-6h44v19.1c0.3-0.1,0.7-0.1,1-0.1c3.3,0,6,2.7,6,6s-2.7,6-6,6c-0.3,0-0.7,0-1-0.1V50H0z"/>
		</svg>"""

	puzzleTopLeftLine = new Layer
		parent: illustration00
		width: 0
		height: contentBorderWidth
		backgroundColor: puzzleBorderColor
		x: Align.right(cardBodyImageMarginHorizontal)
		y: puzzleTopLeft.minY
		index: 10
	puzzleTopLeftLine_moveIn = new Animation
		layer: puzzleTopLeftLine
		properties:
			width: (illustration00.width - puzzleTopLeft.maxX) + cardBodyImageMarginHorizontal + contentBorderWidth
			x: puzzleTopLeft.maxX - contentBorderWidth
		time: 0.4
		curve: "cubic-bezier(0.55, 0.055, 0.675, 0.19)"
	puzzleTopLeftLine_moveIn2 = new Animation
		layer: puzzleTopLeftLine
		properties:
			width: contentBorderWidth
			x: puzzleTopLeft.maxX - contentBorderWidth
		time: 0.3
		curve: "cubic-bezier(0.215, 0.61, 0.355, 1)"
	Utils.delay 0.1, ->
		puzzleTopLeftLine_moveIn.start()
	puzzleTopLeftLine_moveIn.on Events.AnimationEnd, ->
		puzzleTopLeftLine_moveIn2.start()
		puzzleTopLeftAnimation = """.puzzle_tl{animation-play-state:running;}"""
		Utils.insertCSS(puzzleTopLeftAnimation)
		puzzleTopLeftBackground.animate
			properties:
				opacity: 1
			time: 0.5
			delay: 0.2
			curve: "cubic-bezier(0.215, 0.61, 0.355, 1)"
	puzzleTopLeftLine_moveIn2.on Events.AnimationEnd, ->
		puzzleTopLeftLine.x = puzzleTopLeft.minX + puzzleBorderRadius

	puzzleBottomLeft = new Layer
		parent: illustration00
		width: 54
		height: 61
		x: 27
		y: 72
		backgroundColor: "null"
		index: 3
	puzzleBottomLeft.html = """
		<svg version="1.1"
			 x="0px" y="0px" width="54px" height="61px" viewBox="0 0 54 61" style="enable-background:new 0 0 54 61;" xml:space="preserve">
		<style type="text/css">
			.puzzle_bl{fill:none;stroke:#03C0E6;stroke-width:2;stroke-linecap:square;stroke-miterlimit:10;}
			.puzzle_bl{stroke-dashoffset:250;stroke-dasharray:250;animation:puzzle_bl_dash 1s cubic-bezier(0.215, 0.61, 0.355, 1) normal forwards;}
			@keyframes puzzle_bl_dash{to{stroke-dashoffset:0;}}
		</style>
		<path class="puzzle_bl" d="M53,9v51H8c-3.9,0-7-3.1-7-7V8h19c0-3.9,3.1-7,7-7s7,3.1,7,7h19"/>
		</svg>"""
	puzzleBottomLeftAnimation = """.puzzle_bl{animation-play-state:paused;}"""
	Utils.insertCSS(puzzleBottomLeftAnimation)

	puzzleBottomLeftBackground = new Layer
		parent: illustration00
		width: 50
		height: 57
		x: puzzleBottomLeft.x + contentBorderWidth
		y: puzzleBottomLeft.y + contentBorderWidth
		backgroundColor: "null"
		opacity: 0
		index: 2
	puzzleBottomLeftBackground.html = """
		<svg version="1.1"
			 x="0px" y="0px" width="50px" height="57px" viewBox="0 0 50 57" style="enable-background:new 0 0 50 57;" xml:space="preserve">
		<style type="text/css">
			.puzzle_bl_bg{fill-rule:evenodd;clip-rule:evenodd;fill:#D5F8FF;}
		</style>
		<path class="puzzle_bl_bg" d="M30.9,7H50v50H6c-3.3,0-6-2.7-6-6V7h19.1C19,6.7,19,6.3,19,6c0-3.3,2.7-6,6-6s6,2.7,6,6C31,6.3,31,6.7,30.9,7z"/>
		</svg>"""

	puzzleBottomLeftLine = new Layer
		parent: illustration00
		width: 0
		height: contentBorderWidth
		backgroundColor: puzzleBorderColor
		x: Align.right(cardBodyImageMarginHorizontal)
		y: puzzleBottomLeft.minY + puzzleEllipseRadius
		index: 10
	puzzleBottomLeftLine_moveIn = new Animation
		layer: puzzleBottomLeftLine
		properties:
			width: (illustration00.width - puzzleBottomLeft.maxX) + cardBodyImageMarginHorizontal + contentBorderWidth
			x: puzzleBottomLeft.maxX - contentBorderWidth
		time: 0.4
		curve: "cubic-bezier(0.55, 0.055, 0.675, 0.19)"
	puzzleBottomLeftLine_moveIn2 = new Animation
		layer: puzzleBottomLeftLine
		properties:
			width: contentBorderWidth
			x: puzzleBottomLeft.maxX - contentBorderWidth
		time: 0.3
		curve: "cubic-bezier(0.215, 0.61, 0.355, 1)"
	Utils.delay 0.2, ->
		puzzleBottomLeftLine_moveIn.start()
	puzzleBottomLeftLine_moveIn.on Events.AnimationEnd, ->
		puzzleBottomLeftLine_moveIn2.start()
		puzzleBottomLeftAnimation = """.puzzle_bl{animation-play-state:running;}"""
		Utils.insertCSS(puzzleBottomLeftAnimation)
		puzzleBottomLeftBackground.animate
			properties:
				opacity: 1
			time: 0.5
			delay: 0.2
			curve: "cubic-bezier(0.215, 0.61, 0.355, 1)"
	puzzleBottomLeftLine_moveIn2.on Events.AnimationEnd, ->
		puzzleBottomLeftLine.x = puzzleBottomLeft.minX
		puzzleBottomLeftLine.y = puzzleBottomLeft.minY + 24

	puzzleBottomRight = new Layer
		parent: illustration00
		width: 61
		height: 54
		x: 72
		y: 79
		backgroundColor: "null"
		index: 5
	puzzleBottomRight.html = """
		<svg version="1.1"
			 x="0px" y="0px" width="61px" height="54px" viewBox="0 0 61 54" style="enable-background:new 0 0 61 54;" xml:space="preserve">
		<style type="text/css">
			.puzzle_br{fill:none;stroke:#03C0E6;stroke-width:2;stroke-linecap:square;stroke-miterlimit:10;}
			.puzzle_br{stroke-dashoffset:250;stroke-dasharray:250;animation:puzzle_br_dash 1s cubic-bezier(0.215, 0.61, 0.355, 1) normal forwards;}
			@keyframes puzzle_br_dash{to{stroke-dashoffset:0;}}
		</style>
		<path class="puzzle_br" d="M52,53H8V34c-3.9,0-7-3.1-7-7s3.1-7,7-7V1h19c0,3.9,3.1,7,7,7s7-3.1,7-7h19v45c0,3.9-3.1,7-7,7"/>
		</svg>"""
	puzzleBottomRightAnimation = """.puzzle_br{animation-play-state:paused;}"""
	Utils.insertCSS(puzzleBottomRightAnimation)

	puzzleBottomRightBackground = new Layer
		parent: illustration00
		width: 57
		height: 50
		x: puzzleBottomRight.x + contentBorderWidth
		y: puzzleBottomRight.y + contentBorderWidth
		backgroundColor: "null"
		opacity: 0
		index: 4
	puzzleBottomRightBackground.html = """
		<svg version="1.1"
			 x="0px" y="0px" width="57px" height="50px" viewBox="0 0 57 50" style="enable-background:new 0 0 57 50;" xml:space="preserve">
		<style type="text/css">
			.puzzle_br_bg{fill-rule:evenodd;clip-rule:evenodd;fill:#D5F8FF;}
		</style>
		<path class="puzzle_br_bg" d="M39.9,0H57v44c0,3.3-2.7,6-6,6H7V30.9C6.7,31,6.3,31,6,31c-3.3,0-6-2.7-6-6s2.7-6,6-6c0.3,0,0.7,0,1,0.1V0h17.1
			c0.5,3.9,3.9,7,7.9,7S39.4,3.9,39.9,0z"/>
		</svg>"""

	puzzleBottomRightLine = new Layer
		parent: illustration00
		width: 0
		height: contentBorderWidth
		backgroundColor: puzzleBorderColor
		x: Align.right(cardBodyImageMarginHorizontal)
		y: puzzleBottomRight.maxY - contentBorderWidth
		index: 10
	puzzleBottomRightLine_moveIn = new Animation
		layer: puzzleBottomRightLine
		properties:
			width: (illustration00.width - puzzleBottomRight.maxX + puzzleBorderRadius) + cardBodyImageMarginHorizontal
			x: puzzleBottomRight.maxX - puzzleBorderRadius
		time: 0.4
		curve: "cubic-bezier(0.55, 0.055, 0.675, 0.19)"
	puzzleBottomRightLine_moveIn2 = new Animation
		layer: puzzleBottomRightLine
		properties:
			width: contentBorderWidth
			x: puzzleBottomRight.maxX - puzzleBorderRadius
		time: 0.3
		curve: "cubic-bezier(0.215, 0.61, 0.355, 1)"
	Utils.delay 0, ->
		puzzleBottomRightLine_moveIn.start()
	puzzleBottomRightLine_moveIn.on Events.AnimationEnd, ->
		puzzleBottomRightLine_moveIn2.start()
		puzzleBottomRightAnimation = """.puzzle_br{animation-play-state:running;}"""
		Utils.insertCSS(puzzleBottomRightAnimation)
		puzzleBottomRightBackground.animate
			properties:
				opacity: 1
			time: 0.5
			delay: 0.2
			curve: "cubic-bezier(0.215, 0.61, 0.355, 1)"
	puzzleBottomRightLine_moveIn2.on Events.AnimationEnd, ->
		puzzleBottomRightLine.x = puzzleBottomLeft.maxX
		
	puzzleTopRight = new Layer
		parent: illustration00
		width: 64
		height: 73
		x: 74
		y: 22
		backgroundColor: "null"
		index: 11
		originY: 1
		originX: 0
		scale: 1.5
		opacity: 0
	puzzleTopRight.html = """
		<svg version="1.1"
			 x="0px" y="0px" width="64px" height="73px" viewBox="0 0 64 73" style="enable-background:new 0 0 64 73;" xml:space="preserve">
		<style type="text/css">
			.puzzle_tr{fill:#FFFFFF;stroke:#03C0E6;stroke-width:2;stroke-miterlimit:10;}
		</style>
		<path class="puzzle_tr" d="M41,63h22V10c0-5-4-9-9-9H1v22c5,0,9,4,9,9s-4,9-9,9v22h22c0,5,4,9,9,9S41,68,41,63z"/>
		</svg>"""
	puzzleTopRightBackground = new Layer
		opacity: 0
		
	puzzleTopRightLine = new Layer
		parent: illustration00
		width: 0
		height: contentBorderWidth
		backgroundColor: puzzleBorderColor
		x: puzzleTopRight.minX + contentBorderWidth
		y: puzzleTopLeft.minX + 35
		index: 10

	puzzleArray.push puzzleTopLeft, puzzleTopRight, puzzleBottomLeft, puzzleBottomRight
	puzzleBackgroundArray.push puzzleTopLeftBackground, puzzleTopRightBackground, puzzleBottomLeftBackground, puzzleBottomRightBackground
	puzzleLineArray.push puzzleTopLeftLine, puzzleTopRightLine, puzzleBottomLeftLine, puzzleBottomRightLine

	Utils.delay 0.5, ->
		puzzleTopRight.animate
			properties:
				opacity: 1
				scale: 1
			time: 0.6
			curve: "cubic-bezier(0.23, 1, 0.32, 1)"
# Hide Illustration 00

illustration00Hide = () ->
	
	Utils.delay 0, ->
	
		puzzleArray[0].opacity = 0
		puzzleBackgroundArray[0].opacity = 0
		
		puzzleTopLeftReplacement = new Layer
			parent: illustration00Array[0]
			width: 61
			height: 54
			x: 27
			y: 27
			backgroundColor: "null"
			index: 1
		puzzleTopLeftReplacement.html = """
			<svg version="1.1"
				 x="0px" y="0px" width="61px" height="54px" viewBox="0 0 61 54" style="enable-background:new 0 0 61 54;" xml:space="preserve">
			<style type="text/css">
				.puzzle_tl_re{fill:none;stroke:#03C0E6;stroke-width:2;stroke-linecap:square;stroke-miterlimit:10;}
				.puzzle_tl_re{stroke-dashoffset:500;stroke-dasharray:250;animation:puzzle_tl_re_dash 0.75s cubic-bezier(0.215, 0.61, 0.355, 1) normal forwards;}
				@keyframes puzzle_tl_re_dash{to{stroke-dashoffset:250;}}
			</style>
			<path class="puzzle_tl_re" d="M8,1C4.1,1,1,4.1,1,8v45h19c0-3.9,3.1-7,7-7s7,3.1,7,7h19V34c3.9,0,7-3.1,7-7s-3.1-7-7-7V1H9"/>
			</svg>"""
	
		puzzleTopLeftReplacementBackground = new Layer
			parent: puzzleTopLeftReplacement
			width: 57
			height: 50
			x: contentBorderWidth
			y: contentBorderWidth
			backgroundColor: "null"
		puzzleTopLeftReplacementBackground.html = """
			<svg version="1.1"
				 x="0px" y="0px" width="57px" height="50px" viewBox="0 0 57 50" style="enable-background:new 0 0 57 50;" xml:space="preserve">
			<style type="text/css">
				.puzzle_tl_re_bg{fill-rule:evenodd;clip-rule:evenodd;fill:#D5F8FF;}
			</style>
			<path class="puzzle_tl_re_bg" d="M0,50V6c0-3.3,2.7-6,6-6h44v19.1c0.3-0.1,0.7-0.1,1-0.1c3.3,0,6,2.7,6,6s-2.7,6-6,6c-0.3,0-0.7,0-1-0.1V50H0z"/>
			</svg>"""
		
		puzzleTopLeftLine_moveOut = new Animation
			layer: puzzleLineArray[0]
			properties:
				x: Align.left(-cardBodyImageMarginHorizontal)
				width: puzzleArray[0].minX + puzzleBorderRadius + cardBodyImageMarginHorizontal
			time: 0.4
			curve: "cubic-bezier(0.55, 0.055, 0.675, 0.19)"
		puzzleTopLeftLine_moveOut2 = new Animation
			layer: puzzleLineArray[0]
			properties:
				width: 0
				x: Align.left(-cardBodyImageMarginHorizontal)
			time: 0.3
			curve: "cubic-bezier(0.215, 0.61, 0.355, 1)"
	
		Utils.delay 0, ->
			puzzleTopLeftReplacementBackground.animate
				properties:
					opacity: 0
				time: 0.3
				curve: "cubic-bezier(0.215, 0.61, 0.355, 1)"
			Utils.delay 0.15, ->
				puzzleTopLeftLine_moveOut.start()
		puzzleTopLeftLine_moveOut.on Events.AnimationEnd, ->
			puzzleTopLeftLine_moveOut2.start()

	Utils.delay 0.1, ->

		puzzleArray[2].opacity = 0
		puzzleBackgroundArray[2].opacity = 0
		
		puzzleBottomLeftReplacement = new Layer
			parent: illustration00Array[0]
			width: 54
			height: 61
			x: 27
			y: 72
			backgroundColor: "null"
			index: 3
		puzzleBottomLeftReplacement.html = """
			<svg version="1.1"
				 x="0px" y="0px" width="54px" height="61px" viewBox="0 0 54 61" style="enable-background:new 0 0 54 61;" xml:space="preserve">
			<style type="text/css">
				.puzzle_bl_re{fill:none;stroke:#03C0E6;stroke-width:2;stroke-linecap:square;stroke-miterlimit:10;}
				.puzzle_bl_re{stroke-dashoffset:500;stroke-dasharray:250;animation:puzzle_bl_re_dash 0.75s cubic-bezier(0.215, 0.61, 0.355, 1) normal forwards;}
				@keyframes puzzle_bl_re_dash{to{stroke-dashoffset:250;}}
			</style>
			<path class="puzzle_bl_re" d="M1,25V8h19c0-3.9,3.1-7,7-7s7,3.1,7,7h19v52H8c-3.9,0-7-3.1-7-7V26"/>
			</svg>"""
	
		puzzleBottomLeftReplacementBackground = new Layer
			parent: puzzleBottomLeftReplacement
			width: 50
			height: 57
			x: contentBorderWidth
			y: contentBorderWidth
			backgroundColor: "null"
		puzzleBottomLeftReplacementBackground.html = """
			<svg version="1.1"
				 x="0px" y="0px" width="50px" height="57px" viewBox="0 0 50 57" style="enable-background:new 0 0 50 57;" xml:space="preserve">
			<style type="text/css">
				.puzzle_bl_re_bg{fill-rule:evenodd;clip-rule:evenodd;fill:#D5F8FF;}
			</style>
			<path class="puzzle_bl_re_bg" d="M30.9,7H50v50H6c-3.3,0-6-2.7-6-6V7h19.1C19,6.7,19,6.3,19,6c0-3.3,2.7-6,6-6s6,2.7,6,6C31,6.3,31,6.7,30.9,7z"/>
			</svg>"""
		
		puzzleBottomLeftLine_moveOut = new Animation
			layer: puzzleLineArray[2]
			properties:
				x: Align.left(-cardBodyImageMarginHorizontal)
				width: puzzleArray[2].minX + cardBodyImageMarginHorizontal
			time: 0.4
			curve: "cubic-bezier(0.55, 0.055, 0.675, 0.19)"
		puzzleBottomLine_moveOut2 = new Animation
			layer: puzzleLineArray[2]
			properties:
				width: 0
				x: Align.left(-cardBodyImageMarginHorizontal)
			time: 0.3
			curve: "cubic-bezier(0.215, 0.61, 0.355, 1)"
	
		Utils.delay 0, ->
			puzzleBottomLeftReplacementBackground.animate
				properties:
					opacity: 0
				time: 0.3
				curve: "cubic-bezier(0.215, 0.61, 0.355, 1)"
			Utils.delay 0.15, ->
				puzzleBottomLeftLine_moveOut.start()
		puzzleBottomLeftLine_moveOut.on Events.AnimationEnd, ->
			puzzleBottomLine_moveOut2.start()

	Utils.delay 0.2, ->
		
		puzzleArray[3].opacity = 0
		puzzleBackgroundArray[3].opacity = 0
		
		puzzleBottomRightReplacement = new Layer
			parent: illustration00Array[0]
			width: 61
			height: 54
			x: 72
			y: 79
			backgroundColor: "null"
			index: 5
		puzzleBottomRightReplacement.html = """
			<svg version="1.1"
				 x="0px" y="0px" width="61px" height="54px" viewBox="0 0 61 54" style="enable-background:new 0 0 61 54;" xml:space="preserve">
			<style type="text/css">
				.puzzle_br_re{fill:none;stroke:#03C0E6;stroke-width:2;stroke-linecap:square;stroke-miterlimit:10;}
				.puzzle_br_re{stroke-dashoffset:500;stroke-dasharray:250;animation:puzzle_br_re_dash 0.75s cubic-bezier(0.215, 0.61, 0.355, 1) normal forwards;}
				@keyframes puzzle_br_re_dash{to{stroke-dashoffset:250;}}
			</style>
			<path class="puzzle_br_re" d="M8,52V34c-3.9,0-7-3.1-7-7s3.1-7,7-7V1h19c0,3.9,3.1,7,7,7s7-3.1,7-7h19v45c0,3.9-3.1,7-7,7H8"/>
			</svg>"""
	
		puzzleBottomRightReplacementBackground = new Layer
			parent: puzzleBottomRightReplacement
			width: 57
			height: 50
			x: contentBorderWidth
			y: contentBorderWidth
			backgroundColor: "null"
		puzzleBottomRightReplacementBackground.html = """
			<svg version="1.1"
				 x="0px" y="0px" width="57px" height="50px" viewBox="0 0 57 50" style="enable-background:new 0 0 57 50;" xml:space="preserve">
			<style type="text/css">
				.puzzle_br_re_bg{fill-rule:evenodd;clip-rule:evenodd;fill:#D5F8FF;}
			</style>
			<path class="puzzle_br_re_bg" d="M39.9,0H57v44c0,3.3-2.7,6-6,6H7V30.9C6.7,31,6.3,31,6,31c-3.3,0-6-2.7-6-6s2.7-6,6-6c0.3,0,0.7,0,1,0.1V0h17.1
				c0.5,3.9,3.9,7,7.9,7S39.4,3.9,39.9,0z"/>
			</svg>"""
		
		puzzleBottomRightLine_moveOut = new Animation
			layer: puzzleLineArray[3]
			properties:
				x: Align.left(-cardBodyImageMarginHorizontal)
				width: puzzleArray[2].maxX + cardBodyImageMarginHorizontal
			time: 0.4
			curve: "cubic-bezier(0.55, 0.055, 0.675, 0.19)"
		puzzleBottomRightLine_moveOut2 = new Animation
			layer: puzzleLineArray[3]
			properties:
				width: 0
				x: Align.left(-cardBodyImageMarginHorizontal)
			time: 0.3
			curve: "cubic-bezier(0.215, 0.61, 0.355, 1)"
			
		Utils.delay 0, ->
			puzzleBottomRightReplacementBackground.animate
				properties:
					opacity: 0
				time: 0.3
				curve: "cubic-bezier(0.215, 0.61, 0.355, 1)"
			Utils.delay 0.15, ->
				puzzleBottomRightLine_moveOut.start()

		puzzleBottomRightLine_moveOut.on Events.AnimationEnd, ->
			puzzleBottomRightLine_moveOut2.start()
			
	Utils.delay 0.3, ->
		
		puzzleArray[1].opacity = 0
		puzzleBackgroundArray[1].opacity = 0
	
		puzzleTopRightReplacement = new Layer
			parent: illustration00Array[0]
			width: 64
			height: 73
			x: 74
			y: 22
			index: 11
			backgroundColor: "null"
		puzzleTopRightReplacement.html = """
			<svg version="1.1"
				 x="0px" y="0px" width="64px" height="73px" viewBox="0 0 64 73" style="enable-background:new 0 0 64 73;" xml:space="preserve">
			<style type="text/css">
				.puzzle_tr_re{fill:none;stroke:#03C0E6;stroke-width:2;stroke-linecap:square;stroke-miterlimit:10;}
				.puzzle_tr_re{stroke-dashoffset:540;stroke-dasharray:270;animation:puzzle_tr_re_dash 0.7s cubic-bezier(0.215, 0.61, 0.355, 1) normal forwards;}
				@keyframes puzzle_tr_re_dash{to{stroke-dashoffset:270;}}
			</style>
			<path class="puzzle_tr_re" d="M1,41c5,0,9-4,9-9s-4-9-9-9V1h53c5,0,9,4,9,9v53H41c0,5-4,9-9,9s-9-4-9-9H1V42"/>
			</svg>"""
		puzzleTopRightReplacementBackground = new Layer
			parent: illustration00Array[0]
			width: puzzleTopRightReplacement.width
			height: puzzleTopRightReplacement.height
			x: puzzleTopRightReplacement.x
			y: puzzleTopRightReplacement.y
			index: 10
			backgroundColor: "null"
		puzzleTopRightReplacementBackground.html = """
			<svg version="1.1"
				 x="0px" y="0px" width="64px" height="73px" viewBox="0 0 64 73" style="enable-background:new 0 0 64 73;" xml:space="preserve">
			<style type="text/css">
				.puzzle_tr_re_bg{fill-rule:evenodd;clip-rule:evenodd;fill:#FFFFFF;}
			</style>
			<path class="puzzle_tr_re_bg" d="M42,64h22V10c0-5.5-4.5-10-10-10H0v24.1C0.3,24,0.7,24,1,24c4.4,0,8,3.6,8,8s-3.6,8-8,8c-0.3,0-0.7,0-1-0.1V64
				h22c0.5,5.1,4.8,9,10,9S41.4,69.1,42,64z"/>
			</svg>"""
		puzzleTopRightLine_moveOut = new Animation
			layer: puzzleLineArray[1]
			properties:
				x: Align.left(-cardBodyImageMarginHorizontal)
				width: puzzleArray[1].minX + cardBodyImageMarginHorizontal + contentBorderWidth
			time: 0.4
			curve: "cubic-bezier(0.55, 0.055, 0.675, 0.19)"
		puzzleTopRightLine_moveOut2 = new Animation
			layer: puzzleLineArray[1]
			properties:
				width: 0
				x: Align.left(-cardBodyImageMarginHorizontal)
			time: 0.3
			curve: "cubic-bezier(0.215, 0.61, 0.355, 1)"
	
		Utils.delay 0, ->
			puzzleTopRightReplacementBackground.animate
				properties:
					opacity: 0
				time: 0.3
				curve: "cubic-bezier(0.215, 0.61, 0.355, 1)"
			Utils.delay 0.15, ->
				puzzleTopRightLine_moveOut.start()
		puzzleTopRightLine_moveOut.on Events.AnimationEnd, ->
			puzzleTopRightLine_moveOut2.start()
			
	Utils.delay 1.5, ->
		puzzleArray = []
		puzzleBackgroundArray = []
		puzzleLineArray = []
		illustration00Array[0].destroy()
		illustration00Array = []
# Show Illustration 01

paperArray = []
paperBackgroundArray = []
paperLineArray = []

ovalArray = []
miscArray = []

illustration01Array = []

illustration01Show = () ->

	illustration01 = new Layer parent: cardBody, x: Align.center, y: cardBodyPaddingTop, width: 160, height: 160, backgroundColor: "null", clip: false
	illustration01Array.push illustration01

	paperLeft = new Layer
		parent: illustration01
		x: 29
		y: 20
		width: 88
		height: 106
		backgroundColor: "null"
		index: 3
	paperLeft.html = """
		<svg version="1.1"
			 x="0px" y="0px" width="88px" height="106px" viewBox="0 0 88 106" style="enable-background:new 0 0 88 106;"
			 xml:space="preserve">
		<style type="text/css">
			.paper_left{fill:none;stroke:#03C0E6;stroke-width:2;stroke-linecap:square;stroke-miterlimit:10;}
			.paper_left{stroke-dashoffset:380;stroke-dasharray:380;animation:paper_left_dash 0.75s cubic-bezier(0.39, 0.575, 0.565, 1) normal forwards;}
			@keyframes paper_left_dash{to{stroke-dashoffset:0;}}
		</style>
		<path class="paper_left" d="M81,105H6c-2.8,0-5-2.2-5-5V6c0-2.8,2.2-5,5-5h76c2.8,0,5,2.2,5,5v94c0,2.8-2.2,5-5,5"/>
		</svg>"""
	paperLeftBackground = new Layer
		parent: illustration01
		x: paperLeft.x + contentBorderWidth / 2
		y: paperLeft.y + contentBorderWidth / 2
		width: paperLeft.width - contentBorderWidth
		height: paperLeft.height - contentBorderWidth
		backgroundColor: "null"
		opacity: 0
		index: 2
	paperLeftBackground.html = """
		<svg version="1.1"
			 x="0px" y="0px" width="86px" height="104px" viewBox="0 0 86 104" style="enable-background:new 0 0 86 104;"
			 xml:space="preserve">
		<style type="text/css">
			.paper_left_bg{fill-rule:evenodd;clip-rule:evenodd;fill:#FFFFFF;}
		</style>
		<path class="paper_left_bg" d="M5,104c-2.8,0-5-2.2-5-5V5c0-2.8,2.2-5,5-5h76c2.8,0,5,2.2,5,5v94c0,2.8-2.2,5-5,5H5z"/>
		</svg>"""
	paperLeftAnimation = """.paper_left{animation-play-state:paused;}"""
	Utils.insertCSS(paperLeftAnimation)

	paperLeftContent = new Layer
		parent: illustration01
		x: 29
		y: 19
		width: 88
		height: 108
		backgroundColor: "null"

	paperLeftLine = new Layer
		parent: illustration01
		width: 0
		height: contentBorderWidth
		backgroundColor: "#03C0E6"
		x: illustration01.maxX + cardBodyImageMarginHorizontal
		y: paperLeft.maxY - contentBorderWidth
		index: 3
	paperLeftLineMoveIn = new Animation
		layer: paperLeftLine
		properties:
			width: (illustration01.width - paperLeft.minX) + cardBodyImageMarginHorizontal
			x: paperLeft.maxX - paperBorderRadius - contentBorderWidth
		time: 0.4
		curve: "cubic-bezier(0.55, 0.055, 0.675, 0.19)"
	paperLeftLineMoveIn2 = new Animation
		layer: paperLeftLine
		properties:
			width: contentBorderWidth
			x: paperLeft.maxX - paperBorderRadius - contentBorderWidth
		time: 0.3
		curve: "cubic-bezier(0.215, 0.61, 0.355, 1)"
	paperLeftLineMoveIn.on Events.AnimationEnd, ->
		paperLeftLineMoveIn2.start()
	paperLeftLineMoveIn2.on Events.AnimationEnd, ->
		paperLeftLine.x = paperLeft.minX + paperBorderRadius
	Utils.delay 0, ->
		paperLeftLineMoveIn.start()
		Utils.delay 0.4, ->
			paperLeftAnimation = """.paper_left{animation-play-state:running;}"""
			Utils.insertCSS(paperLeftAnimation)
			paperLeftBackground.animate
				properties:
					opacity: 1
				time: 0.5
				delay: 0.3
			
	paperRight = new Layer
		parent: illustration01
		x: 43
		y: 34
		width: 88
		height: 106
		backgroundColor: "null"
		index: 1
	paperRight.html = """
		<svg version="1.1"
			 x="0px" y="0px" width="88px" height="106px" viewBox="0 0 88 106" style="enable-background:new 0 0 88 106;"
			 xml:space="preserve">
		<style type="text/css">
			.paper_right{fill:none;stroke:#03C0E6;stroke-width:2;stroke-linecap:square;stroke-miterlimit:10;}
			.paper_right{stroke-dashoffset:380;stroke-dasharray:380;animation:paper_right_dash 0.75s cubic-bezier(0.39, 0.575, 0.565, 1) normal forwards;}
			@keyframes paper_right_dash{to{stroke-dashoffset:0;}}
		</style>
		<path class="paper_right" d="M81,1H6C3.2,1,1,3.2,1,6v94c0,2.8,2.2,5,5,5h76c2.8,0,5-2.2,5-5V6c0-2.8-2.2-5-5-5"/>
		</svg>"""
	paperRightBackground = new Layer
		parent: illustration01
		x: paperRight.x + contentBorderWidth / 2
		y: paperRight.y + contentBorderWidth / 2
		width: paperRight.width - contentBorderWidth
		height: paperRight.height - contentBorderWidth
		backgroundColor: "null"
		opacity: 0
		index: 0
	paperRightBackground.html = """
		<svg version="1.1"
			 x="0px" y="0px" width="86px" height="104px" viewBox="0 0 86 104" style="enable-background:new 0 0 86 104;"
			 xml:space="preserve">
		<style type="text/css">
			.paper_right_bg{fill-rule:evenodd;clip-rule:evenodd;fill:#D5F8FF;}
		</style>
		<path class="paper_right_bg" d="M5,104c-2.8,0-5-2.2-5-5V5c0-2.8,2.2-5,5-5h76c2.8,0,5,2.2,5,5v94c0,2.8-2.2,5-5,5H5z"/>
		</svg>"""
	paperRightAnimation = """.paper_right{animation-play-state:paused;}"""
	Utils.insertCSS(paperRightAnimation)

	paperRightLine = new Layer
		parent: illustration01
		width: 0
		height: contentBorderWidth
		backgroundColor: "#03C0E6"
		x: illustration01.maxX + cardBodyImageMarginHorizontal
		y: paperRight.minY
		index: 1
	paperRightLineMoveIn = new Animation
		layer: paperRightLine
		properties:
			width: (illustration01.width - paperRight.minX) + cardBodyImageMarginHorizontal
			x: paperRight.maxX - paperBorderRadius
		time: 0.4
		curve: "cubic-bezier(0.55, 0.055, 0.675, 0.19)"
	paperRightLineMoveIn2 = new Animation
		layer: paperRightLine
		properties:
			width: contentBorderWidth
			x: paperRight.maxX - paperBorderRadius
		time: 0.3
		curve: "cubic-bezier(0.215, 0.61, 0.355, 1)"
	paperRightLineMoveIn.on Events.AnimationEnd, ->
		paperRightLineMoveIn2.start()
	paperRightLineMoveIn2.on Events.AnimationEnd, ->
		paperRightLine.x = paperRight.minX + paperBorderRadius
	Utils.delay 0.1, ->
		paperRightLineMoveIn.start()
		Utils.delay 0.4, ->
			paperRightAnimation = """.paper_right{animation-play-state:running;}"""
			Utils.insertCSS(paperRightAnimation)
			paperRightBackground.animate
				properties:
					opacity: 1
				time: 0.5
				delay: 0.3
				
	PaperLeftOpenBrace = new Layer
		parent: paperLeftContent
		width: 9
		height: 26
		backgroundColor: "null"
		x: 12
		y: Align.center
	PaperLeftOpenBrace.html = """
		<svg version="1.1"
			 x="0px" y="0px" width="9px" height="26px" viewBox="0 0 9 26" style="enable-background:new 0 0 9 26;" xml:space="preserve">
		<style type="text/css">
			.brace_left{fill:none;stroke:#03C0E6;stroke-width:2;stroke-miterlimit:10;}
			.brace_left{stroke-dashoffset:40;stroke-dasharray:40;animation:brace_left_dash 0.3s cubic-bezier(0.39, 0.575, 0.565, 1) normal forwards;}
			@keyframes brace_left_dash{to{stroke-dashoffset:0;}}
		</style>
		<path class="brace_left" d="M9,1H6.5C5.9,1,5.3,1.4,5.2,1.9L4.3,4.1C4.2,4.6,4,5.5,4,6v4c0,0.5-0.3,1.3-0.7,1.7L2,13H0h2l1.3,1.3
	C3.7,14.7,4,15.5,4,16v3c0,1.1,0.3,2.8,0.7,3.9l0.5,1.2C5.3,24.6,6,25,6.5,25H9"/>
		</svg>"""
	PaperLeftOpenBrace = """.brace_left{animation-play-state:paused;}"""
	Utils.insertCSS(PaperLeftOpenBrace)
	
	paperLeftCloseBrace = new Layer
		parent: paperLeftContent
		width: 9
		height: 26
		backgroundColor: "null"
		x: Align.right(-12)
		y: Align.center
	paperLeftCloseBrace.html = """
		<svg version="1.1"
			 x="0px" y="0px" width="9px" height="26px" viewBox="0 0 9 26" style="enable-background:new 0 0 9 26;" xml:space="preserve">
		<style type="text/css">
			.brace_right{fill:none;stroke:#03C0E6;stroke-width:2;stroke-miterlimit:10;}
			.brace_right{stroke-dashoffset:40;stroke-dasharray:40;animation:brace_right_dash 0.3s cubic-bezier(0.39, 0.575, 0.565, 1) normal forwards;}
			@keyframes brace_right_dash{to{stroke-dashoffset:0;}}
		</style>
		<path class="brace_right" d="M0,25h2.5c0.5,0,1.1-0.4,1.3-0.9l0.5-1.2C4.7,21.8,5,20.1,5,19v-3c0-0.5,0.3-1.3,0.7-1.7L7,13h2H7l-1.3-1.3
	C5.3,11.3,5,10.6,5,10V6c0-0.5-0.2-1.4-0.3-1.9L3.8,1.9C3.7,1.4,3.1,1,2.5,1H0"/>
		</svg>"""
	paperLeftCloseBrace = """.brace_right{animation-play-state:paused;}"""
	Utils.insertCSS(paperLeftCloseBrace)
	
	paperArray.push paperLeft, paperRight
	paperBackgroundArray.push paperLeftBackground, paperRightBackground
	paperLineArray.push paperLeftLine, paperRightLine
	miscArray.push paperLeftContent
	
	Utils.delay 0.8, ->
		PaperLeftOpenBrace = """.brace_left{animation-play-state:running;}"""
		Utils.insertCSS(PaperLeftOpenBrace)	

		Utils.delay 0.2, ->
			ovalCount = 3
			ovalSize = 6
			
			ovalAll = new Layer
				parent: paperLeftContent
				x: Align.center
				y: Align.center
				width: ((ovalCount - 1) + ovalCount) * ovalSize
				height: ovalSize
				backgroundColor: "null"
			
			for i in [0...ovalCount]
				oval = new Layer
					parent: ovalAll
					name: "oval#{i}"
					id: "oval#{i}"
					x: ovalSize * i * 2
					y: Align.center
					size: ovalSize
					opacity: 0
					scale: 3
					borderRadius: ovalSize / 2
					backgroundColor: "#81DFF2"
					
				ovalArray.push oval
			
			for oval, i in ovalArray
				if i <= ovalCount
					oval.animate
						properties:
							scale: 1
							opacity: 1
						time: 0.3
						delay: 0.1 * i
						
		Utils.delay 0.4, ->
			paperLeftCloseBrace = """.brace_right{animation-play-state:running;}"""
			Utils.insertCSS(paperLeftCloseBrace)
			
			Utils.delay 0.4, ->
				ovalArray = []
# Hide Illustration 01

illustration01Hide = () ->

	paperArray[0].opacity = 0
	paperBackgroundArray[0].opacity = 0

	paperLeftReplacement = new Layer
		parent: illustration01Array[0]
		x: 29
		y: 20
		width: 88
		height: 106
		backgroundColor: "null"
		index: 3
	paperLeftReplacement.html = """
		<svg version="1.1"
			 x="0px" y="0px" width="88px" height="106px" viewBox="0 0 88 106" style="enable-background:new 0 0 88 106;"
			 xml:space="preserve">
		<style type="text/css">
			.paper_left_re{fill:none;stroke:#03C0E6;stroke-width:2;stroke-linecap:square;stroke-miterlimit:10;}
			.paper_left_re{stroke-dashoffset:760;stroke-dasharray:380;animation:paper_left_re_dash 0.75s cubic-bezier(0.39, 0.575, 0.565, 1) normal forwards;}
			@keyframes paper_left_re_dash{to{stroke-dashoffset:380;}}
		</style>
		<path class="paper_left_re" d="M6,105c-2.8,0-5-2.2-5-5V6c0-2.8,2.2-5,5-5h76c2.8,0,5,2.2,5,5v94c0,2.8-2.2,5-5,5H7"/>
		</svg>"""
	paperLeftReplacementBackground = new Layer
		parent: illustration01Array[0]
		x: paperLeftReplacement.x + contentBorderWidth / 2
		y: paperLeftReplacement.y + contentBorderWidth / 2
		width: paperLeftReplacement.width - contentBorderWidth
		height: paperLeftReplacement.height - contentBorderWidth
		backgroundColor: "null"
		index: 2
	paperLeftReplacementBackground.html = """
		<svg version="1.1"
			 x="0px" y="0px" width="86px" height="104px" viewBox="0 0 86 104" style="enable-background:new 0 0 86 104;"
			 xml:space="preserve">
		<style type="text/css">
			.paper_left_re_bg{fill-rule:evenodd;clip-rule:evenodd;fill:#FFFFFF;}
		</style>
		<path class="paper_left_re_bg" d="M5,104c-2.8,0-5-2.2-5-5V5c0-2.8,2.2-5,5-5h76c2.8,0,5,2.2,5,5v94c0,2.8-2.2,5-5,5H5z"/>
		</svg>"""
		
	paperLeftLineMoveOut = new Animation
		layer: paperLineArray[0]
		properties:
			width: paperLeftReplacement.minX + paperBorderRadius + cardBodyImageMarginHorizontal
			x: Align.left(-cardBodyImageMarginHorizontal)
		time: 0.4
		curve: "cubic-bezier(0.55, 0.055, 0.675, 0.19)"
	paperLeftLineMoveOut2 = new Animation
		layer: paperLineArray[0]
		properties:
			width: 0
			x: Align.left(-cardBodyImageMarginHorizontal)
		time: 0.3
		curve: "cubic-bezier(0.215, 0.61, 0.355, 1)"
	paperLeftLineMoveOut.on Events.AnimationEnd, ->
		paperLeftLineMoveOut2.start()
		
	Utils.delay 0, ->
		paperLeftReplacementBackground.animate
			properties:
				opacity: 0
			time: 0.5
			delay: 0.1
		miscArray[0].animate
			properties:
				opacity: 0
			time: 0.5
		Utils.delay 0.25, ->
			paperLeftLineMoveOut.start()
		
	paperArray[1].opacity = 0
	paperBackgroundArray[1].opacity = 0
		
	paperRightReplacement = new Layer
		parent: illustration01Array[0]
		x: 43
		y: 34
		width: 88
		height: 106
		backgroundColor: "null"
		index: 1
	paperRightReplacement.html = """
		<svg version="1.1"
			 x="0px" y="0px" width="88px" height="106px" viewBox="0 0 88 106" style="enable-background:new 0 0 88 106;"
			 xml:space="preserve">
		<style type="text/css">
			.paper_right_re{fill:none;stroke:#03C0E6;stroke-width:2;stroke-linecap:square;stroke-miterlimit:10;}
			.paper_right_re{stroke-dashoffset:760;stroke-dasharray:380;animation:paper_right_re_dash 0.75s cubic-bezier(0.39, 0.575, 0.565, 1) normal forwards;}
			@keyframes paper_right_re_dash{to{stroke-dashoffset:380;}}
		</style>
		<path class="paper_right_re" d="M6,1C3.2,1,1,3.2,1,6v94c0,2.8,2.2,5,5,5h76c2.8,0,5-2.2,5-5V6c0-2.8-2.2-5-5-5H7"/>
		</svg>"""
	paperRightReplacementAnimation = """.paper_right_re{animation-play-state:paused;}"""
	Utils.insertCSS(paperRightReplacementAnimation)
	
	paperRightReplacementBackground = new Layer
		parent: illustration01Array[0]
		x: paperRightReplacement.x + contentBorderWidth / 2
		y: paperRightReplacement.y + contentBorderWidth / 2
		width: paperRightReplacement.width - contentBorderWidth
		height: paperRightReplacement.height - contentBorderWidth
		backgroundColor: "null"
		index: 0
	paperRightReplacementBackground.html = """
		<svg version="1.1"
			 x="0px" y="0px" width="86px" height="104px" viewBox="0 0 86 104" style="enable-background:new 0 0 86 104;"
			 xml:space="preserve">
		<style type="text/css">
			.paper_right_re_bg{fill-rule:evenodd;clip-rule:evenodd;fill:#D5F8FF;}
		</style>
		<path class="paper_right_re_bg" d="M5,104c-2.8,0-5-2.2-5-5V5c0-2.8,2.2-5,5-5h76c2.8,0,5,2.2,5,5v94c0,2.8-2.2,5-5,5H5z"/>
		</svg>"""

	paperRightLineMoveOut = new Animation
		layer: paperLineArray[1]
		properties:
			width: paperRightReplacement.minX + paperBorderRadius + cardBodyImageMarginHorizontal
			x: Align.left(-cardBodyImageMarginHorizontal)
		time: 0.4
		curve: "cubic-bezier(0.55, 0.055, 0.675, 0.19)"
	paperRightLineMoveOut2 = new Animation
		layer: paperLineArray[1]
		properties:
			width: 0
			x: Align.left(-cardBodyImageMarginHorizontal)
		time: 0.3
		curve: "cubic-bezier(0.215, 0.61, 0.355, 1)"
	paperRightLineMoveOut.on Events.AnimationEnd, ->
		paperRightLineMoveOut2.start()
	
	paperRightReplacementBackground.animate
		properties:
			opacity: 0
		time: 0.5
		delay: 0.1
	
	Utils.delay 0.15, ->
		paperRightReplacementAnimation = """.paper_right_re{animation-play-state:running;}"""
		Utils.insertCSS(paperRightReplacementAnimation)

		Utils.delay 0.25, ->
			paperRightLineMoveOut.start()
	Utils.delay 1.5, ->
		paperArray = []
		paperBackgroundArray = []
		paperLineArray = []
		miscArray = []
		illustration01Array[0].destroy()
		illustration01Array = []
# Show Illustration 02

helixArray = []
helixBackgroundArray = []
helixLineArray = []

illustration02Array = []

illustration02Show = () ->

	illustration02 = new Layer parent: cardBody, x: Align.center, y: cardBodyPaddingTop, width: 160, height: 160, backgroundColor: "null", clip: false
	illustration02Array.push illustration02
	
	helixOuterBottom = new Layer
		parent: illustration02
		width: 70
		height: 98
		x: 21
		y: 41
		backgroundColor: "null"
		index: 1
	helixOuterBottom.html = """
		<svg version="1.1"
			 x="0px" y="0px" width="70px" height="98px" viewBox="0 0 70 98" style="enable-background:new 0 0 70 98;"
			 xml:space="preserve">
		<style type="text/css">
			.helix_ob{fill:none;stroke:#03C0E6;stroke-width:2;stroke-linecap:square;stroke-miterlimit:10;}
			.helix_ob{stroke-dashoffset:300;stroke-dasharray:300;animation:helix_ob_dash 1s cubic-bezier(0.215, 0.61, 0.355, 1) normal forwards;}
			@keyframes helix_ob_dash{to{stroke-dashoffset:0;}}
		</style>
		<path class="helix_ob"  d="M11,39c0,0-10,8.2-10,24c0,18.8,15.2,34,34,34s34-15.2,34-34S53.8,29,35,29c-9.8,0-14-8.3-14-14
	c0-7.7,6.3-14,14-14s14,6.3,14,14s-6.3,14-14,14"/>
		</svg>"""
	helixOuterBottomAnimation = """.helix_ob{animation-play-state:paused;}"""
	Utils.insertCSS(helixOuterBottomAnimation)

	helixOuterTop = new Layer
		parent: illustration02
		width: 60
		height: 70
		x: 79
		y: 21
		backgroundColor: "null"
		index: 1
	helixOuterTop.html = """
		<svg version="1.1"
			 x="0px" y="0px" width="60px" height="70px" viewBox="0 0 60 70" style="enable-background:new 0 0 60 70;" xml:space="preserve">
		<style type="text/css">
			.helix_ot{fill:none;stroke:#03C0E6;stroke-width:2;stroke-linecap:square;stroke-miterlimit:10;}
			.helix_ot{stroke-dashoffset:160;stroke-dasharray:160;animation:helix_ot_dash 0.5s cubic-bezier(0.215, 0.61, 0.355, 1) normal forwards;}
			@keyframes helix_ot_dash{to{stroke-dashoffset:0;}}
		</style>
		<path class="helix_ot" d="M1,10.9L1,10.9C7.1,4.8,15.6,1,25,1c18.8,0,34,15.2,34,34S43.8,69,25,69c-9.4,0-17.9-3.8-24-9.9"/>
		</svg>"""
	helixOuterTopAnimation = """.helix_ot{animation-play-state:paused;}"""
	Utils.insertCSS(helixOuterTopAnimation)

	helixInner = new Layer
		parent: illustration02
		size: 98
		x: 21
		y: 21
		backgroundColor: "null"
		index: 1
	helixInner.html = """
		<svg version="1.1"
			 x="0px" y="0px" width="98px" height="98px" viewBox="0 0 98 98" style="enable-background:new 0 0 98 98;" xml:space="preserve">
		<style type="text/css">
			.helix_inner{fill:none;stroke:#03C0E6;stroke-width:2;stroke-linecap:square;stroke-miterlimit:10;}
			.helix_inner{stroke-dashoffset:340;stroke-dasharray:340;animation:dash 1s cubic-bezier(0.215, 0.61, 0.355, 1) normal forwards;}
			@keyframes dash{to{stroke-dashoffset:0;}}
		</style>
		<path class="helix_inner" d="M35,69c-6.7,0-14,5.8-14,14s6.3,14,14,14s14-6.3,14-14S42.7,69,35,69c-9.7,1-33.7-8.6-34-34C1,16.2,16.2,1,35,1
			s34,15.2,34,34c0.2,11.1,10.7,14.2,14,14c7.7,0,14-6.3,14-14s-6.3-13.6-14-14s-14,6.5-14,14"/>
		</svg>"""
	helixInnerAnimation = """.helix_inner{animation-play-state:paused;}"""
	Utils.insertCSS(helixInnerAnimation)

	helixBackground = new Layer
		parent: illustration02
		x: 22
		y: 22
		size: 116
		backgroundColor: "null"
		opacity: 0
		index: 0
	helixBackground.html = """
		<svg version="1.1"
			 x="0px" y="0px" width="116px" height="116px" viewBox="0 0 116 116" style="enable-background:new 0 0 116 116;"
			 xml:space="preserve">
		<style type="text/css">
			.helix_bg{fill-rule:evenodd;clip-rule:evenodd;fill:#D5F8FF;}
		</style>
		<path class="helix_bg" d="M34,48c7.7,0,14-6.3,14-14s-6.3-14-14-14s-14,6.3-14,14S26.3,48,34,48z M34,96c7.7,0,14-6.3,14-14
			s-6.3-14-14-14s-14,6.3-14,14S26.3,96,34,96z M82,48c7.7,0,14-6.3,14-14s-6.3-14-14-14s-14,6.3-14,14S74.3,48,82,48z M58,9.9
			C64.1,3.8,72.6,0,82,0c18.8,0,34,15.2,34,34c0,18.8-15.2,34-34,34c-8.7,0-16.6-3.2-22.6-8.6c5.3,6,8.6,13.9,8.6,22.6
			c0,18.8-15.2,34-34,34S0,100.8,0,82c0-9.4,3.8-17.9,9.9-24C3.8,51.9,0,43.4,0,34C0,15.2,15.2,0,34,0C43.4,0,51.9,3.8,58,9.9z"/>
		</svg>"""

	helixInnerLine = new Layer
		parent: illustration02
		width: 0
		height: contentBorderWidth
		backgroundColor: puzzleBorderColor
		x: Align.right(cardBodyImageMarginHorizontal)
		y: 89
		index: 10
	helixInnerLine_moveIn = new Animation
		layer: helixInnerLine
		properties:
			width: (illustration02.width - 55) + cardBodyImageMarginHorizontal
			x: 55
		time: 0.4
		curve: "cubic-bezier(0.55, 0.055, 0.675, 0.19)"
	helixInnerLine_moveIn2 = new Animation
		layer: helixInnerLine
		properties:
			width: contentBorderWidth
			x: 55
		time: 0.3
		curve: "cubic-bezier(0.215, 0.61, 0.355, 1)"
	helixInnerLine_moveIn.on Events.AnimationEnd, ->
		helixInnerLine_moveIn2.start()

	helixArray.push helixOuterTop, helixOuterBottom, helixInner
	helixBackgroundArray.push helixBackground
	helixLineArray.push helixInnerLine

	Utils.delay 0, ->
		helixInnerLine_moveIn.start()
		
		Utils.delay 0.4, ->
			helixInnerAnimation = """.helix_inner{animation-play-state:running;}"""
			Utils.insertCSS(helixInnerAnimation)
			helixBackground.animate
				properties:
					opacity: 1
				time: 2
						
			Utils.delay 0.2, ->
				helixOuterBottomAnimation = """.helix_ob{animation-play-state:running;}"""
				Utils.insertCSS(helixOuterBottomAnimation)
				
				Utils.delay 0.2, ->
					helixOuterTopAnimation = """.helix_ot{animation-play-state:running;}"""
					Utils.insertCSS(helixOuterTopAnimation)
					
					Utils.delay 1, ->
						helixInnerLine.x = 55
						helixInnerLine.y = 69
# Hide Illustration 02

illustration02Hide = () ->
	
	for layer in helixArray
		layer.opacity = 0
	
	helixOuterBottomReplacement = new Layer
		parent: illustration02Array[0]
		width: 70
		height: 98
		x: 21
		y: 41
		backgroundColor: "null"
		index: 1
	helixOuterBottomReplacement.html = """
		<svg version="1.1"
			 x="0px" y="0px" width="70px" height="98px" viewBox="0 0 70 98" style="enable-background:new 0 0 70 98;"
			 xml:space="preserve">
		<style type="text/css">
			.helix_ob_re{fill:none;stroke:#03C0E6;stroke-width:2;stroke-linecap:square;stroke-miterlimit:10;}
			.helix_ob_re{stroke-dashoffset:620;stroke-dasharray:310;animation:helix_ob_re_dash 1s cubic-bezier(0.215, 0.61, 0.355, 1) normal forwards;}
			@keyframes helix_ob_re_dash{to{stroke-dashoffset:310;}}
		</style>
		<path class="helix_ob_re"  d="M11,39c0,0-10,8.2-10,24c0,18.8,15.2,34,34,34s34-15.2,34-34S53.8,29,35,29c-9.8,0-14-8.3-14-14
	c0-7.7,6.3-14,14-14s14,6.3,14,14s-6.3,14-14,14"/>
		</svg>"""
	helixOuterBottomReplacementAnimation = """.helix_ob_re{animation-play-state:paused;}"""
	Utils.insertCSS(helixOuterBottomReplacementAnimation)

	helixOuterTopReplacement = new Layer
		parent: illustration02Array[0]
		width: 60
		height: 70
		x: 79
		y: 21
		backgroundColor: "null"
		index: 1
	helixOuterTopReplacement.html = """
		<svg version="1.1"
			 x="0px" y="0px" width="60px" height="70px" viewBox="0 0 60 70" style="enable-background:new 0 0 60 70;" xml:space="preserve">
		<style type="text/css">
			.helix_ot_re{fill:none;stroke:#03C0E6;stroke-width:2;stroke-linecap:square;stroke-miterlimit:10;}
			.helix_ot_re{stroke-dashoffset:340;stroke-dasharray:170;animation:helix_ot_re_dash 0.75s cubic-bezier(0.215, 0.61, 0.355, 1) normal forwards;}
			@keyframes helix_ot_re_dash{to{stroke-dashoffset:170;}}
		</style>
		<path class="helix_ot_re" d="M1,59.1C7.1,65.2,15.6,69,25,69c18.8,0,34-15.2,34-34S43.8,1,25,1C15.6,1,7.1,4.8,1,10.9"/>
		</svg>"""
	helixOuterTopReplacementAnimation = """.helix_ot_re{animation-play-state:paused;}"""
	Utils.insertCSS(helixOuterTopReplacementAnimation)

	helixInnerReplacement = new Layer
		parent: illustration02Array[0]
		size: 98
		x: 21
		y: 21
		backgroundColor: "null"
		index: 1
	helixInnerReplacement.html = """
		<svg version="1.1"
			 x="0px" y="0px" width="98px" height="98px" viewBox="0 0 98 98" style="enable-background:new 0 0 98 98;" xml:space="preserve">
		<style type="text/css">
			.helix_inner_re{fill:none;stroke:#03C0E6;stroke-width:2;stroke-linecap:square;stroke-miterlimit:10;}
			.helix_inner_re{stroke-dashoffset:700;stroke-dasharray:350;animation:helix_inner_re_dash 0.75s cubic-bezier(0.215, 0.61, 0.355, 1) normal forwards;}
			@keyframes helix_inner_re_dash{to{stroke-dashoffset:350;}}
		</style>
		<path class="helix_inner_re" d="M69,35c0-7.5,6.3-14.4,14-14s14,6.3,14,14s-6.3,14-14,14C79.7,49.2,69.2,46.1,69,35C69,16.2,53.8,1,35,1
	S1,16.2,1,35c0.3,25.4,24.3,35,34,34c7.7,0,14,6.3,14,14s-6.3,14-14,14s-14-5.8-14-14s7.3-14,14-14"/>
		</svg>"""
	helixInnerReplacementAnimation = """.helix_inner_re{animation-play-state:paused;}"""
	Utils.insertCSS(helixInnerReplacementAnimation)

	helixInnerLine_moveOut = new Animation
		layer: helixLineArray[0]
		properties:
			width: 55 + cardBodyImageMarginHorizontal
			x: Align.left(-cardBodyImageMarginHorizontal)
		time: 0.4
		curve: "cubic-bezier(0.55, 0.055, 0.675, 0.19)"
	helixInnerLine_moveOut2 = new Animation
		layer: helixLineArray[0]
		properties:
			width: 0
			x: Align.left(-cardBodyImageMarginHorizontal)
		time: 0.3
		curve: "cubic-bezier(0.215, 0.61, 0.355, 1)"
	helixInnerLine_moveOut.on Events.AnimationEnd, ->
		helixInnerLine_moveOut2.start()
		
	Utils.delay 0, ->
		helixOuterTopReplacementAnimation = """.helix_ot_re{animation-play-state:running;}"""
		Utils.insertCSS(helixOuterTopReplacementAnimation)
		helixBackgroundArray[0].animate
			properties:
				opacity: 0
			time: 0.5
					
		Utils.delay 0, ->
			helixInnerReplacementAnimation = """.helix_inner_re{animation-play-state:running;}"""
			Utils.insertCSS(helixInnerReplacementAnimation)
			
			Utils.delay 0, ->
				helixOuterBottomReplacementAnimation = """.helix_ob_re{animation-play-state:running;}"""
				Utils.insertCSS(helixOuterBottomReplacementAnimation)
					
				Utils.delay 0.2, ->
					helixInnerLine_moveOut.start()
					Utils.delay 1, ->
						helixArray = []
						helixBackgroundArray = []
						helixLineArray = []
						illustration02Array[0].destroy()
						illustration02Array = []
# Show Illustration 03

boxArray = []
boxBackgroundArray = []
boxRopeArray = []
boxLineArray = []
boxLabelArray = []

illustration03Array = []

illustration03Show = () ->

	illustration03 = new Layer parent: cardBody, x: Align.center, y: cardBodyPaddingTop, width: 160, height: 160, backgroundColor: "null", clip: false
	illustration03Array.push illustration03
	
	boxTop = new Layer
		parent: illustration03
		width: 117
		height: 33
		x: Align.center
		y: 28
		backgroundColor: "null"
		index: 3
	boxTop.html = """
		<svg version="1.1"
			 x="0px" y="0px" width="117.5px" height="33px" viewBox="0 0 117.5 33" style="enable-background:new 0 0 117.5 33;"
			 xml:space="preserve">
		<style type="text/css">
			.box_top{fill:none;stroke:#03C0E6;stroke-width:2;stroke-miterlimit:10;}
			.box_top{stroke-dashoffset:270;stroke-dasharray:270;animation:box_top_dash 0.75s cubic-bezier(0.215, 0.61, 0.355, 1) normal forwards;}
			@keyframes box_top_dash{to{stroke-dashoffset:0;}}
		</style>
		<path class="box_top" d="M2.8,32c-1.7,0-2.2-1.1-1.3-2.5l17.6-26C20,2.1,22.1,1,23.8,1h70c1.7,0,3.8,1.1,4.7,2.5l17.6,26
	c0.9,1.4,0.3,2.5-1.3,2.5H3.8"/>
		</svg>"""
	boxTopAnimation = """.box_top{animation-play-state:paused;}"""
	Utils.insertCSS(boxTopAnimation)

	boxTopBackground = new Layer
		parent: illustration03
		width: 115
		height: 31
		x: Align.center
		y: 29
		backgroundColor: "null"
		opacity: 0
		index: 0
	boxTopBackground.html = """
		<svg version="1.1"
			 x="0px" y="0px" width="115.5px" height="31px" viewBox="0 0 115.5 31" style="enable-background:new 0 0 115.5 31;"
			 xml:space="preserve">
		<style type="text/css">
			.box_top_bg{fill-rule:evenodd;clip-rule:evenodd;fill:#D5F8FF;}
		</style>
		<path class="box_top_bg" d="M0.4,28.5C-0.5,29.9,0.1,31,1.8,31h112c1.7,0,2.3-1.1,1.3-2.5l-17.6-26c-0.9-1.4-3-2.5-4.7-2.5h-70
			c-1.7,0-3.8,1.1-4.7,2.5L0.4,28.5z"/>
		</svg>"""

	boxBottom = new Layer
		parent: illustration03
		width: 118
		height: 74
		x: Align.center
		y: 59
		backgroundColor: "null"
		index: 2
	boxBottom.html = """
		<svg version="1.1"
			 x="0px" y="0px" width="118px" height="71px" viewBox="0 0 118 71" style="enable-background:new 0 0 118 71;"
			 xml:space="preserve">
		<style type="text/css">
			.box_bottom{fill:none;stroke:#03C0E6;stroke-width:2;stroke-miterlimit:10;}
			.box_bottom{stroke-dashoffset:375;stroke-dasharray:375;animation:box_bottom_dash 0.75s cubic-bezier(0.215, 0.61, 0.355, 1) normal forwards;}
			@keyframes box_bottom_dash{to{stroke-dashoffset:0;}}
		</style>
		<path class="box_bottom" d="M2,1C1.4,1,1,1.4,1,2v64c0,2.2,1.8,4,4,4h108c2.2,0,4-1.8,4-4V2c0-0.6-0.4-1-1-1H3"/>
		</svg>"""
	boxBottomAnimation = """.box_bottom{animation-play-state:paused;}"""
	Utils.insertCSS(boxBottomAnimation)

	boxRope = new Layer
		parent: illustration03
		x: Align.center
		y: 28
		width: 18
		height: 70
		backgroundColor: "none"
		index: 2
	boxRope.html = """
		<svg version="1.1"
			 x="0px" y="0px" width="18px" height="70px" viewBox="0 0 18 70" style="enable-background:new 0 0 18 70;" xml:space="preserve">
		<style type="text/css">
			.box_rope{fill:none;stroke:#03C0E6;stroke-width:2;stroke-miterlimit:10;}
			.box_rope{stroke-dashoffset:160;stroke-dasharray:160;animation:box_rope_dash 0.75s cubic-bezier(0.215, 0.61, 0.355, 1) normal forwards;}
			@keyframes box_rope_dash{to{stroke-dashoffset:0;}}
		</style>
		<path class="box_rope" d="M6,0.2l-5,31v35c0,1.1,0.9,2,2,2h12c1.1,0,2-0.9,2-2v-35l-5-31"/>
		</svg>"""
	boxRopeAnimation = """.box_rope{animation-play-state:paused;}"""
	Utils.insertCSS(boxRopeAnimation)

	boxRopeBackground = new Layer
		parent: illustration03
		x: Align.center
		y: 29
		width: 16
		height: 68
		backgroundColor: "none"
		opacity: 0
		index: 1
	boxRopeBackground.html = """
		<svg version="1.1"
			 x="0px" y="0px" width="16px" height="68px" viewBox="0 0 16 68" style="enable-background:new 0 0 16 68;" xml:space="preserve">
		<style type="text/css">
			.box_rope_bg{fill-rule:evenodd;clip-rule:evenodd;fill:#FFFFFF;}
		</style>
		<path class="box_rope_bg" d="M5,0L0,31v35c0,1.1,0.9,2,2,2h12c1.1,0,2-0.9,2-2V31L11,0"/>
		</svg>"""

	boxLine = new Layer
		parent: illustration03
		width: 0
		height: contentBorderWidth
		backgroundColor: puzzleBorderColor
		x: Align.right(cardBodyImageMarginHorizontal)
		y: boxTop.maxY - contentBorderWidth
		index: 10
	boxLine_moveIn = new Animation
		layer: boxLine
		properties:
			width: (illustration03.width - boxTop.minX) + cardBodyImageMarginHorizontal + contentBorderWidth
			x: boxTop.minX + contentBorderWidth
		time: 0.4
		curve: "cubic-bezier(0.55, 0.055, 0.675, 0.19)"
	boxLine_moveIn2 = new Animation
		layer: boxLine
		properties:
			width: contentBorderWidth
			x: boxTop.minX + contentBorderWidth
		time: 0.3
		curve: "cubic-bezier(0.215, 0.61, 0.355, 1)"
	boxLine_moveIn.on Events.AnimationEnd, ->
		boxLine_moveIn2.start()
	
	boxLabel = new Layer
		parent: illustration03
		width: 30
		height: 12
		x: 36
		y: 95
		backgroundColor: "null"
		
	boxQ = new Layer
		parent: boxLabel
		width: 9
		height: 12
		backgroundColor: "null"
	boxQ.html = """
		<svg version="1.1"
			 x="0px" y="0px" width="9.3px" height="12.5px" viewBox="0 0 9.3 12.5" style="enable-background:new 0 0 9.3 12.5;"
			 xml:space="preserve">
		<style type="text/css">
			.box_q{fill:none;stroke:#03C0E6;stroke-linecap:square;stroke-miterlimit:10;}
			.box_q{stroke-dashoffset:27;stroke-dasharray:27;animation:box_q_dash 0.75s cubic-bezier(0.215, 0.61, 0.355, 1) normal forwards;}
			@keyframes box_q_dash{to{stroke-dashoffset:0;}}
		</style>
		<path class="box_q" d="M0.5,4.5C0.5,7,1.2,7.2,2.1,8c1,0.4,1.4,0,1.4,0l3,2L4.8,8c0,0,1.7-1,1.7-3.5s-1-3.5-3-4C1.5,1,0.5,2,0.5,4.5z"/>
		</svg>"""
	boxQAnimation = """.box_q{animation-play-state:paused;}"""
	Utils.insertCSS(boxQAnimation)

	boxM = new Layer
		parent: boxLabel
		x: boxQ.maxX
		y: -3
		width: 8
		height: 12
		backgroundColor: "null"
	boxM.html = """
		<svg version="1.1"
			 x="0px" y="0px" width="8px" height="11.9px" viewBox="0 0 8 11.9" style="enable-background:new 0 0 8 11.9;"
			 xml:space="preserve">
		<style type="text/css">
			.box_m{fill:none;stroke:#03C0E6;stroke-linecap:square;stroke-miterlimit:10;}
			.box_m{stroke-dashoffset:36;stroke-dasharray:36;animation:box_m_dash 0.75s cubic-bezier(0.215, 0.61, 0.355, 1) normal forwards;}
			@keyframes box_m_dash{to{stroke-dashoffset:0;}}
		</style>
		<polyline class="box_m" points="0.5,11.4 0.5,2.4 4,10.4 7.5,2.4 7.5,11.4 "/>
		</svg>"""
	boxMAnimation = """.box_m{animation-play-state:paused;}"""
	Utils.insertCSS(boxMAnimation)

	boxU = new Layer
		parent: boxLabel
		x: boxM.maxX + 2
		y: -3
		width: 6
		height: 9
		backgroundColor: "null"
	boxU.html = """
		<svg version="1.1"
			 x="0px" y="0px" width="6px" height="9.5px" viewBox="0 0 6 9.5" style="enable-background:new 0 0 6 9.5;" xml:space="preserve">
		<style type="text/css">
			.box_u{fill:none;stroke:#03C0E6;stroke-linecap:square;stroke-miterlimit:10;}
			.box_u{stroke-dashoffset:20;stroke-dasharray:20;animation:box_u_dash 0.75s cubic-bezier(0.215, 0.61, 0.355, 1) normal forwards;}
			@keyframes box_u_dash{to{stroke-dashoffset:0;}}
		</style>
		<path class="box_u" d="M0.5,0.5V7C0.5,7,1,9,3,9s2.5-2,2.5-2V0.5"/>
		</svg>"""
	boxUAnimation = """.box_u{animation-play-state:paused;}"""
	Utils.insertCSS(boxUAnimation)

	boxI = new Layer
		parent: boxLabel
		x: boxU.maxX + 2
		y: -3
		width: 1
		height: 9
		backgroundColor: "null"
	boxI.html = """
		<svg version="1.1"
			 x="0px" y="0px" width="1px" height="9px" viewBox="0 0 1 9" style="enable-background:new 0 0 1 9;" xml:space="preserve">
		<style type="text/css">
			.box_i{fill:none;stroke:#03C0E6;stroke-miterlimit:10;}
			.box_i{stroke-dashoffset:9;stroke-dasharray:9;animation:box_i_dash 0.75s cubic-bezier(0.215, 0.61, 0.355, 1) normal forwards;}
			@keyframes box_i_dash{to{stroke-dashoffset:0;}}
		</style>
		<line class="box_i" x1="0.5" y1="0" x2="0.5" y2="9"/>
		</svg>"""
	boxIAnimation = """.box_i{animation-play-state:paused;}"""
	Utils.insertCSS(boxIAnimation)

	boxArray.push boxTop, boxBottom
	boxBackgroundArray.push boxTopBackground
	boxRopeArray.push boxRope
	boxLineArray.push boxLine
	boxLabelArray.push boxLabel

	Utils.delay 0, ->
		boxLine_moveIn.start()
		Utils.delay 0.4, ->
			boxTopAnimation = """.box_top{animation-play-state:running;}"""
			Utils.insertCSS(boxTopAnimation)
			boxBottomAnimation = """.box_bottom{animation-play-state:running;}"""
			Utils.insertCSS(boxBottomAnimation)
			boxTopBackground.animate
				properties:
					opacity: 1
				time: 0.5
				delay: 0.2
			Utils.delay 0.2, ->
				boxRopeAnimation = """.box_rope{animation-play-state:running;}"""
				Utils.insertCSS(boxRopeAnimation)
				boxQAnimation = """.box_q{animation-play-state:running;}"""
				Utils.insertCSS(boxQAnimation)
				boxMAnimation = """.box_m{animation-play-state:running;}"""
				Utils.insertCSS(boxMAnimation)
				boxUAnimation = """.box_u{animation-play-state:running;}"""
				Utils.insertCSS(boxUAnimation)
				boxIAnimation = """.box_i{animation-play-state:running;}"""
				Utils.insertCSS(boxIAnimation)
				boxRopeBackground.animate
					properties:
						opacity: 1
					time: 1
				Utils.delay 1, ->
					boxLine.x = boxTop.maxX - contentBorderWidth
# Hide Illustration 03

illustration03Hide = () ->
	
	for layer in boxArray
		layer.opacity = 0
	boxBackgroundArray[0].opacity = 0
	boxRopeArray[0].opacity = 0

	boxTopReplacement = new Layer
		parent: illustration03Array[0]
		width: 117
		height: 33
		x: Align.center
		y: 28
		backgroundColor: "null"
		index: 3
	boxTopReplacement.html = """
		<svg version="1.1"
			 x="0px" y="0px" width="117.5px" height="33px" viewBox="0 0 117.5 33" style="enable-background:new 0 0 117.5 33;"
			 xml:space="preserve">
		<style type="text/css">
			.box_top_re{fill:none;stroke:#03C0E6;stroke-width:2;stroke-miterlimit:10;}
			.box_top_re{stroke-dashoffset:540;stroke-dasharray:270;animation:box_top_re_dash 0.75s cubic-bezier(0.215, 0.61, 0.355, 1) normal forwards;}
			@keyframes box_top_re_dash{to{stroke-dashoffset:270;}}
		</style>
		<path class="box_top_re" d="M113.8,32H2.8c-1.7,0-2.2-1.1-1.3-2.5l17.6-26C20,2.1,22.1,1,23.8,1h70c1.7,0,3.8,1.1,4.7,2.5l17.6,26
	c0.9,1.4,0.3,2.5-1.3,2.5"/>
		</svg>"""
	boxTopReplacementAnimation = """.box_top_re{animation-play-state:paused;}"""
	Utils.insertCSS(boxTopReplacementAnimation)

	boxTopReplacementBackground = new Layer
		parent: illustration03Array[0]
		width: 115
		height: 31
		x: Align.center
		y: 29
		backgroundColor: "null"
		index: 0
	boxTopReplacementBackground.html = """
		<svg version="1.1"
			 x="0px" y="0px" width="115.5px" height="31px" viewBox="0 0 115.5 31" style="enable-background:new 0 0 115.5 31;"
			 xml:space="preserve">
		<style type="text/css">
			.box_top_re_bg{fill-rule:evenodd;clip-rule:evenodd;fill:#D5F8FF;}
		</style>
		<path class="box_top_re_bg" d="M3.8,32h111c1.7,0,2.2-1.1,1.3-2.5l-17.6-26c-0.9-1.4-3-2.5-4.7-2.5h-70c-1.7,0-3.8,1.1-4.7,2.5l-17.6,26
	C0.5,30.9,1.1,32,2.8,32"/>
		</svg>"""

	boxBottomReplacement = new Layer
		parent: illustration03Array[0]
		width: 118
		height: 74
		x: Align.center
		y: 59
		backgroundColor: "null"
		index: 2
	boxBottomReplacement.html = """
		<svg version="1.1"
			 x="0px" y="0px" width="118px" height="71px" viewBox="0 0 118 71" style="enable-background:new 0 0 118 71;"
			 xml:space="preserve">
		<style type="text/css">
			.box_bottom_re{fill:none;stroke:#03C0E6;stroke-width:2;stroke-miterlimit:10;}
			.box_bottom_re{stroke-dashoffset:750;stroke-dasharray:375;animation:box_bottom_re_dash 0.75s cubic-bezier(0.215, 0.61, 0.355, 1) normal forwards;}
			@keyframes box_bottom_re_dash{to{stroke-dashoffset:375;}}
		</style>
		<path class="box_bottom_re" d="M115,1H2C1.4,1,1,1.4,1,2v64c0,2.2,1.8,4,4,4h108c2.2,0,4-1.8,4-4V2c0-0.6-0.4-1-1-1"/>
		</svg>"""
	boxBottomReplacementAnimation = """.box_bottom_re{animation-play-state:paused;}"""
	Utils.insertCSS(boxBottomReplacementAnimation)

	boxRopeReplacement = new Layer
		parent: illustration03Array[0]
		x: Align.center
		y: 28
		width: 18
		height: 70
		backgroundColor: "none"
		index: 2
	boxRopeReplacement.html = """
		<svg version="1.1"
			 x="0px" y="0px" width="18px" height="70px" viewBox="0 0 18 70" style="enable-background:new 0 0 18 70;" xml:space="preserve">
		<style type="text/css">
			.box_rope_re{fill:none;stroke:#03C0E6;stroke-width:2;stroke-miterlimit:10;}
			.box_rope_re{stroke-dashoffset:320;stroke-dasharray:160;animation:box_rope_re_dash 0.75s cubic-bezier(0.215, 0.61, 0.355, 1) normal forwards;}
			@keyframes box_rope_re_dash{to{stroke-dashoffset:160;}}
		</style>
		<path class="box_rope_re" d="M12,0.2l5,31v35c0,1.1-0.9,2-2,2H3c-1.1,0-2-0.9-2-2v-35l5-31"/>
		</svg>"""
	boxRopeReplacementAnimation = """.box_rope_re{animation-play-state:paused;}"""
	Utils.insertCSS(boxRopeReplacementAnimation)

	boxRopeReplacementBackground = new Layer
		parent: illustration03Array[0]
		x: Align.center
		y: 29
		width: 16
		height: 68
		backgroundColor: "none"
		opacity: 0
		index: 1
	boxRopeReplacementBackground.html = """
		<svg version="1.1"
			 x="0px" y="0px" width="16px" height="68px" viewBox="0 0 16 68" style="enable-background:new 0 0 16 68;" xml:space="preserve">
		<style type="text/css">
			.box_rope_re_bg{fill-rule:evenodd;clip-rule:evenodd;fill:#FFFFFF;}
		</style>
		<path class="box_rope_re_bg" d="M5,0L0,31v35c0,1.1,0.9,2,2,2h12c1.1,0,2-0.9,2-2V31L11,0"/>
		</svg>"""

	boxLine_moveOut = new Animation
		layer: boxLineArray[0]
		properties:
			width: boxArray[0].maxX + cardBodyImageMarginHorizontal + contentBorderWidth
			x: Align.left(-cardBodyImageMarginHorizontal)
		time: 0.4
		curve: "cubic-bezier(0.55, 0.055, 0.675, 0.19)"
	boxLine_moveOut2 = new Animation
		layer: boxLineArray[0]
		properties:
			width: 0
			x: Align.left(-cardBodyImageMarginHorizontal)
		time: 0.3
		curve: "cubic-bezier(0.215, 0.61, 0.355, 1)"
	boxLine_moveOut.on Events.AnimationEnd, ->
		boxLine_moveOut2.start()

	Utils.delay 0, ->
		boxRopeReplacementAnimation = """.box_rope_re{animation-play-state:running;}"""
		Utils.insertCSS(boxRopeReplacementAnimation)
		boxRopeReplacementBackground.animate
			properties:
				opacity: 0
			time: 1
		boxLabelArray[0].animate
			properties:
				opacity: 0
			time: 0.5
		boxTopReplacementBackground.animate
			properties:
				opacity: 0
			time: 0.5
			delay: 0.2
		Utils.delay 0.2, ->
			boxTopReplacementAnimation = """.box_top_re{animation-play-state:running;}"""
			Utils.insertCSS(boxTopReplacementAnimation)
			boxBottomReplacementAnimation = """.box_bottom_re{animation-play-state:running;}"""
			Utils.insertCSS(boxBottomReplacementAnimation)

			Utils.delay 0.15, ->
				boxLine_moveOut.start()
				
				Utils.delay 1, ->
					boxArray = []
					boxBackgroundArray = []
					boxRopeArray = []
					boxLineArray = []
					boxLabelArray = []
					illustration03Array[0].destroy()
					illustration03Array = []

# Disable Tap

tapDisable = () ->
	
	tapDummy = new Layer
		width: Screen.width
		height: Screen.height
		backgroundColor: "null"
		index: 50
		
	tapDummy.on Events.TouchEnd, ->
		
	Utils.delay 2, ->
		tapDummy.destroy()
# Tap

illustration00Show()
cardLabelShow(pageCurrentNumber)

cardButton.onTapEnd ->
	
	tapDisable()
	
	pageCurrentNumber++
	if pageCurrentNumber == 4
		pageCurrentNumber = 0
	pageIndicatorSwitch()
	
	if pageCurrentNumber == 1
		illustration00Hide()
		Utils.delay 0.55, ->
			cardLabelHide()
			illustration01Show()
			cardLabelShow(pageCurrentNumber)
	else if pageCurrentNumber == 2
		illustration01Hide()
		Utils.delay 0.55, ->
			cardLabelHide()
			illustration02Show()
			cardLabelShow(pageCurrentNumber)
	else if pageCurrentNumber == 3
		illustration02Hide()
		Utils.delay 0.45, ->
			cardLabelHide()
			illustration03Show()
			cardLabelShow(pageCurrentNumber)
	else if pageCurrentNumber == 0
		illustration03Hide()
		Utils.delay 0.55, ->
			cardLabelHide()
			illustration00Show()
			cardLabelShow(pageCurrentNumber)
