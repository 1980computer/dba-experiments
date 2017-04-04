# Import file "test" (sizes and positions are scaled 1:3)
$ = Framer.Importer.load("imported/test@3x")

# Starting Defaults
$.right.x = Align.right(+$.right.width)
$.left.x = Align.left(-$.left.width)





#Animate the left screen in
$.leftButton.on Events.Click, ->
	$.left.animate
		properties:
			x: 0
		time: .5
#animate the left screen back to its default
$.leftBack.on Events.Click, ->
	$.left.animate
		properties:
			x: Align.left(-$.left.width)
		time: .5


#Animate the right screen in
$.rightButton.on Events.Click, ->
	$.right.animate
		properties:
			x: 0
		time: .5
#animate the right screen back to its default
$.rightBack.on Events.Click, ->
	$.right.animate
		properties:
			x: Align.right(+$.right.width)
		time: .5