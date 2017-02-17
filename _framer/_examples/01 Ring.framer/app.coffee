# background
bg = new Layer
	width: 750
	height: 1334
	image: "images/bg.jpg"

# ring
ring = new Layer
	width: 618
	height: 618
	image: "images/ring.jpg"
	x: 66
	y: 358
	opacity: 0.00
	scale: 0.80

ring.animate
	opacity: 1.00
	scale: 1.00
	options:
		time: 2
		curve: "ease"
		repeat: 100


