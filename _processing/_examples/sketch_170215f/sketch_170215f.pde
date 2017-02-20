Blob[] blobs = new Blob[20];
int frms = 90;
float theta;

void setup() {
  size(750, 540);
  for (int i=0; i<blobs.length; i++) {
    blobs[i] = new Blob(random(width), random(height));
  }
}

void draw() {
  background(51);

  for (int i=0; i<blobs.length; i++) {
    blobs[i].update();
  }

  loadPixels();

  for (int x=0; x<width; x++) {
    for (int y = 0; y<height; y++) {
      int index = x + y * width;
      float sum = 0;
      for (Blob b : blobs) {
        float d = dist(x, y, b.pos.x, b.pos.y);
        sum += b.r/d*75;
      }
      pixels[index] = color(sum, sum/2, sum/3);
    }
  }

  updatePixels();

  theta += TWO_PI/frms;
  //if (frameCount<=frms) saveFrame("image-###.gif");
}


class Blob {

  PVector pos, orig;
  //PVector vel;
  float r, d, offSet; 

  Blob(float _x, float _y) {
    orig = new PVector(_x, _y);
    pos = new PVector(0, 0);
    r = random(20, 60);
    //vel = PVector.random2D();
    //vel.mult(random(2, 5));
    //diam = 2*r;
    d = random(25, 150);
    offSet= random(-PI, PI);
  }

  void update() {
    //pos.add(vel);
    pos.x = orig.x + cos(theta+offSet)*d;
    pos.y = orig.y + sin(theta+offSet)*d;

    //if (pos.x > width + diam || pos.x<-diam) vel.x *= -1;
    //if (pos.y > height+ diam || pos.y<-diam) vel.y *= -1;
  }

  void show() {
    noFill();
    stroke(0);
    strokeWeight(4);
    ellipse(pos.x, pos.y, 2*r, 2*r);
  }
}