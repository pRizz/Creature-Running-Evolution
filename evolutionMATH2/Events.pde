


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
        setGlobalVariables(creatures[i]);
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