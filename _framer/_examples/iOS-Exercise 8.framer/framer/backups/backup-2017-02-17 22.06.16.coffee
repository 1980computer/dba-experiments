# Project Info
# This info is presented in a widget when you share.
# http://framerjs.com/docs/#info.info

Framer.Info =
	title: ""
	author: "Nuno Coelho Santos"
	twitter: "nunosans"
	description: ""


# Import file "Exercise 8" (sizes and positions are scaled 1:2)
Imports = Framer.Importer.load("imported/Exercise 8@2x")

Imports.ActionView.x = 0
Imports.ActionView.y = 0
Imports.ActionView.visible = false
Imports.ActionView.backgroundColor = null

Imports.ActionViewBackground.opacity = 0
Imports.CloseButton.rotation = 135

buttons = [Imports.ComposeButton, Imports.FlaggedButton, Imports.AttachmentsButton, Imports.SentButton, Imports.ArchivedButton]

for button in buttons
	button.initialY = button.y

labels = [Imports.ComposeLabel, Imports.FlaggedLabel, Imports.AttachmentsLabel, Imports.SentLabel, Imports.ArchivedLabel]

for label in labels
	label.initialX = label.x

Imports.ActionButton.on Events.Click, ->
	Imports.ActionView.visible = true
	Imports.ActionViewBackground.animate
		properties:
			opacity: 1
		curve: "ease-in-out"
		time: 0.36
	Imports.CloseButton.animate
		properties:
			opacity: 1
			rotation: 0
		curve: "ease-in-out"
		time: 0.24
	for button, index in buttons
		button.opacity = 0
		button.rotation = 360
		button.y = Imports.ActionButton.y
		button.animate
			properties:
				rotation: 0
				opacity: 1
				y: button.initialY
			curve: "spring(200, 20, 0)"
			time: 0.48
			delay: 0.06 * (5 - index)
	for label, index in labels
		label.opacity = 0
		label.x = label.initialX + 64
		label.animate
			properties:
				x: label.initialX
				opacity: 1
			curve: "ease-in-out"
			time: 0.24
			delay: 0.12 + (0.06 * (5 - index))

Imports.CloseButton.on Events.Click, ->
	Imports.ActionViewBackground.animate
		properties:
			opacity: 0
		curve: "ease-in-out"
		time: 0.36
	Imports.CloseButton.animate
		properties:
			opacity: 0
			rotation: 135
		curve: "ease-in-out"
		time: 0.24
	for button, index in buttons
		button.animate
			properties:
				rotation: 360
				opacity: 0
				y: Imports.ActionButton.y
			curve: "spring(200, 20, 0)"
			time: 0.48
			delay: 0
	for label, index in labels
		label.animate
			properties:
				opacity: 0
			curve: "ease-in-out"
			time: 0.12
			delay: 0
	Utils.delay 0.48, ->
		Imports.ActionView.visible = false