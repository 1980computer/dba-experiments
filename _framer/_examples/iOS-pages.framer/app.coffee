# Set Screen background
sketch = Framer.Importer.load("imported/FramerHomeProto6@2x")
Utils.globalLayers(sketch)
Framer.Extras.Preloader.enable()
Framer.Extras.Preloader.setLogo("https://s15.postimg.org/re72xi4d7/image.png")

# Set Device background
Canvas.backgroundColor = "#EDFAFF"

Framer.Info =
    author: "Noah Levin"
    twitter: "@nlevin"
    title: "ClassPass 2.0"
    description: "This prototype guided design direction, testing, and development for the latest ClassPass app redesign. Read more: https://goo.gl/Dzqa6D"

Footer.x = 0
Footer.y = Align.bottom

for layerGroupName of sketch
	sketch[layerGroupName].originalFrame = window[layerGroupName].frame
	if sketch[layerGroupName].name.indexOf("Target") != -1
		sketch[layerGroupName].opacity = 0

Framer.Defaults.Animation = 
	curve: "cubic-bezier(0.4, 0.0, 0.2, 1)"
	time: 0.3

Layer::animateTo = (properties, delay) ->
	thisLayer = this
	thisLayer.animationTo = new Animation
		layer: thisLayer
		properties: properties
		delay: delay
	thisLayer.animationTo.start()

# HEADER ANIMATIONS
# HEADER ANIMATIONS
for el in [Photo3, Photo2, Photo1]
	el.states.add
		Off:
			opacity: 0
		On:
			opacity: 1
	el.states.animationOptions =
		curve: 'ease-in-out'
		time: 3

PhotoCred.visible = false
# PhotoCred.invert = 100
PhotoCred.opacity = 0
# PhotoCred.y = 500

Photo.grayscale = 100
	
curPhoto = 3
Utils.interval (4.5), ->
	if curPhoto == 3
		Photo3.states.switch("Off")
		curPhoto = 2
		return
	if curPhoto == 2
		Photo2.states.switch("Off")
		curPhoto = 1
		return
	if curPhoto == 1
		Photo3.states.switch("On")
		curPhoto = 3
		return

PARTY_OPACITY = 0.7
COLORMASK_OPACITY = 0.8
Party.visible = false

HeaderTitleText.onClick ->
	Party.visible = true
	for rowIndex in [1..8]
		sketch["Party#{rowIndex}"].x = 300
		sketch["Party#{rowIndex}"].y = 200
		sketch["Party#{rowIndex}"].scale = 0.01
		sketch["Party#{rowIndex}"].opacity = 0
		sketch["Party#{rowIndex}"].rotation = Utils.randomNumber(0,120)
		sketch["Party#{rowIndex}"].animate
			properties: 
				x: sketch["Party#{rowIndex}"].originalFrame.x
				y: sketch["Party#{rowIndex}"].originalFrame.y
				scale: 1
				opacity: PARTY_OPACITY
				rotation: 0
			curve: 'spring(50,20)'
	Party.animateTo({ opacity: 0 }, 3)
	Utils.delay (4), ->
		Party.visible = false
		Party.opacity = 1

# SET UP STUFF

# INITIAL SET UP
TabIcons.y += 12
isMoving = false
curPage = "Home"
isPlaylistShown = false
isSettingsShown = false

Profilev2Tab.visible = false

springy = "spring(100,10)"
Photo.originY = 0
ColorMask.opacity = 0.8

HomeShadeLayer = new Layer
	width: 750
	height: 1336
	backgroundColor: "rgba(0,0,0,0.5)"
	parent: Home
	opacity: 0

ProfileShadeLayer = new Layer
	width: 750
	height: 1336
	backgroundColor: "rgba(0,0,0,0.5)"
	parent: Profile
	opacity: 0

BaseLayer = new Layer
	opacity: 1
	backgroundColor: "transparent"
	origin: 0
	width: Framer.Screen.width
	height: Framer.Screen.height
	clip: true

TopLayer = new Layer
	opacity: 1.00
	backgroundColor: "transparent"
	width: 750
	height: 48
StatusBar.parent = TopLayer

Fav.parent = BaseLayer
Search.parent = BaseLayer
Home.parent = BaseLayer
Footer.parent = BaseLayer
Settings.parent = BaseLayer
Playlist.parent = BaseLayer
Profile.parent = BaseLayer
Up.parent = BaseLayer
Home.parent = BaseLayer
Footer.placeBefore(Up)
TopLayer.placeBefore(Footer)
ClassDetails.placeBefore(BaseLayer)
Flex.placeBefore(TopLayer)

HomeTab.pageName = "Home"
SearchTab.pageName = "Search"
FavTab.pageName = "Fav"
ProfileTab.pageName = "Profile"
UpTab.pageName = "Up"

texts = [HomeText, SearchText, FavText, UpText, ProfileText]

for el in [HomeOnFilled, FavOnFilled, ProfileOnFilled]
	el.opacity = 0

for el in texts
	el.opacity = 0
	
for el in [Fav, Up, Search, Profile]
	el.x = 0

for el in [SearchOn, UpOn, ProfileOn, FavOn, HomeTextOff, SearchTextOn, SearchTextOn, FavTextOn, UpTextOn, ProfileTextOn]
	el.opacity = 0

headerCycler = Utils.cycle(Photo1,Photo2,Photo3)

shortPress = true
timer = null
curFooter = 0
isFilled = false
isCardTouched = false
tempCard = 0

for el in [ComingSoonCard, NewForYouCard, BookAgainCard, ExploreCard, ExploreMoreCard, ActivityCard]
	el.shadowY = 10
	el.shadowBlur = 12
	el.shadowColor = "rgba(163,167,178,.10)"
	el.onTouchStart ->
		isCardTouched = true
		tempCard = @
		@animate
			properties:
				shadowY: 2
				shadowBlur: 4
			time: 0.1
		Utils.delay (0.2), ->
			if isCardTouched 
				tempCard.animateTo({ shadowY: 10, shadowBlur: 12 })
				isCardTouched = false
	el.onTouchEnd ->
		@animateTo({ shadowY: 10, shadowBlur: 12 })
		
turnOnText = ->	
	for el in texts
		el.animateTo({ opacity: 1 })
	TabIcons.animateTo({ y: TabIcons.y - 10 })

turnOffText = ->	
	for el in texts
		el.animateTo({ opacity: 0 })
	TabIcons.animateTo({ y: TabIcons.y + 10 })

for el in [HomeTab, SearchTab, UpTab, FavTab, ProfileTab]
	el.onTap ->
		switchPage(@pageName)
# SCROLLCOMPONENTS
CardsScroll = ScrollComponent.wrap(Cards)
CardsScroll.scrollHorizontal = false
CardsScroll.directionLock = true
CardsScroll.contentInset =
	top: 420
	bottom: -350
CardsScroll.height = 1236
CardsScroll.y -= 430

PlaylistScroll = new ScrollComponent
	parent: PlaylistScrolling
	height: 998
	width: 750
PlaylistContent.parent = PlaylistScroll.content
PlaylistContent.y += 15
PlaylistScroll.scrollHorizontal = false

UpcompingScroller = new ScrollComponent
	parent: UpcomingScroll
	height: 1096
	width: 798
UpcomingContent.parent = UpcompingScroller.content
UpcompingScroller.scrollHorizontal = false

ClassScroll = new ScrollComponent
	parent: ClassDescriptionScroll
	height: 1093
	width: 788
ClassScroll.scrollHorizontal = false
ClassDescriptionContent.parent = ClassScroll.content

SettingsScroller = new ScrollComponent
	parent: SettingsScroll
	height: 1093
	width: 750
SettingsScroller.scrollHorizontal = false
SettingsContent.parent = SettingsScroller.content

# SearchResults.draggable.enabled = true
# SearchResults.draggable.horizontal = false

ProfileScoller = new ScrollComponent
	parent: ProfileScroll
	width: 784
	height: 1339
ProfileCycleContent.parent = ProfileScoller.content
ProfileScoller.scrollHorizontal = false
ProfileScroll.y = 200
ProfileScoller.height = 1200
ProfileScoller.contentInset =
	top: 410
	bottom: 90

FavScroll.y -= 142
FavScroller = new ScrollComponent
	parent: FavScroll
	height: 1093
	width: 750
FavScroller.contentInset =
	top: 140
FavScroller.scrollHorizontal = false
FavContent.parent = FavScroller.content

FavMe.opacity = 0
BookAgainClassTarget.visible = false
# BookAgainCardMeat.clip = true
# BookAgainTimeMasks.parent = BookAgainCardMeat
BookAgainCard.width = 710
BookAgainCard.height = 1158
BookAgainCard.clip = true
BookAgainCard.x += 10
BookAgainCardContent.x -= 10
BookScrolling1 = ScrollComponent.wrap(BookAgainTimeScroll1)
BookScrolling2 = ScrollComponent.wrap(BookAgainTimeScroll2)
BookScrolling3 = ScrollComponent.wrap(BookAgainTimeScroll3)

for el in [BookScrolling1, BookScrolling2, BookScrolling3]
	el.parent = BookAgainTimeMasks
	el.scrollVertical = false
	el.clip = false
	el.contentInset =
		right: 60
	el.onTap ->
		showClass()


# CARD SCROLLING BEHAVIOR
MapThing.scale = 1.01
# CARD SCROLLING BEHAVIOR
CardsScroll.onMove ->
	isMoving = true
	isHeld = false
	if CardsScroll.scrollY < 0
		if CardsScroll.scrollY < -30
			StatusBar.opacity = 0
		else
			StatusBar.opacity = 1
		CardsScroll.speedY = 0.3
		PhotoCred.opacity = Utils.modulate(CardsScroll.scrollY, [0, -150], [0,0.75], true)
		PhotoCred.y = Utils.modulate(CardsScroll.scrollY, [0, -Photo.height], [PhotoCred.originalFrame.y - 10,PhotoCred.originalFrame.y + 390], true)
		Photo.scale = Utils.modulate(CardsScroll.scrollY, [0, -Photo.height],[1,1.6], true)
		Photo.grayscale = Utils.modulate(CardsScroll.scrollY, [0, -80],[100,0], true)
		Photo.y = Utils.modulate(CardsScroll.scrollY, [0, -Photo.height],[Photo.originalFrame.y,Photo.originalFrame.y + 70], true)
		ColorMask.scaleY = Utils.modulate(CardsScroll.scrollY, [0, -Photo.height],[1,2.5], true)
		ColorMask.opacity = Utils.modulate(CardsScroll.scrollY, [0, -80],[COLORMASK_OPACITY,0], true)
		HeaderText.opacity = Utils.modulate(CardsScroll.scrollY, [0, -50],[1,0], true)
		HeaderText.scale = Utils.modulate(CardsScroll.scrollY, [0, -200],[1,1.2], true)
		Party.scale = Utils.modulate(CardsScroll.scrollY, [0, -200],[1,1.2], true)
		Party.opacity = Utils.modulate(CardsScroll.scrollY, [0, -50],[1,0], true)
		Header.y = Utils.modulate(CardsScroll.scrollY, [0, -50],[Header.originalFrame.y, Header.originalFrame.y], true)
	else
		StatusBar.opacity = 1
		CardsScroll.speedY = 1
		Party.opacity = Utils.modulate(CardsScroll.scrollY, [50, 100],[1,0], true)
		HeaderText.opacity = Utils.modulate(CardsScroll.scrollY, [50, 100],[1,0], true)
		HeaderText.scale = Utils.modulate(CardsScroll.scrollY, [50, 100],[1,0.98], true)
		Header.y = Utils.modulate(CardsScroll.scrollY, [0, 400],[Header.originalFrame.y, -Photo.height + 40], true)
		ColorMask.opacity = Utils.modulate(CardsScroll.scrollY, [0, 400],[COLORMASK_OPACITY,1], true)
		MapThing.y = Utils.modulate(CardsScroll.scrollY, [0, 300],[MapThing.originalFrame.y,MapThing.originalFrame.y - 10], true)
		MapThing.scale = Utils.modulate(CardsScroll.scrollY, [0, 300],[1.01,0.97], true)
		PopularImageScale.y = Utils.modulate(CardsScroll.scrollY, [1600, 2400],[PopularImageScale.originalFrame.y,PopularImageScale.originalFrame.y - 30], true)
		PopularImageScale.scale = Utils.modulate(CardsScroll.scrollY, [1600, 2400],[1,0.95], true)	
		for el in [ExploreScaleImg1, ExploreScaleImg2, ExploreScaleImg3, ExploreScaleImg4, ExploreScaleImg5, ExploreScaleImg6]
			el.y = Utils.modulate(CardsScroll.scrollY, [3000, 3500], [el.originalFrame.y, el.originalFrame.y - 20], true)
			el.scale = Utils.modulate(CardsScroll.scrollY, [3000, 3500], [1.1, 0.96], true)
		Utils.delay (0.5), ->
			isMoving = false

# PROFILE SCROLLING BEHAVIOR
PROF_DRAG_DIST = 400
ProfileScoller.onMove ->
	isMoving = true
	ProfileTabs.y = Utils.modulate(ProfileScoller.scrollY, [0,PROF_DRAG_DIST - 15], [388,20], true)
	MSAInfo.y = Utils.modulate(ProfileScoller.scrollY, [0,PROF_DRAG_DIST], [302,50], true)
	MSAInfo.opacity = Utils.modulate(ProfileScoller.scrollY, [0,120], [1,0], true)
	ProfilePhoto.y = Utils.modulate(ProfileScoller.scrollY, [0,200], [72,-50], true)
	ProfileMetaContent.y = Utils.modulate(ProfileScoller.scrollY, [0,150], [ProfileMetaContent.originalFrame.y,ProfileMetaContent.originalFrame.y - 100], true)
	ProfileMetaContent.opacity = Utils.modulate(ProfileScoller.scrollY, [0,120], [1,0], true)
	ProfilePhoto.opacity = Utils.modulate(ProfileScoller.scrollY, [0,150], [1,0], true)
	ProfileName.y = Utils.modulate(ProfileScoller.scrollY, [0,300], [ProfileName.originalFrame.y,ProfileName.originalFrame.y - 190], true)
	ProfileHeaderBg.y = Utils.modulate(ProfileScoller.scrollY, [0,PROF_DRAG_DIST], [0,-300], true)
	Utils.delay (0.5), ->
		isMoving = false


# SWITCH PAGES
# PAGE HANDLER
switchPage = (page) ->
	if curPage != page
		sketch[page].placeBehind(Footer)
		if isPlaylistShown && (page == "Home")
			Playlist.placeBehind(Footer)
		for el in [HomeOff, SearchOff, UpOff, FavOff, ProfileOff]
			el.opacity = 1
		for el in [HomeTextOff, SearchTextOff, UpTextOff, FavTextOff, ProfileTextOff]
			el.opacity = 1
		for el in [HomeOn, SearchOn, UpOn, FavOn, ProfileOn]
			el.opacity = 0
		for el in [HomeTextOn, SearchTextOn, UpTextOn, FavTextOn, ProfileTextOn]
			el.opacity = 0
		curPage = page
		sketch[page + "On"].opacity = 1
		sketch[page + "Off"].opacity = 0
		sketch[page + "TextOn"].opacity = 1
		sketch[page + "TextOff"].opacity = 0
	else if page == "Home"
		if isPlaylistShown
			hidePlaylist()
		else
			CardsScroll.scrollToPoint(
				y: 0
				true
				curve: "ease"
			)
			Header.animateTo({ y: Header.originalFrame.y })
			HeaderText.animateTo({ opacity: 1 },0.1)
			Party.animateTo({ opacity: PARTY_OPACITY },0.1)
			ColorMask.animateTo({ opacity: COLORMASK_OPACITY}, 0.1)
	else if page == "Fav"
		FavScroller.scrollToPoint(
			y: 0
			true
			curve: "ease"
		)
	else if page == "Up"
		UpcompingScroller.scrollToPoint(
			y: 0
			true
			curve: "ease"
		)
	else if page == "Profile"
		if isSettingsShown
			hideSettings()

Footer.placeBehind(TopLayer)
Home.placeBehind(Footer)
turnOnText()

# Click Events
# CLICK EVENTS
MapToggleTarget.onClick ->
	if MapButton.visible
		ListIcon.visible = true
		MapButton.visible = false
		SearchResults.animate
			properties:
				opacity: 0
	else
		ListIcon.visible = false
		MapButton.visible = true
		SearchResults.animate
			properties:
				opacity: 1

BookAgainClassTarget.onClick ->
	showClass()

ClassBackTarget.onClick ->
	BaseLayer.animateTo({ scale: 1, opacity: 1 })
	ClassDetails.animateTo({ x: 900 })

BookAgainMoreTarget.onClick ->
	goToPlaylist()

ExploreCardMoreTarget.onClick ->
	goToPlaylist()

ExploreMoreCard.onClick ->
# 	goToPlaylist()

Playlist.clip = true
PlaylistBackTarget.onClick ->
	hidePlaylist()
	
SettingsTarget.onClick ->
	showSettings()

SettingsBackTarget.onClick ->
	hideSettings()

FlexTarget.onClick ->
# 	Flex.y = 1500
	Flex.x = 1600
	Flex.animateTo({ x: 0 })
	BaseLayer.animateTo({ scale: 0.95, opacity: 0.4 })

FlexBackTarget.onClick ->
	Flex.animateTo({ x: 1600 })
	BaseLayer.animateTo({ scale: 1, opacity: 1 })

ProfileHeaderContent.onClick ->
	return

PlaylistContent.onClick ->
	return

FavContent.onClick ->
	return

UpcomingContentB.onClick ->
	return

SearchResults.onClick ->
	showClass()

goToPlaylist = ->
	isPlaylistShown = true
	Playlist.placeBehind(Footer)
	Playlist.animateTo({ x: 0 })
	HomeShadeLayer.animateTo({ opacity: 1 })
	Home.animateTo({ x: -40 })

showSettings = ->
	isSettingsShown = true
	Settings.placeBehind(Footer)
	Profile.animateTo({ x: -40 })
	Settings.animateTo({ x: 0 })
	ProfileShadeLayer.animateTo({ opacity: 1 })

hideSettings = ->
	isSettingsShown = false
	Profile.animateTo({ x: 0 })
	Settings.animateTo({ x: 900 })
	ProfileShadeLayer.animateTo({ opacity: 0 })

hidePlaylist = ->
	isPlaylistShown = false
	Home.animateTo({ x: 0 })
	HomeShadeLayer.animateTo({ opacity: 0 })
	Playlist.animateTo({ x: 900 })
	
PlaylistCellTapTarget.onClick ->
	showClass()

showClass = ->
	ClassDetails.placeBehind(TopLayer)
	ClassDetails.animateTo({ x: 0 })
	BaseLayer.animateTo({ scale: 0.95, opacity: 0.4 })

HeaderUpTarget.onTouchStart ->
	HeaderUpcomingText.animateTo({ scale: 0.95 })
	Utils.delay (0.3), ->
		HeaderUpcomingText.animateTo({ scale: 1 })
	
HeaderUpTarget.onTouchEnd ->
	HeaderUpcomingText.animateTo({ scale: 1 })

HeaderPastTarget.onTouchStart ->
	HeaderPastText.animateTo({ scale: 0.95 })
	Utils.delay (0.3), ->
		HeaderPastText.animateTo({ scale: 1 })

HeaderPastTarget.onTouchEnd ->
	HeaderPastText.animateTo({ scale: 1 })

HeaderUpTarget.onClick ->
	Utils.delay (0.15), ->
		switchPage("Up")

HeaderPastTarget.onClick ->
	Utils.delay (0.15), ->
		switchPage("Profile")

# FILTERS!
# FILTERS
isFiltersShown = false
isActivitiesOut = false

for el in [Mile0, Mile1, Mile2, Mile3, Mile4]
	el.brightness = 90
	Mile0.brightness = 250
	Mile0.grayscale = 100
	el.onClick ->
		for el in [Mile0, Mile1, Mile2, Mile3, Mile4]
			el.brightness = 90
			el.grayscale = 0
		MileToggle.x = @x
		@brightness = 250
		@grayscale = 100

RightDrag.draggable.enabled = true
RightDrag.draggable.vertical = false
RightDrag.draggable.overdrag = false
RightDrag.draggable.directionLock = true
RightDrag.draggable.propagateEvents = false
RightDrag.draggable.constraints =
	x: 60
	width: 630

RightDrag.onMove ->
	OnBar.width = Utils.modulate(RightDrag.x, [60,630], [40,650], true)

NeighborhoodsOn.opacity = 0
SelectActivitiesOn.opacity = 0
FullOn.opacity = 0

FILTERS_THRESHHOLD = 400

Buttons = [AdvancedOn, BeginnerOn, ParkingOn, LockersOn, ShowersOn, OpenOn]
dragMoved = 0

NeighborhoodsOn.onClick ->
	NearbyOn.opacity = 0
	NeighborhoodsOn.opacity = 1
	NearbyOptions.visible = false
	NeighborhoodsPicked.visible = true
	
NearbyOn.onClick ->
	NeighborhoodsOn.opacity = 0
	NearbyOn.opacity = 1
	NearbyOptions.visible = true
	NeighborhoodsPicked.visible = false	

NeighborhoodsPicked.onClick ->
	goToLocations()

BackButton.onClick ->
	goBackToFilters()
	
SelectActivitiesOn.onClick ->
	AllActivitiesOn.opacity = 0
	SelectActivitiesOn.opacity = 1
	expandActivities()
	
AllActivitiesOn.onClick ->
	AllActivitiesOn.opacity = 1
	SelectActivitiesOn.opacity = 0
	collapseActivities()
	
StudioOff.onClick ->
	if StudioOn.opacity == 0
		StudioOn.opacity = 1
		Include.opacity = 1
	else
		StudioOn.opacity = 0
		Include.opacity = 0.2
FullOff.onClick ->
	if FullOn.opacity == 0
		FullOn.opacity = 1
		RecommendedOn.opacity = 0
RecommendedOn.onClick ->
	if RecommendedOn.opacity == 0
		RecommendedOn.opacity = 1
		FullOn.opacity = 0
for button in Buttons
	button.opacity = 0
	button.onClick ->
		thisButton = @
		if @opacity == 0
			thisButton.opacity = 1
		else
			thisButton.opacity = 0


NeighborhoodsContent.onTouchStart ->
	if !isFiltersScrolledUp
		Filters.animateTo({ y: 0 })
		isFiltersScrolledUp = true

FiltersScroller = ScrollComponent.wrap(FiltersContent)
FiltersScroller.scrollHorizontal = false

FiltersScroller.height = 1336

isFiltersScrolledUp = false

FiltersScroller.onScroll ->
# 	print FiltersScroller.scrollY
	if FiltersScroller.scrollY < 100
		FiltersScroller.speedY = 0.5
		if !isFiltersScrolledUp
			Filters.animateTo({ y: 0 })
			isFiltersScrolledUp = true
	else
		FiltersScroller.speedY = 1
# 	Filters.y = Utils.modulate(FiltersScroller.scrollY, [0,50], [301, 0], true)

FilterToggleTarget.onClick ->
	if !isFiltersShown
		openFilters()
	else
		closeFilters()

SearchButtonTarget.onClick ->
	closeFilters()	

Search.onClick ->
	if isFiltersShown
		closeFilters()
	else
		return

openFilters = ->
	Filters.x = 0
	Filters.y = HomeShadeLayer.height
	BaseLayer.animateTo({ opacity: 0.5, scale: 0.95 })
	Filters.animate
		properties:
			y: 300
		curve: 'spring(370,33,1)'
	StatusBar.opacity = 0
	Utils.delay (0.2), ->
		isFiltersShown = true

closeFilters = ->
	isFiltersScrolledUp = false
	FiltersScroller.scrollY = 0
	StatusBar.opacity = 1
	Filters.animate
		properties:
			y: HomeShadeLayer.height
		curve: 'spring(300,25)'
	BaseLayer.animateTo({ opacity: 1, scale: 1 })
	isFiltersShown = false
		
goBackToFilters = ->
	Neighborhoods.animateTo({ x: FiltersContent.width })
	ResetButton.animateTo({ x: ResetButton.originalFrame.x, opacity: 1 })
	DoneButton.animateTo({ x: DoneButton.originalFrame.x, opacity: 1 })
	RefineTitle.animateTo({ x: RefineTitle.originalFrame.x, opacity: 1 })
	BackButton.animateTo({ opacity: 0, x: BackButton.originalFrame.x + 20 })
	LocationTitle.animateTo({ opacity: 0, x: LocationTitle.originalFrame.x + 20 })
	FiltersContent.animateTo({ x: 0 })

goToLocations = ->
	Neighborhoods.visible = true
	BackButton.visible = true
	LocationTitle.visible = true
	LocationTitle.x = LocationTitle.originalFrame.x + 20
	BackButton.opacity = 0
	BackButton.x = BackButton.originalFrame.x + 20
	Neighborhoods.x = FiltersContent.width
	Neighborhoods.animateTo({ x: 0 })
	ResetButton.animateTo({ x: ResetButton.originalFrame.x - 20, opacity: 0 })
	DoneButton.animateTo({ x: DoneButton.originalFrame.x - 20, opacity: 0 })
	RefineTitle.animateTo({ x: RefineTitle.originalFrame.x - 20, opacity: 0 })
	BackButton.animateTo({ opacity: 1, x: BackButton.originalFrame.x })
	LocationTitle.animateTo({ opacity: 1, x: LocationTitle.originalFrame.x })
	LocationsOn.visible = true
	FiltersContent.animateTo({ x: -FiltersContent.width })
	SelectLocations.visible = false

expandActivities = ->
	if !isActivitiesOut
		ActivityList.visible = true
		ActivityList.opacity = 0
		ActivityList.y -= 20
		BottomFilters.animateTo({ y: BottomFilters.y + ActivityList.height + 60 })
		ActivityList.animateTo({ opacity: 1, y: ActivityList.originalFrame.y }, 0.1)
	Utils.delay (0.1), -> isActivitiesOut = true

collapseActivities = ->
	ActivityList.animateTo({ opacity: 0 })
	BottomFilters.animateTo({ y: BottomFilters.originalFrame.y }, 0.1)
	isActivitiesOut = false

Filters.placeBefore(TopLayer)

# Hearts Icon
# FAVORITE ICON ANIMATION
FavIconAnimate.visible = true
FavIconAnimate.bringToFront()
FavIconAnimate.opacity = 0 
FavIconAnimate.originY = 0

FavMe.onClick ->
	if FavMe.opacity == 0
		FavMe.scale = 0.9
		FavIconAnimate.animate
			properties: { scale: 1.4, opacity: 1 }
			curve: "spring(200,10)"
		Utils.delay (0.6), ->
			FavIconAnimate.animate
				properties: { y: 1020, x: FavIconAnimate.originalFrame.x - 300, rotation: -90, scale: 1, opacity: 0 }
				time: 0.5
				curve: "cubic-bezier(0.4, 0.0, 1, 1)"
			FavOff.animate
				properties: scale: 1.3
				curve: "spring(200,10)"
				delay: 0.2
			Utils.delay (0.5), ->
				FavOff.animate
					properties: { scale: 1 }
					curve: "spring(200,10)"
		FavMe.animateTo({ opacity: 1, scale: 1 })
	else
		FavMe.animateTo({ opacity: 0, scale: 0.9 })
		FavIconAnimate.opacity = 0
		FavIconAnimate.y = FavIconAnimate.originalFrame.y
		FavIconAnimate.x = FavIconAnimate.originalFrame.x
		FavIconAnimate.rotation = 0
		
# switchPage("Profile")