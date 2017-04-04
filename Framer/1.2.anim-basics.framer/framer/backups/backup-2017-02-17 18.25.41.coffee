
# Layer Blue Dark
layerB = new Layer 
	width: 200, height: 350, backgroundColor:"#1A61B5", y:30, x: 30, borderRadius: "8px"
	
# Layer Blue Light	
layerA = new Layer 
  width: 120, height: 350, backgroundColor:"#4A90E2", y:30, x: 30, borderRadius: "8px"



  
# Step 1 - On Click, states.
layerA.on Events.Click, ->
  layerB.states.next("stateB", "stateA")

# Step 2 - States to 
layerB.states.add
  stateA: {x:200}
  stateB: {x:500}
    
layerB.states.animationOptions =
  curve: "spring"
  curveOptions: {tension:200, friction:3}
