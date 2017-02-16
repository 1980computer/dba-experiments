# Made with Framer
# by Benjamin den Boer
# @framerjs, @benjaminnathan

# Import file "photo-view"
sketch = Framer.Importer.load("imported/photo-view@1x")

# Set Up

# Store x, y, width and height
zoomedFrame = sketch.photoA.frame

# Set up grid
gutter = 16
size = 350

# Style navBar
sketch.navBar.style = "-webkit-backdrop-filter": "blur(32px)"

# Array for photo frames
photoFrames = []

for row in [0...4]
	for col in [0...2]
		
		photoFrame = new Layer
			width:  size
			height: size
			x: col * (size + gutter)
			y: row * (size + gutter)
			backgroundColor: null
			name: "frame #{row}, #{col}"
			
		photoFrames.push(photoFrame)
			
# Set photo frames to make grid
for photo, index in sketch.photos.children
	photo.frame = photoFrames[index].frame

# Set up scrollable area
scroll = ScrollComponent.wrap(sketch.photos)

scroll.props =
	y: 0
	contentInset: top: 132, bottom: 12
	height: Screen.height - 104
	scrollHorizontal: false

# Photo functions
scalePhoto = (currentPhoto, scrollPosition, frame, opacity) ->
	currentPhoto.animate 
			properties:
				x: frame.x
				y: frame.y + scrollPosition
				width: frame.width 
				height: frame.height
				scale: 1, rotation: 0, opacity: 1
			curve: "spring(500, 40, 0)"
			
	for photo in sketch.photos.children
		unless photo is currentPhoto
			photo.animate 
				properties:
					opacity: opacity
				time: 0.4
				
# Photo interactions
for photo, index in sketch.photos.children
	
	defaultFrame = 0
	
	# Enable pinching	
	photo.pinchable.enabled = true 
	
	# Store defaultFrame
	photo.on Events.TouchStart, ->
		defaultFrame = @frame unless @width > 350
	
	# On click
	photo.onClick ->
		@bringToFront()
				
		if @width is zoomedFrame.width	
			scalePhoto(this, 0, defaultFrame, 1)
		else 
			scalePhoto(this, scroll.scrollY, zoomedFrame, 0)
	
	# On pinch		
	photo.on Events.Pinch, (event) ->
		
		# Store pinch direction 
		direction = event.scaleDirection
		
		@style.boxShadow = "0 6px 12px rgba(0,0,0,0.2), 0 32px 64px rgba(0,0,0,0.5)"
		@bringToFront()
		
		# Modulate opacity
		for photo in sketch.photos.children
			if @width is 350
				photo.opacity = Utils.modulate(event.scale, [1, 2.5], [1, 0], true)
			else 
				photo.opacity = Utils.modulate(event.scale, [1, 0.25], [0, 1], true)
				
		@opacity = 1
	
	# On PinchEnd
	photo.on Events.PinchEnd, (event) ->
		
		# Store pinch direction 
		direction = event.scaleDirection

		# Animate to current position
		if direction is "up"
			scalePhoto(this, scroll.scrollY, zoomedFrame, 0)
		
		# Animate to original position
		else
			scalePhoto(this, 0, defaultFrame, 1)
			@style.boxShadow = "none"