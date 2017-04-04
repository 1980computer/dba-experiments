HColorPool colors;
HDrawablePool pool;

int value = 0;

void setup() {
  size(1280,1280);
  H.init(this).background(#e80060);
  smooth();

  colors = new HColorPool(#FFFFFF, #F7F7F7, #ECECEC, #ff1500, #ff7000, #ffa300, #FF3300, #FF6600);

  pool = new HDrawablePool(400);
  pool.autoAddToStage()
    .add(
      new HRect(100)
      .rounding(100)
      .anchorAt(H.CENTER)
      .noStroke()
    )

    .layout(
      new HGridLayout()
      .startLoc(0, height/2)
      .spacing(1, 0)
      .cols(400)
    )

    .onCreate(
      new HCallback() {
        public void run(Object obj) {
          int i = pool.currentIndex();

          HDrawable d = (HDrawable) obj;
          d.fill( colors.getColor(i*100) );

          new HOscillator()
            .target(d)
            .property(H.X)
            .relativeVal(d.x())
            .range(-300, 1000)
            .speed(1)
            .freq(0.5)
            .currentStep(i)
          ;

          new HOscillator()
            .target(d)
            .property(H.Y)
            .relativeVal(d.y())
            .range(-300, 1000)
            .speed(2)
            .freq(0.7)
            .currentStep(i)
          ;

          new HOscillator()
            .target(d)
            .property(H.ROTATION)
            .range(0, 360)
            .speed(0.001)
            .freq(1)
            .currentStep(i)
          ;

          new HOscillator()
            .target(d)
            .property(H.SCALE)
            .range(0, 2)
            .speed(1)
            .freq(4)
            .currentStep(i)
          ;
        }
      }
    )

    .requestAll()
  ;
}

void draw() {
  H.drawStage();
}

void keyPressed() {
  if (value == 0) {
    saveFrame("supercolony_6_365-###.png"); 
  }
}
