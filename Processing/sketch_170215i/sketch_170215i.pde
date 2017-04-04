float x, y, theta;
int frms = 280, num = 3;

void setup() {
  size(540, 540);
  background(0);
}

void draw() {
  blendMode(SUBTRACT);
  fill(1);
  noStroke();
  rect(0, 0, width, height);
  blendMode(BLEND);
  fill(255);
  for (int i=0; i<num; i++) {
    x = width/2 + sin(theta)*60*(i+1);
    y = height/2 + cos(theta)*60*(i+1);
    ellipse(x, y, 25, 25);
  }
  theta += TWO_PI/frms;
}