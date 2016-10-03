
void draw() {
  rootViewController.draw();
}

void mouseWheel(MouseEvent event) {
  rootViewController.mouseWheel(event);
}

void mousePressed() {
  if (gensToDo >= 1) {
    gensToDo = 0;
  }
  rootViewController.mousePressed();
}

void mouseReleased() {
  drag = false;
  miniSimulation = false;
  rootViewController.mouseReleased();
  if (menu == 7 && abs(actualMouseX()-1030) <= 130 && abs(actualMouseY()-684) <= 20) {
    setMenu(8);
  } else if ((menu == 5 || menu == 4) && actualMouseY() >= windowHeight-40) {
    if (actualMouseX() < 90) {
      for (int s = timer; s < 900; s++) {
        simulate();
      }
      timer = 1021;
    } else if (actualMouseX() >= 120 && actualMouseX() < 360) {
      speed *= 2;
      if (speed == 1024) speed = 900;
      if (speed >= 1800) speed = 1;
    } else if (actualMouseX() >= windowWidth-120) {
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
  } else if (menu == 8 && actualMouseX() < 90 && actualMouseY() >= windowHeight-40) {
    timer = 100000;
  } else if (menu == 9 && abs(actualMouseX()-1030) <= 130 && abs(actualMouseY()-690) <= 20) {
    setMenu(10);
  } else if (menu == 11 && abs(actualMouseX()-1130) <= 80 && abs(actualMouseY()-690) <= 20) {
    setMenu(12);
  } else if (menu == 13 && abs(actualMouseX()-1130) <= 80 && abs(actualMouseY()-690) <= 20) {
    setMenu(1);
  }
}