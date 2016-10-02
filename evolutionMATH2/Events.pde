
void setup() {
  size(1280, 720, P2D);
  frameRate(60);
  noSmooth();
  ellipseMode(CENTER);
  Float[] beginPercentile = new Float[29];
  Integer[] beginBar = new Integer[barLen];
  Integer[] beginSpecies = new Integer[101];
  for (int i = 0; i < 29; i++) {
    beginPercentile[i] = 0.0;
  }
  for (int i = 0; i < barLen; i++) {
    beginBar[i] = 0;
  }
  for (int i = 0; i < 101; i++) {
    beginSpecies[i] = 500;
  }

  percentile.add(beginPercentile);
  barCounts.add(beginBar);
  speciesCounts.add(beginSpecies);
  topSpeciesCounts.add(0);

  graphImage = createGraphics(975, 570);
  screenImage = createGraphics(1920, 1080);
  popUpImage = createGraphics(450, 450);
  segBarImage = createGraphics(975, 150);
  segBarImage.beginDraw();
  segBarImage.smooth();
  segBarImage.background(220);
  segBarImage.endDraw();
  popUpImage.beginDraw();
  popUpImage.smooth();
  popUpImage.background(220);
  popUpImage.endDraw();

  font = loadFont("Helvetica-Bold-96.vlw"); 
  textFont(font, 96);
  textAlign(CENTER);

  /*rects.add(new Rectangle(4,-7,9,-3));
   rects.add(new Rectangle(6,-1,10,10));
   rects.add(new Rectangle(9.5,-1.5,13,10));
   rects.add(new Rectangle(12,-2,16,10));
   rects.add(new Rectangle(15,-2.5,19,10));
   rects.add(new Rectangle(18,-3,22,10));
   rects.add(new Rectangle(21,-3.5,25,10));
   rects.add(new Rectangle(24,-4,28,10));
   rects.add(new Rectangle(27,-4.5,31,10));
   rects.add(new Rectangle(30,-5,34,10));
   rects.add(new Rectangle(33,-5.5,37,10));
   rects.add(new Rectangle(36,-6,40,10));
   rects.add(new Rectangle(39,-6.5,100,10));*/

  //rects.add(new Rectangle(-100,-100,100,-2.8));
  //rects.add(new Rectangle(-100,0,100,100));
  //Snaking thing below:
  /*rects.add(new Rectangle(-400,-10,1.5,-1.5));
   rects.add(new Rectangle(-400,-10,3,-3));
   rects.add(new Rectangle(-400,-10,4.5,-4.5));
   rects.add(new Rectangle(-400,-10,6,-6));
   rects.add(new Rectangle(0.75,-0.75,400,4));
   rects.add(new Rectangle(2.25,-2.25,400,4));
   rects.add(new Rectangle(3.75,-3.75,400,4));
   rects.add(new Rectangle(5.25,-5.25,400,4));
   rects.add(new Rectangle(-400,-5.25,0,4));*/
}

void draw() {
  rootViewController.draw();
}

void mouseWheel(MouseEvent event) {
  float delta = event.getCount();
  if (menu == 5) {
    if (delta == -1) {
      camZoom *= 0.9090909;
      if (camZoom < 0.002) {
        camZoom = 0.002;
      }
      textFont(font, postFontSize);
    } else if (delta == 1) {
      camZoom *= 1.1;
      if (camZoom > 0.1) {
        camZoom = 0.1;
      }
      textFont(font, postFontSize);
    }
  }
}

void mousePressed() {
  if (gensToDo >= 1) {
    gensToDo = 0;
  }
  float mX = mouseX/windowSizeMultiplier;
  float mY = mouseY/windowSizeMultiplier;
  if (menu == 1 && gen >= 1 && abs(mY-365) <= 25 && abs(mX-sliderX-25) <= 25) {
    drag = true;
  }
}

void mouseReleased() {
  drag = false;
  miniSimulation = false;
  float mX = mouseX/windowSizeMultiplier;
  float mY = mouseY/windowSizeMultiplier;
  if (menu == 0 && abs(mX-windowWidth/2) <= 200 && abs(mY-400) <= 100) {
    setMenu(1);
  } else if (menu == 1 && gen == -1 && abs(mX-120) <= 100 && abs(mY-300) <= 50) {
    setMenu(2);
  } else if (menu == 1 && gen >= 0 && abs(mX-990) <= 230) {
    if (abs(mY-40) <= 20) {
      setMenu(4);
      speed = 1;
      creaturesTested = 0;
      stepbystep = true;
      stepbystepslow = true;
    }
    if (abs(mY-90) <= 20) {
      setMenu(4);
      creaturesTested = 0;
      stepbystep = true;
      stepbystepslow = false;
    }
    if (abs(mY-140) <= 20) {
      if (mX < 990) {
        gensToDo = 1;
      } else {
        gensToDo = 1000000000;
      }
      startASAP();
    }
  } else if (menu == 3 && abs(mX-1030) <= 130 && abs(mY-684) <= 20) {
    gen = 0;
    setMenu(1);
  } else if (menu == 7 && abs(mX-1030) <= 130 && abs(mY-684) <= 20) {
    setMenu(8);
  } else if ((menu == 5 || menu == 4) && mY >= windowHeight-40) {
    if (mX < 90) {
      for (int s = timer; s < 900; s++) {
        simulate();
      }
      timer = 1021;
    } else if (mX >= 120 && mX < 360) {
      speed *= 2;
      if (speed == 1024) speed = 900;
      if (speed >= 1800) speed = 1;
    } else if (mX >= windowWidth-120) {
      for (int s = timer; s < 900; s++) {
        simulate();
      }
      timer = 0;
      creaturesTested++;
      for (int i = creaturesTested; i < 1000; i++) {
        setGlobalVariables(c[i]);
        for (int s = 0; s < 900; s++) {
          simulate();
        }
        setAverages();
        setFitness(i);
      }
      setMenu(6);
    }
  } else if (menu == 8 && mX < 90 && mY >= windowHeight-40) {
    timer = 100000;
  } else if (menu == 9 && abs(mX-1030) <= 130 && abs(mY-690) <= 20) {
    setMenu(10);
  } else if (menu == 11 && abs(mX-1130) <= 80 && abs(mY-690) <= 20) {
    setMenu(12);
  } else if (menu == 13 && abs(mX-1130) <= 80 && abs(mY-690) <= 20) {
    setMenu(1);
  }
}