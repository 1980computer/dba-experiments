# Network / trainer

# Using synaptic.js
# http://caza.la/synaptic/

# 3 inputs, 3 hidden layers, 3 outputs
network = new synaptic.Architect.Perceptron(3, 3, 3)

# Networks output i.e. "labels"
labels = 
	stay: [0, 0, 1]
	up: [0, 1, 0]
	down: [1, 0, 0]

### 

Inputs i.e. "features"
- Time until collision
- Player's lane
- Car's lane

Each is calculated within activateNetwork function.

–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

Scenarios
1) Stayed in bottom lane, should have moved up
2) Moved up, should have stayed in bottom lane
3) Stayed in top lane, should have moved down
4) Moved to bottom lane, should have stayed up

###

# Normalization functinos
normalizeInput = (value, from, to) ->
	return Utils.modulate(value, from, to, true)
	
normalizeOutput = (output) ->
	for value, i in output
		output[i] = Math.round(value)
		
	return output

# Network trainer
trainNetwork = (inputs, target, iterations, learningRate) ->
	for i in [0...iterations]
		network.activate(inputs)
		network.propagate(learningRate, target)
			
	return

# CLASS RoadStripes
Framer.Defaults.RoadStripes = 
	backgroundColor: ""
	height: 2
	numOfStripes: 40
	
class RoadStripes extends Layer
	constructor: (options = {}) ->
		for key, value of Framer.Defaults.RoadStripes
			options[key] = value
		super options
		
		# Add stripes
		@_addStripes()
	
	_addStripes: ->
		# Create new stripes
		for i in [0...@numOfStripes]
			stripe = new Layer
				width: (@width - ((@numOfStripes+1) * 10))/@numOfStripes
				height: @height
				backgroundColor: "yellow"
				parent: @
			
			# Increment x
			stripe.x = 10 + ((stripe.width + 10) * i)
	
	@define "numOfStripes",
		get: -> @_numOfStripes
		set: (value) -> @_numOfStripes = value
		
	@define "time",
		get: -> @_time
		set: (value) -> @_time = value
# CLASS Scenery
Framer.Defaults.Scenery = 
	backgroundColor: ""
	numOfStripes: 20
	
class Scenery extends Layer
	constructor: (options = {}) ->
		for key, value of Framer.Defaults.Scenery
			options[key] = value
		super options
		
		# Add stripes
		@_addStripes()
	
	_addStripes: ->
		# Create new stripes
		for i in [0...@numOfStripes]
			stripe = new Layer
				x: (@width/@numOfStripes) * i
				width: @width/@numOfStripes
				height: @height
				backgroundColor: if i % 2 is 0 then @colors[0] else @colors[1]
				parent: @
	
	@define "numOfStripes",
		get: -> @_numOfStripes
		set: (value) -> @_numOfStripes = value
		
	@define "colors",
		get: -> @_colors
		set: (value) -> @_colors = value
# CLASS Car
Framer.Defaults.Car = 
	width: 48
	borderRadius: 6
	clip: true

class Car extends Layer
	constructor: (options={}) ->
		for key, value of Framer.Defaults.Car
			options[key] ?= value
			
		super options
		
		# Add parts
		@_addParts()
		
	_addParts: ->
		# Headlights
		@leftHeadlight = new Layer
			midY: 0
			midX: @width
			size: width: 8, height: 8
			borderRadius: 8/2
			parent: @
			name: "leftHeadlight"
			backgroundColor: "yellow" 
		
		@rightHeadlight = new Layer
			midY: @height
			midX: @width
			size: width: 8, height: 8
			borderRadius: 8/2
			parent: @
			name: "rightHeadlight"
			backgroundColor: "yellow"
			
		# Taillights
		@leftTaillight = new Layer
			midY: 0
			midX: 0
			size: width: 8, height: 8
			borderRadius: 8/2
			parent: @
			name: "leftTaillight"
			backgroundColor: "red" 
		
		@rightTaillight = new Layer
			midY: @height
			midX: 0
			size: width: 8, height: 8
			borderRadius: 8/2
			parent: @
			name: "rightTaillight"
			backgroundColor: "red" 
		
		# Windows	
		@windshield = new Layer
			maxX: @width - 10
			midY: @height/2 
			height: @height - 4
			width: 8
			borderRadius: 2
			parent: @
			name: "windshield"
			backgroundColor: "#BDBDBD"
			
		@backWindow = new Layer
			x: 8
			midY: @height/2 
			height: @height - 4
			width: 6
			borderRadius: 1
			parent: @
			name: "windshield"
			backgroundColor: "#BDBDBD"

# FUNCTION newRandomCar
newRandomCar = (suspect, cop) ->
	randomCar = new Car
		x: Screen.width
		midY: Utils.randomChoice([road.topLane, road.bottomLane])
		height: 24
		backgroundColor: Utils.randomChoice(["#0D47A1", "#004D40", "#1B5E20", "#263238"])
		parent: road
		#rotation: 180
	
	# Add to cars and obstacles
	road.cars.push randomCar
	suspect.obstacles.push randomCar
	cop.obstacles.push randomCar
		
	# Animate
	randomCar.animate
		properties:
			maxX: 0
		curve: "linear"
		time: Utils.randomNumber(2, 3)
		
	randomCar.once Events.AnimationEnd, ->
		# Destroy car
		@destroy()
# FUNCTION detectCollision
detectCollision = (car, player) ->
	if player.x < car.x + car.width && 
	player.x + player.width > car.x &&
	player.y < car.y + car.height &&
	player.height + player.y > car.y
		return true
	else
		return false
# FUNCTION activateNetwork
activateNetwork = (player) ->
	# Use first obstacle for calcuations
	car = player.obstacles[0]
	
	# Get normalized inputs
	player.timeUntilCollision = normalizeInput(car.x, [road.width, player.maxX], [1, 0])
	player.lane = normalizeInput(player.midY, [road.topLane, road.bottomLane], [0, 1])
	car.lane = normalizeInput(car.midY, [road.topLane, road.bottomLane], [0, 1])
	
	# Activate network
	output = normalizeOutput(network.activate([player.timeUntilCollision, player.lane, car.lane]))
		
	# Set position of player
	position = switch
		when _.isEqual(output, labels.up) and player.isAnimating is false and player.midY isnt road.topLane
			player.animate
				properties:
					midY: road.topLane
				time: if player.timeUntilCollision < .25 then .25 else player.timeUntilCollision 
				curve: "linear"
		# Go down		
		when _.isEqual(output, labels.down) and player.isAnimating is false and player.midY isnt road.bottomLane
			player.animate
				properties:
					midY: road.bottomLane
				time: if player.timeUntilCollision < .25 then .25 else player.timeUntilCollision
				curve: "linear"
	
	# Remove car from obstacles if it's passed
	if car.maxX < player.x
		removeObstacle(car, player)	
				
	# Detect collision; end game if detected
	if detectCollision(car, player) is true
		end(car, player)

# Road
road = new Layer 
	height: 100
	width: Screen.width
	backgroundColor: "black"
road.center()

road.players = []
road.cars = []

removeObstacle = (oldObstacle, player) ->
	newObstacles = []
	
	for obstacle in player.obstacles when obstacle isnt oldObstacle
		newObstacles.push obstacle
		
	player.obstacles = newObstacles

# Create 2 road stripes
road.stripes = new RoadStripes
	midY: road.height/2
	width: road.width
	parent: road
	time: 10
	name: "roadStripes"
	
road.stripes2 = new RoadStripes
	x: Screen.width - 10
	midY: road.height/2
	width: road.width
	parent: road
	time: 20
	name: "roadStripes2"
	
endStripes = ->
	# Reset x
	@x = Screen.width
	
	# Start again
	startStripes(@, 20)
	
startStripes = (stripes, time) ->
	# Move to end of screen
	stripes.animate
		properties:
			maxX: 0
		curve: "linear"
		time: time
		
	stripes.on(Events.AnimationEnd, endStripes)
	
	
resetStripes = ->
	# Reset x and time
	@x = Screen.width - 10
	@time = 20
	
	# Start moving stripes again
	moveStripes(@)
	
moveStripes = (stripes) ->
	# Animate stripes to end of screen
	stripes.animate
		properties:
			maxX: 0
		curve: "linear"
		time: stripes.time
	
	# Reset stripes when animation ends	
	stripes.on(Events.AnimationEnd, resetStripes)
	
# Lanes (midY position)
road.topLane = (road.height/4) - road.stripes.height/2
road.bottomLane = road.height - (road.height/4) + road.stripes.height/2

# Start	
interval = null		
start = ->	
	# Create suspect and cop
	suspect = new Car
		midX: Screen.width/2
		midY: Utils.randomChoice([road.topLane, road.bottomLane])
		parent: road
		height: 24
		backgroundColor: "#B71C1C"
		name: "suspect"
	
	# Array for storing obstacles 	
	suspect.obstacles = []
		
	cop = new Car
		maxX: suspect.x - 48
		midY: Utils.randomChoice([road.topLane, road.bottomLane])
		parent: road
		height: 24
		backgroundColor: "#212121"
		name: "cop"
	
	cop.roof = new Layer
		midX: (cop.width/2) - 2
		width: 8
		height: cop.height
		parent: cop 
		name: "roof"
		backgroundColor: "white"
		
	cop.sirens = []
	for i in [0...4]
		siren = new Layer
			midX: (cop.width/2) - 2
			y: 4 + (4 * i)
			width: 4
			height: 4
			backgroundColor: if i < 2 then "blue" else "red"
			name: "siren#{i}"
			parent: cop
	
	# Array for storing obstacles 	
	cop.obstacles = []
		
	# Add suspect, cop to road.cars 
	road.cars.push suspect, cop
	
	# Create random car
	newRandomCar(suspect, cop)
	
	delay = 1
	interval = Utils.interval delay, ->
		newRandomCar(suspect, cop)
		
		delay = Utils.randomNumber(1, 2)
	
	moveStripes(road.stripes)
	moveStripes(road.stripes2)

	Framer.Loop.on "update", ->
		# Reference event handler
		@eventHandler = arguments.callee
		
		# Activate network for suspect and cop
		activateNetwork(suspect)
		activateNetwork(cop)

# End
end = (car, player) ->
	# Stop loop / interval
	Framer.Loop.off "update", @eventHandler
	clearInterval interval
	interval = null

	# Stop animation
	for layer in road.cars
		layer.animateStop()
		
	road.stripes.off(Events.AnimationEnd, resetStripes)
	road.stripes2.off(Events.AnimationEnd, resetStripes)
		
	whichTarget = switch
		#1) Stayed in bottom lane, should have moved up
		when player.lane is 1 and car.lane is 1
			target = labels.up
			
		#2) Moved up, should have stayed in bottom lane
		when player.lane > 0 and car.lane is 0
			target = labels.stay
			
		#3) Stayed in top lane, should have moved down
		when player.lane is 0 and car.lane is 0
			target = labels.down
			
		#4) Moved to bottom lane, should have stayed up
		when player.lane < 1 and car.lane is 1
			target = labels.stay
			
	# Train network
	trainNetwork([player.timeUntilCollision, player.lane, car.lane], target, 20000, .1)
	
	# Reset game
	Utils.delay .5, ->
		reset()

# Reset
reset = ->
	# Destroy all cars
	for car in road.cars
		car.destroy()
	
	# Reset stripes
	road.stripes.x = 0
	road.stripes2.x = Screen.width - 10
	road.stripes.time = 10
	road.stripes2.time = 20
	
	# Start again
	start()
	 	
start()
		 




