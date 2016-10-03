
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
}