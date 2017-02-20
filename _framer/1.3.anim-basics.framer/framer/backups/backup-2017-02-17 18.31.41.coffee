
# Layer Blue Dark
layerB = new Layer 
	width: 120, height: 350, backgroundColor:"#1A61B5", y:30, x: 30, borderRadius: "8px"
	
# Layer Blue Light	
layerA = new Layer 
  width: 120, height: 350, backgroundColor:"#4A90E2", y:30, x: 30, borderRadius: "8px"

# Step 2 - States to add.
layerB.states.add
  stateB: {x:200}
  stateA: {x:120}
  
# Step 1 - On Click, states.
layerA.on Events.Click, ->
  layerB.states.next("stateB", "stateA")

# Step 3 - Animation.
layerB.states.animationOptions =
  curve: "spring"
  curveOptions: {tension:300, friction:20}