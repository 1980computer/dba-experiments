# Set background color
Screen.backgroundColor = "black"


# Create layers
layerA = new Layer
	width: 100
	height: 250
	x: Align.center(-130)
	y: Align.center
	backgroundColor: "#999"
	borderRadius: 4

layerB = new Layer
	width: 100
	height: 250
	x: Align.center(0)
	y: Align.center
	backgroundColor: "#888"
	borderRadius: 4
	
layerC = new Layer
	width: 100
	height: 250
	x: Align.center(130)
	y: Align.center
	backgroundColor: "#777"
	borderRadius: 4

# Add states
layerA.states.rotated =
	rotationX: 180

layerB.states.rotated =
	rotationY: 180
	
layerC.states.rotated =
	rotation: 180

# Animate states
layerA.animate "rotated",
	repeat: 4
	curve: Spring
	
layerB.animate "rotated",
	repeat: 4
	curve: Spring

layerC.animate "rotated",
	repeat: 4
	curve: Spring
	