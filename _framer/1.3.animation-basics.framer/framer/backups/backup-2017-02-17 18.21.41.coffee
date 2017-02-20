# States provie a simple way to organize animation code.
 
layerB = new Layer 
	width: 200, height: 350, backgroundColor:"#1A61B5", y:30, x: 30, borderRadius: "8px"
	
layerA = new Layer 
  width: 120, height: 350, backgroundColor:"#4A90E2", y:30, x: 30, borderRadius: "8px"


layerB.states.add
  stateA: {y:200, rotation:180}
  stateB: {y:300, x:40, rotation:60}

layerA.on Events.Click, ->
  layerB.states.next("stateB", "stateA")
  
 
layerB.states.animationOptions =
  curve: "spring"
  curveOptions: {tension:200, friction:3}
  