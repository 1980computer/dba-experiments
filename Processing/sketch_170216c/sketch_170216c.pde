// scene //
int countFrames = 20;
boolean saveFrames = false;
float screenScale = 0.9;

// initialize //
float[][] points;
ArrayList<int[]> connections = new ArrayList();
color c;

// tinker //
int countPoints = 2000; // number of random points to generate //
float radius = 25; // max distance between connected points //
int maxConnections = 20; // max connections each point can have //
int period = 12; // numbers of periods to display //

void setup() {
  
  size(500, 500);
  randomSeed(420420);
  points = new float[countPoints][2];
  
  // generate random points and store in array //
  for (int i = 0; i < countPoints; i++) {
    points[i][0] = random(-screenScale * width / 2, screenScale * width / 2);
    points[i][1] = random(-screenScale * height / 2, screenScale * height / 2);
  }
  
  // for each point check distance to other points //
  // only compare points with a higher array index to avoid duplication //
  // if distance between points is small enough store in arraylist //
  // if point already has enough connections disregard new connections //
  for (int i = 0; i < countPoints; i++) {
    int countConnections = 0;
    for (int j = 0; j < countPoints; j++) {
      if (i < j) {
        float distance = sqrt(pow(points[i][0] - points[j][0], 2) + pow(points[i][1] - points[j][1], 2));
        if (distance <= radius) {
          countConnections++;
          if (countConnections <= maxConnections) connections.add(new int[] {i, j});
        }
      }
    }
  }
  
}
void draw() {
  
  background(#2D4059);
  
  // for each frame track ratio between 0 and 2PI //
  float sceneRatio = 2 * PI * (float(frameCount) - 1) / countFrames;
  
  // in case frame isn't square get min dimension //
  float minScene = min(screenScale * width / 2, screenScale * height / 2);
  
  // shift everything to center //
  translate(width / 2, height / 2);
  
  // loop through each connection //
  for (int n = 0; n < connections.size(); n++) {
    // get coordinates of each endpoint //
    float x1 = points[connections.get(n)[0]][0];
    float y1 = points[connections.get(n)[0]][1];
    float x2 = points[connections.get(n)[1]][0];
    float y2 = points[connections.get(n)[1]][1];
    
    // calculate distance between origin and midpoint of connection //
    float distFromOrig = sqrt(pow((x1 + x2) / 2, 2) + pow((y1 + y2) / 2, 2));
    
    // determine the color of each connection //
    if (n % 3 == 0) c = color(#EA5455);
    if (n % 3 == 1) c = color(#F07B3F);
    if (n % 3 == 2) c = color(#FFD460);
    
    // determine which connections should be shown //
    if (sin(map(distFromOrig, 0, minScene, 0, period * 2 * PI) - sceneRatio) > 0.25) stroke(c, map(distFromOrig, 0, minScene, 255, 0));
    else noStroke();
    
    // draw the connection //
    line(x1, y1, x2, y2);
  }
  
  // saving frames for output //
  if (saveFrames) {
    if (frameCount <= countFrames) {
      saveFrame("f###.gif");
    }
    else {
      exit();
    }
  }
}