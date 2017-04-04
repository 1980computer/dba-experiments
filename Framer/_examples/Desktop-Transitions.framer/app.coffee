
iconLayer = new Layer width: 256, height: 256, image: "images/image.jpg"

iconLayer.center()

iconLayer.states.add
	second: {y:100, scale:0.6, rotationZ:100}
	third: {y:300, scale:1.3, blur:4}
# 	fourth: {y:200, scale:0.9, blur:2, rotationZ:200}
	
iconLayer.states.animationOptions =
	curve: "spring(500,12,0)"

iconLayer.on Events.Click, ->
	iconLayer.states.next()