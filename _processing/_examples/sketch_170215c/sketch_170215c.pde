int num =20, frms = 120;
float step, sz, offSet, theta;

void setup() {
  size(540, 540, P2D);
  smooth(8);
  strokeWeight(5);
  strokeCap(SQUARE);
  step = 20;
}

void draw() {
  background(34);
  translate(width/2, height/2);
  for (int i=0; i<num; i++) {
    //stroke(360/num*i, 90, 90);
    stroke(238);
    if (i%7==0) stroke(225,76,69);
    noFill();
    sz = i*step;
    float offSet = TWO_PI/num*i;
    float arcEnd = map(sin(theta+offSet), -1, 1, PI/2, TWO_PI+PI/2);
    arc(0, 0, sz, sz, PI, arcEnd);
  }
  theta += TWO_PI/frms;
  if (frameCount<frms) saveFrame("image-###.gif");
}