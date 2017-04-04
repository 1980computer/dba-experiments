ArrayList<Dot> dots = new ArrayList<Dot>();
int n = 0, c=5, frms = 100;
float theta; 

void setup() {
  size(540, 540);
  while (n<500) {
    float offSet = PI/500*n;
    c = 2;
    float a = n*137.5;
    float r = c * sqrt(n);
    float x = width/2 + cos(a)*r;
    float y = height/2 + sin(a)*r;
    PVector start = new PVector(x, y);
    c = 8;
    a = n*137.5;
    r = c * sqrt(n);
    x = width/2 + cos(a)*r;
    y = height/2 + sin(a)*r; 
    PVector end = new PVector(x, y);
    dots.add(new Dot(start, end, offSet));
    n++;
  }
}

void draw() {
  background(238);
  for (Dot d: dots) {
    d.update();
    d.show();
  }
  
  theta += TWO_PI/frms;
  //if (frameCount<=frms) saveFrame("image-###.gif");
}

class Dot {

  PVector start, end, v;
  float sz = 20;
  float x, y, lerpValue, offSet;

  Dot(PVector _start, PVector _end, float _offSet) {
    start = _start;
    end = _end;
    offSet = _offSet;
  }

  void show() {
    stroke(238);
    fill(34);
    ellipse(v.x, v.y, sz, sz);
  }

  void update() {
    sz = map(sin(theta+offSet), -1, 1, 10, 30);
    lerpValue = map(sin(theta+offSet), -1, 1, 0, 1);
    v = PVector.lerp(start, end, lerpValue);
  }
}