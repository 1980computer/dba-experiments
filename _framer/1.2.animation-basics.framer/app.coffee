# States provie a simple way to organize animation code.
 
layerC = new Layer 
	width: 200, height: 350, backgroundColor:"#1A61B5", y:30, x: 30, borderRadius: "8px"
	
layerB = new Layer 
  width: 130, height: 350, backgroundColor:"#4A90E2", y:30, x: 30, borderRadius: "8px"
	
layerA = new Layer 
  width:60, height: 350, backgroundColor:"#86B8F3", y:30, x: 30, borderRadius: "8px"
	
# The .next() function also takes a list of state names.

layerC.states.add
  stateA: {y:200, rotation:180}
  stateB: {y:300, x:40, rotation:60}
  stateC: {y:400, x:40, rotation:0}

layerC.on Events.Click, ->
  # Cycle through states C and B
  layerC.states.next("stateC", "stateB")
  
# Control state animations with the .animationOptions keyword
layerC.states.animationOptions =
  curve: "spring"
  curveOptions: {tension:200, friction:3}
  