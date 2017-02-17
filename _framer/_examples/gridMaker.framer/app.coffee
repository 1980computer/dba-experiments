# Project Info
# This info is presented in a widget when you share.
# http://framerjs.com/docs/#info.info

Framer.Info =
	title: "Dynamic Grids"
	author: "Steve Ruiz"
	twitter: "steveruizok"
	description: "A very, very commented, automatically sorting, scrolling grid of clickable, zoomable items."

# This prototype shows how to create grids that flow automatically, with correctly sized gutters, regardless of the number of columns, items, or the size of those items.

# Our first variable, itemsCount, stores the total number of items in the grid. 
itemsCount = 20

# Now we store the dimensions - height and width - that we'll use for our grid items.
itemSize = {height: 200, width: 200}

# If we want our grid items to have a frame, we can define its color and width here.
border = {color: '#000', width: 1}

# And we'll store a minimum value for our gutter, the space between grid items.
minGutter = 20

# Next, we determine and store the number of columns in our grid - that is, the number of items at the size we specified in iconSize that will (completely) fit in a horizontal row on our device's screen, while also accounting for our minimum gutter. We use Math.floor() to round down, because we're only interested how many items will fit completely.
columns = Math.floor(Screen.width / (itemSize.width + minGutter))

# To determine the gutter (or the space around the grid items), we take the space left over and divide it equally around the columns. If the icons fit perfectly onto the screen, or if the grid item size is equal to the screen width, the gutter will be zero; however, if we've set a minimum gutter using the variable minGutter described above, the gutter will never be less than this much.
gutter = (Screen.width - (itemSize.width * columns)) / (columns + 1)

# This is an empty array that we'll use to keep track of our grid items. This is just a list that we can refer to later. We can check whether a grid item is on the list, get where it is on that list, and do things to the grid item by referring to its place on the list. However, adding our grid items to itemList doesn't move or change the actual items in any way.
itemList = []

# This variable will act like an on/off switch for our grid items, allowing us to control whether grid items respond to click events. This is useful on a scrolling grid, so that click events aren't accidentally fired when we are scrolling through the list.
clickable = true

# Now we create the scroll component.
gallery = new ScrollComponent
	size: Screen.size
	scrollHorizontal: false

# When the scroll component is scrolling, we set the clickable variable to false.
gallery.on Events.ScrollStart, ->
	clickable = false

# When the scrolling ends, we set clickable back to true. This control also includes a short delay to prevent accidental double taps.
gallery.on Events.ScrollEnd, ->
	Utils.delay .5, ->
		clickable = true

# The function 'setGallery' is fired whenever we click on an item. It takes two arguments: the first is the item that was clicked, and the second is a boolean (true or false) that refers to whether we want the gallery to be scrollable (true) or not (false). Since we only want to freeze the scroll component when we zoom in on a picture, this also controls whether we're switching to a zoomed in state (false) or whether we're going back to normal (true).
setGallery = (clickedItem, bool) ->
	# If bool is false, the gallery will freeze where it is and won't be scrollable anymore.
	# If bool is true, the gallery will be scrollable again.
	gallery.scroll = bool
	# Whenever we set scroll to true, we also need to tell it (again) not to scroll
	# horizontally. It forgets.
	gallery.scrollHorizontal = false 
	
	# This loop first checks whether bool is true or false.
	if bool is false
		# If it's false, then the user has already clicked on a grid item, we've 
		# already frozen the gallery's scroll, and we're about to zoom in on the item.
		# But first, we also want to darken all the other items, so we go through all of
		# the layers we've stored in the array itemList, check whether or not the item is
		# the item we just clicked on to zoom in, and if it isn't, we animate it to be a
		# little darker.
		for item in itemList when item isnt clickedItem
			item.animate
				brightness: 60
				options:
					time: .3
	else if bool is true
		# If the boolean is true, then we're already in a zoomed-in state and we want to go
		# back to normal. So we've unfrozen the gallery's scroll and here we want to return
		# the grid items back to their normal bright state. We do the same thing as above,
		# checking each item in itemList to see if it's the item we clicked on (this time,
		# to zoom out) and, if it isn't we animate it back to full brightness.
		for item in itemList when item isnt clickedItem
			item.animate
				brightness: 100
				options:
					time: .3

# Now we're ready to define what exactly a grid item is. We're using a very simple class say that a gridItems is exactly like a Layer, except that its default options are different: it has the height and width we defined earlier with the object 'iconSize', it has a border the color and width we defined earlier with the object 'border', and (for demonstration purposes), has a white background and a random image.
class gridItem extends Layer
	constructor: (options) ->
		super _.defaults options,
			height: itemSize.height
			width: itemSize.width
			backgroundColor: 'white'
			image: Utils.randomImage()
			borderColor: border.color
			borderWidth: border.width
			style:
				color: 'white'
				fontSize: '36px'
				fontWeight: 'bold'
				'-webkit-text-stroke-width': '1px'
				'-webkit-text-stroke-color': 'black'

# Now it's time to actually create some grid items. To do this, we use an iterative loop, that will take a list and, for each thing on that list, perform the same actions. The argument 'i' will store our place in the list, beginning with zero and going up by one each time the loop repeats. 
 
# We start by telling our iterative loop to begin with zero and execute the instructions below, then repeat again and again until the times it has repeated is equal to the number we stored in the first variable we defined, 'itemsCount'. So, if itemsCount is 3, it'll do the code below three times. If it's 300, it'll repeat it 300 times.
[0...itemsCount].forEach (i) ->
	# Finally, we create our gridItem. We do this the same way we would create a layer, by
	# giving a thing a name and saying what that thing is. That name will only be temporary, 
	# however, because we're inside of a loop. Once the loop repeats, that same temporary
	# name 'item' will be used for the next grid item instead. So although we can use 'item'
	# to refer to the grid item at this step in the loop, anything we say about 'item' will
	# also apply to every other item we create.
	#
	# So, at this (and every) step in our loop, let's make a gridItem and call it 'item'.
	item = new gridItem
	# Now we store some information about the 'item'. Here we make use of the iterative 
	# variable 'i'. Since 'i' will start at 0 and go up by 1 each time the loop
	# repeats, we can set different information for each item we make based on what the
	# value of 'i' is at this step in the loop, or "iteration". If x = i * 2, then on the
	# first iteration, when 'i' is is 0, x will be 0 (x = 0 * 2). But on the second
	# iteration, x will be 2 (x = 1 * 2), and on the next x will be 4 (x = 2 * 2).
	#
	# First, we set the item's column position. The modulus (%) is an operator that says,
	# divide the first number by the second number and return the remainder. 4 % 2 would be 
	# zero, because 2 goes into 4 without a remainder; however, 5 % 2 would be 1, because
	# the closest 2 can get to 5 is 4, and that leaves a remainder of 1. So 15 % 6 would be
	# 3, and 4 % 20 would be 0. If the first value is less than the second, the result will
	# always be equal to the first value, so 2 % 5 will be 2, 4 % 5 will be 4, and so on.
	
	# We calculate our column position by our iterative 'i' % the total number of columns,
	# which we determined at the beginning by seeing how many grid items would fit 
	# horizontally on the screen. If we have 3 columns, then (since we began counting from 
	# 0), the first three (0, 1, and 2) will be equal to i, as i will still be less than 3. 
	# However, once we get to our fourth iteration, when i is 3, the count will restart 
	# (3 % 3 = 0, 4 % 3 = 1, 5 % 3 = 2, then 6 % 3 = 0, 7 % 3 = 1, etc).
	item.col = i % columns
	# If you're confused and want to see the relationship between the i value and the col
	# value, uncomment this next line:
# 	item.html = 'i: ' + i.toString() + ', col: ' + item.col.toString()
	
	# Row is an easier solution: we just divide 'i' by the number of columns and floor (or
	# round down) the result. The row will go up by 1 for each multiple of however many 
	# columns we have.
	item.row = Math.floor(i / columns)
	
	# So far, while we've figured out this item's column and row based on it's 'i' value, we
	# have only stored those values. Now, as we're setting our item's properties, we'll
	# actually use them to position our item.
	item.props =
		
		# First, let's give the item a permanent name
		name: 'item' + i
		
		# And let's put it in our scroll component 'gallery'. We do this by defining its
		# parent as the scroll component's content layer.
		parent: gallery.content
		
		# Now we use the item's column value that we determined above, along with the
		# value of our gutter and the item's width to set the item's x coordinate.
		x: gutter + (item.col * (gutter + itemSize.width))
	
		# And we use the item's row, together with the gutter and item's height, to set
		# the item's y position.
		y: gutter + (item.row * (gutter + itemSize.height))
	
	# For later, we also set a variable called 'zoomed' that we'll set either true or false
	# depending on whether the grid item has been clicked and zoomed in on. 
	item.zoomed = false
	
	# And let's include the item on the list, 'itemList'.
	itemList.push(item)

	# Now we're getting to the interactive stuff. Remember that we're still in our loop, so
	# all the events we define here will apply individually to each item we create using
	# that loop.
	
	# So for this item (and every item created through this loop), we'll set a subtle
	# animation to brighten a grid item whenever we hover our cursor over it.
	item.on Events.MouseOver, ->
		item.animate
			saturate: 120
			brightness: 120
			options:
				time: .25
	# And we create a second animation to set it back to normal whenever we're no longer
	# hovering over it.
	item.on Events.MouseOut, ->
		item.animate
			saturate: 100
			brightness: 100
			options:
				time: .25
	
	# When we click on a grid item, we want it to zoom forward and take up the whole screen.
	# That process involves a few steps, which we'll define here, under the click event. 
	item.on Events.Click, ->
		# Remember 'clickable'? Here we check to see whether it's true or false. If 
		# clickable is true, and if item.zoomed is false, we know that the gallery isn't
		# scrolling and that the item hasn't already been zoomed in on; and together, this
		# means that we must have wanted to zoom in on the item we just clicked on. 
		#
		# Note that because we're in an event function, we can use the @ symbol (or the word
		# 'this') to refer to the layer on which the event occurred. We could also still use
		# the layer's temporary name 'item' if we wanted to.
		if clickable is true && @.zoomed is false
		
			# Right away, let's set @zoomed to true. We do this to get ready for the next
			# click event, to zoom out, which will also refer to @.zoomed.
			@zoomed = true
			
			# First we run the function setGallery, passing it the layer we clicked on, and
			# the bool 'false', to stop the gallery's scroll and darken everything but the 
			# layer we clicked on. 
			setGallery(@, false)
			
			# Now we take the layer we clicked on and bring it to the front, so that it 
			# won't be overlapped by any other layer as it zooms in - that would ruin the
			# illusion of our grid item's photo coming forward in space.
			@bringToFront()
			
			# Before we do any animating, we want to store the item's normal coordinates 
			# so we can get back to them later. We'll store them in the variable 'oldFrame'.
			# A layer's frame stores values for x, y, height, and width in an object, source
			# these values will be accessible via @frame.x, @frame.y, etc.
			@oldFrame = @frame
			
			# Let's zoom this item in!
			@animate
		
				# The item's frame will animate to match the screen's frame.
				frame: Screen.frame
		
				# The item's new y will be at scroll component's scrollPoint, which is
				# the current top of the scroll container, depending on however far we've 
				# scrolled. Since our scroll container is the size of our screen, it'll 
				# appear to be at the top of our screen - but really, if we hadn't frozen
				# our scroll with setGallery(), we would see that it's just at that point
				# in the scroll.
				y: gallery.scrollPoint.y
		
				# And we'll define the time and curve for this animation.
				options:
					time: .5
					curve: "spring(320,40,0)"
		
		# If zoomed is true, we know we're either zoomed in or in the process of zooming
		# in, and either way the click event expressed the intention to zoom back out to the
		# regular grid.
		else if @zoomed is true
			
			# So we'll switch item.zoomed back to false.
			@zoomed = false
			
			# And we'll reset the gallery to scrollable and brighten up all the layers that
			# we'd darkened before.
			setGallery(this, true)
			
			# Then we'll animate back to how things used to look.
			@animate
				frame: @oldFrame
				options:
					time: .5
					curve: "spring(320,40,0)"
		
		# And finally, while we're still in the 'on.Events Click' event, and still in our
		# item creating loop, we'll instruct the computer to do absolutely nothing if the
		# item is clicked while the above condition's aren't true - that is, if clickable 
		# is false, which it only would be if the scroll component is in motion.
		else
			return null
			
# That ends the instructions for the loop, so it'll return to the start and repeat, with an 'i' value one more than last time, until it's created all of our items, and assigned each of them those unique values and click events.

# And that's all there is to it.
