import processing.pdf.*;
boolean record = false;
HShape  r1, r2, r3;
HTween t1a;
HTween t2a, t2b;
HTween t3a, t3b, t3c, t3d;

void setup() {
	size(1280, 1280);
	H.init(this).background(#2c5265).autoClear(false);
	smooth();

	// Rect 1 and tween

	r1 = new HShape(("vectors-1.svg"));
	r1
		.enableStyle(false)
		.stroke(#415b68, 100)
		.fill(#99acbb)
		.anchorAt(H.CENTER)
		.loc(width-125,125)
		.rotation(45)
		.size((int)random(100,400))
	;
	H.add(r1);

	t1a = new HTween()
		.target(r1).property(H.LOCATION)
		.start( r1.x(), r1.y() )
		.end( r1.x(), height - 125 )
		.ease(0.005)
		.spring(0.95)
	;

	// Rect 2 and tweens

	r2 = new HShape(("vectors-2.svg"));
	r2
		.enableStyle(false)
		.anchorAt(H.CENTER)
		.stroke(#ffffff, 100)
		.fill(#325366)
		.loc(width/2,height/2)
		.rotation(45)
		.size((int)random(100,400))
	;
	
	H.add(r2);

	t2a = new HTween().target(r2).property(H.LOCATION).start( r2.x(), r2.y() ).end( r2.x(), height - 125 ).ease(0.005).spring(0.95);
	t2b = new HTween().target(r2).property(H.SCALE).start(0).end(1).ease(0.005).spring(0.95);

	// Rect 3 and tweens

	r3 = new HShape(("vectors-3.svg"));
	r3	
		.enableStyle(false)
		.stroke(#415b68, 100)
		.fill(#5b8ab6)
		.anchorAt(H.CENTER)
		.loc(width-125,125)
		.rotation(360);
	H.add(r3);

	t3a = new HTween().target(r3).property(H.LOCATION).start( r3.x(), r3.y() ).end( r3.x(), height - 125 ).ease(0.005).spring(0.95);
	t3b = new HTween().target(r3).property(H.SCALE).start(0).end(1).ease(0.005).spring(0.95);
	t3c = new HTween().target(r3).property(H.ALPHA).start(0).end(255).ease(0.005).spring(0.95);
	t3d = new HTween().target(r3).property(H.ROTATION).start(-45).end(405).ease(0.005).spring(0.95);
}

void draw() {
	H.drawStage();
	PGraphics tmp = null;

	if (record) {
		tmp = beginRecord(PDF, "render-######.pdf");
	}

	if (tmp == null) {
		H.drawStage();
	} else {
		PGraphics g = tmp;
		boolean uses3D = false;
		float alpha = 1;
		H.stage().paintAll(g, uses3D, alpha);
	}

	if (record) {
		endRecord();
		record = false;
	}
}

void keyPressed() {
	if (key == 's') {
		//record = true;
		saveFrame();
		draw();
	}
}

