
TopNavExpanded = new Layer
	width: 401
	height: 45
	image: "images/TopNavExpanded.png"
	x: Align.center
	y: Align.center

TopNavCollapsedB = new Layer
	width: 401
	height: 45
	image: "images/TopNavCollapsed.png"
	x: Align.center
	y: Align.center
	
# Rotate on click
TopNavCollapsedB.onClick ->
	TopNavExpanded.animate
		rotation: TopNavExpanded.rotation + 90
		options:
			curve: Spring(damping: 0.5)
