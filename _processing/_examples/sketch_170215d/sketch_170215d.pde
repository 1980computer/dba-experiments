int incr = 4;
int radius = 3;
int num = 3, n=2;
PGraphics myMask, layer;

void setup() {
  size(1080, 720);
  float maxHeight = height*.45;
  myMask = createGraphics(width, height);
  layer = createGraphics(width, height);

  myMask.beginDraw();
  myMask.background(0);
  myMask.fill(255);
  myMask.noStroke();
  myMask.ellipse(width/2, height/2, maxHeight*1.9, maxHeight*1.9);
  myMask.endDraw();

  layer.beginDraw();
  layer.background(238);
  layer.noStroke();
  layer.fill(34);
  while (radius < maxHeight) {
    for (int i=0; i<num; i++) {
      float angle = PI/2+TWO_PI/num*i;
      float x = width/2 + cos(angle)*radius;
      float y = height/2 + sin(angle)*radius;
      float a = map(radius, 0, maxHeight, -1, 7);
      float sz = incr+a;
      layer.ellipse(x, y, sz, sz);
    }
    num += n;
    radius += incr;
  }
  layer.endDraw();
  layer.mask(myMask);
  image(layer, 0, 0);
}

void draw() {
}

void keyPressed() {
  if (key == 's') save(n+".png");
}