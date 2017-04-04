# Project Info
# This info is presented in a widget when you share.
# http://framerjs.com/docs/#info.info

Framer.Info =
	title: "Dynamic Grid Gallery"
	author: "Jinju Jang"
	twitter: "@arle13"
	description: "Expandable, dynamic grid layout"


# Woohoo magic. Change the below numbers! ;) 
rowCount = 6
columnCount = 2

gutter = 25
inset = 20
borderRadius = 6 * 2

touchFeedbackTime = 0.25
animationCurve = 'ease-in-out'
# You can also set a different column based on device size. 
if Screen.width >= 414*3
	columnCount = 3

if Screen.width >= 768*2
	columnCount = 4

# Colours 
Shade1 = "#fafbfc"
Shade2 = "#E0E6EB"
Shade3 = "#BEC6CC"
ColorBg = "#F8CE64"

# background colours 
Canvas.backgroundColor = ColorBg
 
bg = new BackgroundLayer
	backgroundColor: Shade2
	
scroll = new ScrollComponent
	width: Screen.width - gutter
	height: Screen.height
	x: Align.center
	scrollHorizontal: false
	contentInset: top: inset, bottom: inset
	backgroundColor: "Transparent"

scroll.style = 
	marginLeft: (gutter / 2) + "px"

tileWidth = newWidth = newHeight = (scroll.width)/columnCount
tileAspects = [(1), (1.25), (1.35), (0.75)]

tiles = []
originXPos = []
originYPos = []
originWidth = []
originHeight = []
originImageWidth = []
originImageHeight = []

# Loop to create grid tiles
for index in [0...rowCount]
	for j in [0...columnCount]
		tileContainer = new Layer
			parent: scroll.content
			width: tileWidth - gutter
			height: 480
			x: tileWidth * j
			y: 480 * index
			borderRadius: borderRadius + (inset / 2) 
			backgroundColor: Shade1
		tileContainer.style = 
			"box-shadow": "0px 2px 16px 0px rgba(0,0,0,0.1)"
							
		tileImage = new Layer	
			parent: tileContainer
			x: Align.center
			y: inset
			width: tileContainer.width - (inset * 2)
			height: (tileContainer.width - (inset * 2)) * Utils.randomChoice(tileAspects)
			borderRadius: borderRadius
			originX: 0
			originY: 0
		tileImage.image = Utils.randomImage(tileImage)

		tileDecription = new Layer
			parent: tileContainer
			width: tileImage.width
			x: Align.center
			y: tileImage.maxY
			height: 480 * (1/3)	
			backgroundColor: "Transparent"
		
		# Make random amount of text 
		textAmount = Utils.randomChoice([1, 2, 3,0])
		for k in [0..textAmount]
			line = new Layer
				parent: tileDecription
				x: inset
				height: 8*2
				y: (8*2 + inset) + (inset * k) 
				width: tileImage.width - (inset*2)
				backgroundColor: Shade2		
		tileOwner = new Layer	
			parent: tileDecription
			width: 32*2
			height: 32*2
			x: inset
			y: line.maxY + (inset)
			borderRadius: "50%"
			backgroundColor: Shade3
		
		OwnerName = new Layer
			parent: 	tileDecription
			x: tileOwner.maxX  + (inset)
			y: tileOwner.y + (4*2)
			width: (line.width - tileOwner.maxX) * 0.75
			height: 8*2
			backgroundColor: Shade2

		OwnerInfo = new Layer
			parent: 	tileDecription
			x: tileOwner.maxX  + (inset)
			y: OwnerName.maxY + (inset/4)
			width: (line.width - tileOwner.maxX) * 0.5
			height: 8*2
			backgroundColor: Shade2

		tileDecription.height = tileOwner.maxY + inset
		tiles.push(tileContainer)			
tileNumber = tiles.length 
tileImages = (tile.children[0] for tile in tiles)

for tile in tiles
	tile.height = tile.children[0].height + tile.children[1].height + gutter
	originHeight.push(tile.height)

for index in [0...tileNumber]
	tiles[index].listIndex = index
	tileImages[index].listIndex = index
	originImageWidth.push(tileImages[index].width)
	originImageHeight.push(tileImages[index].height)
	
	if index >= columnCount
		tiles[index].y = tiles[index-columnCount].maxY + gutter 
		scroll.updateContent()
	# capture positions
	originXPos.push(tiles[index].x)
	originYPos.push(tiles[index].y)
	originWidth.push(tiles[index].width)

touchFeedback = (events, layer) ->
	# Capture current Y position 
	currentPos = scroll.scrollY	
	currentIndex = layer.listIndex

	tileImage = layer.children[0]
	tileText = layer.children[1]
	
	# Aspect ratio values
	newWidth = scroll.width - gutter
	imgAspectRatio = (tileImage.height/tileImage.width)
	newImageWidth = newWidth - (inset*2)
	newImageheight = newImageWidth * imgAspectRatio
	newHeight = newImageheight + inset + tileText.height
				
	for pos in originYPos[0...tileNumber]
		if pos == layer.y			
			layer.states.add			
				expand:
					x: 0
					y: currentPos
					opacity: 1
					width: newWidth	
					height: newImageheight + inset + tileText.height
					scale:1
				
				initial: 
					scale: 1
					opacity: 1
					x: originXPos[currentIndex]
					y: originYPos[currentIndex]
					width: originWidth[currentIndex]
					height: originHeight[currentIndex] 
			
			layer.states.animationOptions = 
				time: touchFeedbackTime
				curve: animationCurve
			
			# Tile Image	
			tileImage.states.add
				expand:
					width: newImageWidth
					height: newImageheight
					
				initial:
					width: originImageWidth[currentIndex]
					height: originImageHeight[currentIndex]
			
			tileImage.states.animationOptions = 
				time: touchFeedbackTime
				curve: animationCurve
			
			# Tile text
			tileText.states.add
				expand:
					width: newImageWidth
					y: newImageheight + inset
				
				initial:
					width: 	originImageWidth[currentIndex]
					y: originImageHeight[currentIndex] + inset			
			tileText.states.animationOptions = 
				time: touchFeedbackTime
				curve: animationCurve
					
	layer.states.next("expand", "initial")
	tileImage.states.next("expand", "initial")
	tileText.states.next("expand", "initial")
	layer.bringToFront()
	
	# After animation, enable/disable scroll 
	layer.on Events.AnimationEnd, ->		if layer.states.current == "touched"
			scroll.scrollVertical = false

		else
			scroll.scrollVertical = true

	# There are not selected tiles
	for tile in tiles
		if tile != layer
			tile.states.animationOptions = 
				time: touchFeedbackTime, curve: "ease-out"
			tile.states.add
				hide: 
					opacity: 0
					scale: 0.95
				show: 
					opacity: 1
					scale: 1
			tile.states.next("hide", "show")
			
# Click, Scrolling events 	
for layer, tile in tiles
	layer.on(Events.Click, touchFeedback)

scroll.on Events.ScrollMove, ->
	layer.ignoreEvents = true for layer in tiles

scroll.on Events.ScrollAnimationDidEnd, -> 
	this.on Events.TouchEnd, ->
		layer.ignoreEvents = false for layer in tiles		
		