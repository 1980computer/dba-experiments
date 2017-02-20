int num = 240, dotsSide = num/4, spaceBetween = 5, counter, frames = 180; 
float x, y, radius, theta, sz = 2;
PVector[] dotsRect = new PVector[num];
PVector[] dotsCircle = new PVector[num];

void setup() {
  size(540, 540);
  background(0);
  noStroke();
  for (int j=1; j<=4; j++) {
    for (int i=0; i<dotsSide; i++) {
      switch (j) {
      case 1:
        x = i*spaceBetween;
        y = 0;
        break;
      case 2:
        x = dotsSide*spaceBetween;
        y = i*spaceBetween;
        break;
      case 3:        
        x = dotsSide*spaceBetween - i*spaceBetween;
        y = dotsSide*spaceBetween;
        break;
      case 4:
        x = 0;
        y = dotsSide*spaceBetween - i*spaceBetween;
        break;
      }
      dotsRect[counter] = new PVector(x, y);
      counter++;
    }
  }
  radius = (dotsSide*spaceBetween)/2;
  for (int i=0; i<num; i++) {
    x = radius + cos(PI+PI/4+TWO_PI/num*i)*radius*.8;
    y = radius + sin(PI+PI/4+TWO_PI/num*i)*radius*.8;
    dotsCircle[i] = new PVector(x, y);
  }
}

void draw() {
  background(0);
  translate((width-2*radius)/2, (width-2*radius)/2);
  fill(255);
  for (int i=0; i<num; i++) {
    float offSet = map(i, 0, num-1, 0, TWO_PI);
    float lerpValue = map(sin(theta), -1, 1, 0, 1);
    PVector newV = PVector.lerp(dotsRect[i], dotsCircle[i], lerpValue);
    ellipse(newV.x, newV.y, sz, sz);
  }
  theta += TWO_PI/frames;
}