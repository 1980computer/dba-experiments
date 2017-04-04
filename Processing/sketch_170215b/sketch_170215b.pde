// acd 2014
void setup() {
  size(600, 600);
  smooth();
  background(255);
  stroke(0);
  fill(0);
}
 
void draw() {
  translate(width / 2, height / 2);
  float angle = TWO_PI / 21.0;
  for (float rad = 20.0 ; rad < 400.0 ; /* no inc here */) {
    float s = TWO_PI * rad / 42.0;  // size of square, depends on circumference
    for(int i = 0 ; i < 21 ; i++) { // 21 squares per ring
      rect(0, rad, s, s);
      rotate(angle);
    }
    rotate(angle * .25);  // rings are offset from each other
    rad += .95 * s;  // move out by size
  }
  noLoop();
}