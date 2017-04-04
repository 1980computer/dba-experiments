float theta;
int frms = 120, num = 50;
float n1, n2, n3, m, a, b;

void setup() {
  size(750, 540, P2D);
  smooth(8);
  n1 = 1;
  n2 = 1;
  n3 = 1;
  m = 5;
  a = 1;
  b = 1;
}

void draw() {
  background(51);
  translate(width/2, height/2);
  pushMatrix();
  rotate(PI/2);
  noFill();
  stroke(238, 120);
  m = 7; //(int) map(mouseX, 0, width, 0, 7);
  n1 = map(sin(theta), -1, 1, 0.1, 1); //map(mouseY, 0, height, 0, 1);
  n2 = n3 = n1;

  //println("m: " + m + "n1: " + n1);

  for (int i=0; i<num; i++) {
    float offSet = PI/2/num*i;
    float radius = 200;
    int total = 250;
    float incr = TWO_PI/total;
    beginShape();
    for (float angle = 0; angle<TWO_PI; angle+=incr) {
      float r = supershape(angle);
      float x = radius * r * cos(angle+offSet);
      float y = radius * r * sin(angle+offSet);
      vertex(x, y);
    }
    endShape(CLOSE);
  }
  popMatrix();

  theta += TWO_PI/frms;
  //if (frameCount <= frms) saveFrame(m + "_image-###.gif");
}

float supershape(float theta) {
  float part1 = (1/a)*cos(theta*m/4);
  part1 = abs(part1);
  part1 = pow(part1, n2);

  float part2 = (1/b)*sin(theta*m/4);
  part2 = abs(part2);
  part2 = pow(part2, n3);

  float part3 = pow(part1 + part2, 1/n1);

  //if (part3==0) return 0;

  return 1/part3;
}