units = 8
gutter = 24
width  = 480 
height = 720
curve = "spring(220, 30, 0, 0.015)"
cells = []
fullscreen = false

Canvas.backgroundColor = "#00C2A3"
# Carousel Layer
carousel = new ScrollComponent
	width: Screen.width
	height: Screen.height
	backgroundColor: "white"
	scrollVertical: false
	
for index in [0...units]
	cell = new Layer
		superLayer: carousel.content
		width: width
		height: height 
		x: (width + gutter) * index
		backgroundColor: "hsla(#{index/units*360},60%,60%,1)"
		borderRadius: 8*2
	
	cells.push(cell)
	cell.centerY()
	
	cell.on Events.TouchEnd, ->
		
		if not carousel.isDragging and not fullscreen
			fullscreen = true
			carousel.scroll = false
			
			@bringToFront()
	
			@openAnimation = new Animation
				layer: @
				properties:
					width: Screen.width
					height: Screen.height
					x: @x - @screenFrame.x
					y: @y - @screenFrame.y
					borderRadius: 0 
				curve: curve
				
			@openAnimation.start()	
			@closeAnimation = @openAnimation.reverse()
	
			for cell in cells
				if @ isnt cell
					cell.animate
						properties: scale: 0.8, opacity: 0, borderRadius: 8*2
						curve: curve

		else if fullscreen
			fullscreen = false
			carousel.scroll = true
			carousel.scrollVertical = false
			
			@placeBehind()

			@closeAnimation.start()
				
			for cell in cells
				if @ isnt cell
					cell.animate
						properties: scale: 1, opacity: 1, borderRadius: 8*2
						curve: curve