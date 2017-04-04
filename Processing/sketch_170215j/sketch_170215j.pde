float theta, nsX, nsY, incr = 0.02;
int frms = 120, rez = 2, radius = 75;
color black = color(34);
color white = color(238,240);
color red = color(225, 76, 69);
ArrayList<Dot> dots = new ArrayList<Dot>();

void setup() {
  size(540, 540);
  for (int x = -radius; x<radius; x += rez) {
    nsY = 0;
    for (int y = -radius; y<radius; y+= rez) {
      float distance = dist(x, y, 0, 0);
      nsY += incr;
      if (distance<radius) {
        PVector start = new PVector(x, y);
        PVector end = PVector.mult(start, 2);
        float ns = noise(nsX, nsY);
        dots.add(new Dot(start, end, ns));
      }
    } 
    nsX += incr;
  }
}

void draw() {
  background(black);
  translate(width/2, height/2);
  for (Dot d : dots) {
    d.update();
    d.show();
  }
  theta += TWO_PI/frms;
  //if (frameCount<=frms) saveFrame("image-###.gif");
}

class Dot {

  PVector start, end, v;
  float sz = 1;
  float lerpValue, offSet;
  
  Dot(PVector _start, PVector _end, float _ns) {
    start = _start;
    end = _end;
    offSet = map(_ns,.2,.8,0,TWO_PI);
  }
  
  void update() {
    lerpValue = map(sin(theta+offSet),-1,1,0,1);
    v = PVector.lerp(start, end, lerpValue);
  }

  void show() {
    noStroke();
    strokeWeight(0.9);
    fill(white);
    ellipse(v.x, v.y,sz,sz);
  
  }


}