void setup() {
  size(640, 640);
  background(0);
  stroke(255);
  noFill();
}
float xstep = 5;
float ystep = 10;
float y = 0;

float nx = random(100);
float ny = random(100);
float nz = random(1000);
void draw() {
  background(0);
  for (float j = 0; height+ystep > j; j+=ystep) {
    beginShape();
    vertex(0, j);
    for (float i = 0; i < width+xstep; i+=xstep) {
      nx = i/234;
      ny = j/165; 
      y = map(noise(nx, ny, nz), 0, 1, -100, 100)+j;
      curveVertex(i, y);
    }
    vertex(width, j);
    endShape();
  }
  nz+=.01;
}