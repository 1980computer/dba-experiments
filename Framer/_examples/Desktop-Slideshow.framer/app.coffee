
# generate some scroll components

scrolls = []

for i in [0...5]
	layer = new Layer
		width: Screen.width
		height: Utils.randomNumber(Screen.height,Screen.height+1000)
		backgroundColor: Utils.randomColor()
		
	scroll = scrolls[i] = ScrollComponent.wrap(layer)
	
	scroll.directionLock = true
	scroll.mouseWheelEnabled = true
	scroll.scrollHorizontal = false	

firstSlide = scrolls[0]
lastSlide = scrolls[scrolls.length-1]

# set up page component and put all scroll components in it

slides = new PageComponent
	width: 1440
	height: 900
	originY: 0
	directionLock: true
	scrollVertical: false
	animationOptions: 
		curve: "ease"
		time: 0.7

for i in [0...scrolls.length]
	scrolls[i].x = i * 1500
	scrolls[i].y = 0
	scrolls[i].parent = slides.content

slides.snapToPage(firstSlide)

# slide navigation 

slides.onClick (event) ->
	unless @isMoving
		screenPoint = Utils.convertPointFromContext({x:event.pageX, y:event.pageY}, @, true, true)
		if screenPoint.x < 200
			if slides.horizontalPageIndex(slides.currentPage) == 0
				slides.snapToPage(lastSlide)
			else
				slides.snapToNextPage("left")
		else if screenPoint.x > Screen.width - 200
			if slides.horizontalPageIndex(slides.currentPage) == scrolls.length-1
				slides.snapToPage(firstSlide)
			else
				slides.snapToNextPage()	


# enable arrow keys for next and prev
Events.wrap(window).addEventListener "keydown", (event) ->
	if event.keyCode is 37 	# left arrow 
		if slides.currentPage == firstSlide
			slides.snapToPage(lastSlide)
		else
			slides.snapToNextPage("left")
	else if event.keyCode is 39 # right arrow
		if slides.currentPage == lastSlide
			slides.snapToPage(firstSlide)
		else
			slides.snapToNextPage("right")

