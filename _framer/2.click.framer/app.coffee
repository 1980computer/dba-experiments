# Set background color
Screen.backgroundColor = "black"

layerA = new Layer
	width: 100
	height: 300
# 	x: Align.center(-130)
# 	y: Align.center
	backgroundColor: "#fff"
	borderRadius: 4

layerA.onClick ->	
	layerA.animate
		properties:
			x: 100
			y: 0
		curve: "spring(280,30,0)"
		
