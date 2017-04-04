#Define varaibles
numbers = 3
size = 160
radius = size / 2
rotation = 2 * Math.PI / numbers
width = 45
height = width * 0.4
corner = 10
spinRotation = 0
objects = []

widthCirle = Utils.cycle([width * 2, height * 1.3, width])
heightCircle = Utils.cycle([height * 0.7, height * 1.3, height])
cornerCircle = Utils.cycle([corner * 0.8, '50%', corner])
radiusCircle = Utils.cycle([radius * 1.1, radius * 0.7, radius])
spinCircle = Utils.cycle([60, 30, 0])

#Define container
container = new Layer
	width: size
	height: size
	borderRadius: '50%'
	backgroundColor: null

container.center()

#Draw three objects
for i in [0...numbers]
	object = new Layer
		parent: container
		backgroundColor: "rgba(115,252,214,1)"
		width: width
		height: height
		borderRadius: corner
		midX: radius * (Math.cos(rotation * i + Math.PI / 2)) + size / 2		
		midY: radius * (-Math.sin(rotation * i + Math.PI / 2)) + size / 2 
		rotation: ((- i) * rotation * 180) / Math.PI + spinRotation
	object.index = i
	object.number = i
	objects.push(object)
	
# Move objects
Utils.interval 1, ->
	radius = radiusCircle()
	width = widthCirle()
	height = heightCircle()
	corner = cornerCircle()	
	spin = spinCircle()
	spinRotation += spin
	
	for object in objects
		i = (object.index + 1) % 3
		object.index = i
		object.animate
			properties:
				width: width
				height: height
				borderRadius: corner
				midX: radius * (Math.cos(rotation * i + Math.PI / 2)) + size / 2		
				midY: radius * (-Math.sin(rotation * i + Math.PI / 2)) + size / 2 
				rotation: ((- object.number) * rotation * 180) / Math.PI + spinRotation
			options: 
				curve: Bezier.easeInOut




		
		

	