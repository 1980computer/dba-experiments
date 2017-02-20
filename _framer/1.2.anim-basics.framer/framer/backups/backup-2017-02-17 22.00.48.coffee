# Project Info
# This info is presented in a widget when you share.
# http://framerjs.com/docs/#info.info

Framer.Info =
	title: "Click Slide"
	author: "David B Anthony"
	twitter: "@davidbanthony"
	description: "Click to Slide."

# Layer Blue Dark
layerB = new Layer 
	width: 120, height: 350, backgroundColor:"#1A61B5", y:30, x: 30, borderRadius: "8px"
	
# Layer Blue Light	
layerA = new Layer 
  width: 120, height: 350, backgroundColor:"#4A90E2", y:30, x: 30, borderRadius: "8px"

# Step 1 - On Click, states.
layerA.on Events.Click,->
  layerB.states.next("stateB", "stateA")
# Step 2 - States to add.
layerB.states.add
  stateB: {x:160}
  stateA: {x:30}
# Step 3 - Animation.
layerB.states.animationOptions =
  curve: "spring"
  curveOptions: {tension:300, friction:30}