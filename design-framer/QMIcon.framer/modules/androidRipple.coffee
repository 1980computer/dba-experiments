# Module created by Aaron James | April 16th, 2016
#
# Pointer Module by Jordan Dobson is required for this module
# Install this module first here: http://bit.ly/1lgmNpT
#
# Add the following line at the top of your project to access this module:
# android = require "androidRipple"
#
# To add ripple to layer, use this line of code:
# layerName.on(Events.Click, android.ripple)
# Replace layerName with the name of your layer
#
# Available options:
# You can use any Event with this module

{Pointer} = require "Pointer"

# create ripple function
exports.Ripple = (event, layer) ->
	eventCoords = Pointer.offset(event, layer)

	# Change color of ripple
	color = "black"

	# Create layers on Click
	pressFeedback = new Layer
		superLayer: @
		name: "pressFeedback"
		width: layer.width
		height: layer.height
		opacity: 0
		backgroundColor: color
	pressFeedback.states.pressed =
		opacity: .06
		animationOptions: 
			curve: "ease-out"
			time: .3
	pressFeedback.states.notPressed =
		opacity: 0
		animationOptions: 
			curve: "ease-out"
			time: .3
	pressFeedback.animate("pressed")

	rippleCircle = new Layer
		superLayer: @
		name: "rippleCircle"
		borderRadius: "50%"
		midX: eventCoords.x
		midY: eventCoords.y
		opacity: .08
		backgroundColor: color
		size: layer.width / 4
	rippleCircle.states.pressed =
		scale: layer.width / 60
		opacity: 0
		animationOptions: 
			curve: "ease-out"
			time: .8
	rippleCircle.animate("pressed")

	# Destroy layers after Click
	layer.on Events.TapEnd, ->
		pressFeedback.animate("notPressed")
		Utils.delay 1, ->
			rippleCircle.destroy()
			pressFeedback.destroy()
