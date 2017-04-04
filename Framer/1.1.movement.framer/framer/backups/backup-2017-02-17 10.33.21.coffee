# States provie a simple way to organize animation code.
# You can define a set of states, which are a collection of properties with values, by name
layerA = new Layer 
  width:50, height: 350, backgroundColor:"#86B8F3", y:30, x: 30, borderRadius: "8px"

# Define states
# There is always a 'default' state that contains the initial properties
layerA.states.add
  stateA: {rotation:180}
  stateB: {rotation:60}
  
# Switch to State A on click
layerA.on Events.Click, ->
  layerA.states.switch "stateA"

# Normally you'd want to toggle or cycle through states. 
# That is where the .next() function comes in
layerB = new Layer 
  width: 100, height: 350, backgroundColor:"#4A90E2", y:30, x: 100, borderRadius: "8px"

layerB.states.add
  stateA: {rotation:180}
  stateB: {rotation:60}
  stateC: {rotation:0, hueRotate: 60}

# There are 4 states in total (The defined states + the default state)
layerB.on Events.Click, ->
  layerB.states.next()
  
# The .next() function also takes a list of state names.
layerC = new Layer 
	width: 200, height: 350, backgroundColor:"#1A61B5", y:30, x: 220, borderRadius: "8px"

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
  