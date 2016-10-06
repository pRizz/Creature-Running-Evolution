

abstract class ViewController {
  abstract void draw();
  void mouseWheel(MouseEvent event) {
  }
  void mousePressed() {
  }
  void mouseReleased() {
  }
  void viewWillAppear() {
  }
}

RootViewController rootViewController = new RootViewController(); // Singleton

class RootViewController extends ViewController {
  private ViewController presentedViewController = null;

  RootViewController() {
    presentViewController(new IntroViewController());
  }

  void presentViewController(ViewController vc) {
    presentedViewController = vc;
    if (presentedViewController != null) { 
      presentedViewController.viewWillAppear();
    }
  }

  void mouseWheel(MouseEvent event) {
    if (presentedViewController == null) { 
      return;
    }
    presentedViewController.mouseWheel(event);
  }

  void mousePressed() {
    if (presentedViewController == null) { 
      return;
    }
    presentedViewController.mousePressed();
  }

  void mouseReleased() {
    if (presentedViewController == null) { 
      return;
    }
    presentedViewController.mouseReleased();
  }

  void draw() {
    scale(windowSizeMultiplier);
    if (menu == 0) {
      new IntroViewController().draw();
    } else if (menu == 1) {
      new MainViewController().draw();
    } else if (menu == 2) {
      new Menu2ViewController().draw();
    } else if (menu == 4) {
      new Menu4ViewController().draw();
    }
    if (menu == 5) {
      new Menu5ViewController().draw();
    }
    if (menu == 6) {
      new Menu6ViewController().draw();
    }
    if (menu == 8) {
      new Menu8ViewController().draw();
    }

    prevStatusWindow = statusWindow;

    statusWindow = calculateNextStatusWindow();

    if (menu == 10) {
      new Menu10ViewController().draw();
    }
    if (menu == 12) {
      new Menu12ViewController().draw();
    }
    if (menu%2 == 1 && abs(menu-10) <= 3) {
      image(screenImage, 0, 0, 1280, 720);
    }
    if (menu == 1 || gensToDo >= 1) {
      new PostDrawViewController().draw();
    }
    if (statusWindow >= -3) {
      drawStatusWindow(prevStatusWindow == -4);
      if (statusWindow >= -3 && !miniSimulation) {
        openMiniSimulation();
      }
    }
    overallTimer++;
  } // end of draw()
}

// Menu 0, only draws
class IntroViewController extends ViewController {
  void mouseReleased() {
    if (abs(actualMouseX()-windowWidth/2) <= 200 && abs(actualMouseY()-400) <= 100) {
      setMenu(1);
    }
  }

  void draw() {
    background(255);
    fill(100, 200, 100);
    noStroke();
    rect(windowWidth/2-200, 300, 400, 200);
    fill(0);
    text("EVOLUTION!", windowWidth/2, 200);
    text("START", windowWidth/2, 430);
  }
}

// Menu 1, can mutate the menu to 4 in startASAP(), if doing many gens.
class MainViewController extends ViewController {
  void viewWillAppear() {
    drawGraph(975, 570);
  }

  void mousePressed() {
    // handle the slider
    // TODO: encapsulate the drag variable for this slider.
    if (gen >= 1 && abs(actualMouseY()-365) <= 25 && abs(actualMouseX()-sliderX-25) <= 25) {
      drag = true;
    }
  }

  void mouseReleased() {
    if (gen == -1 && abs(actualMouseX()-120) <= 100 && abs(actualMouseY()-300) <= 50) { // Create button
      setMenu(2);
    } else if (gen >= 0 && abs(actualMouseX()-990) <= 230) {
      if (abs(actualMouseY()-40) <= 20) {
        setMenu(4);
        speed = 1;
        creaturesTested = 0;
        stepbystep = true;
        stepbystepslow = true;
      }
      if (abs(actualMouseY()-90) <= 20) {
        setMenu(4);
        creaturesTested = 0;
        stepbystep = true;
        stepbystepslow = false;
      }
      if (abs(actualMouseY()-140) <= 20) {
        if (actualMouseX() < 990) {
          gensToDo = 1; // ASAP button pressed
        } else {
          gensToDo = 1000000000; // ALAP button pressed
        }
        startASAP();
      }
    }
  }

  void draw() {
    noStroke();
    fill(0);
    background(255, 200, 130);
    textFont(font, 32);
    textAlign(LEFT);
    textFont(font, 96);
    text("Generation "+max(genSelected, 0), 20, 100);
    textFont(font, 28);
    if (gen == -1) {
      fill(100, 200, 100);
      rect(20, 250, 200, 100);
      fill(0);
      text("Since there are no creatures yet, create 1000 creatures!", 20, 160);
      text("They will be randomly created, and also very simple.", 20, 200);
      text("CREATE", 56, 312);
    } else {
      fill(100, 200, 100);
      rect(760, 20, 460, 40); // Step by step button
      rect(760, 70, 460, 40); // 1 quick generation button
      rect(760, 120, 230, 40); // 1 asap button
      if (gensToDo >= 2) {
        fill(128, 255, 128);
      } else {
        fill(70, 140, 70);
      }
      rect(990, 120, 230, 40); // do gens alap button
      fill(0);
      text("Do 1 step-by-step generation.", 770, 50);
      text("Do 1 quick generation.", 770, 100);
      text("Do 1 gen ASAP.", 770, 150);
      text("Do gens ALAP.", 1000, 150);
      text("Median "+fitnessName, 50, 160);
      textAlign(CENTER);
      textAlign(RIGHT);
      text(float(round(percentile.get(min(genSelected, percentile.size()-1))[14]*1000))/1000+" "+fitnessUnit, 700, 160);
      drawHistogram(760, 410, 460, 280);
      drawGraphImage();
      if (saveFramesPerGeneration && gen > lastImageSaved) {
        saveFrame("imgs//"+zeros(gen, 5)+".png");
        lastImageSaved = gen;
      }
    }
    if (gensToDo >= 1) {
      gensToDo--;
      if (gensToDo >= 1) {
        startASAP();
      }
    }
  }
}

// The "Here are your 1000 randomly generated creatures!!!" which displays the creatures as small
class Menu2ViewController extends ViewController {
  void draw() {
    background(220, 253, 102);
    pushMatrix();
    scale(10.0/scaleToFixBug);
    for (int y = 0; y < 25; y++) {
      for (int x = 0; x < 40; x++) {
        nodes.clear();
        muscles.clear();
        int nodeNum = int(random(3, 6));
        int muscleNum = int(random(nodeNum-1, nodeNum*3-6));
        for (int i = 0; i < nodeNum; i++) {
          nodes.add(new Node(random(-1, 1), random(-1, 1), 0, 0, 0.4, random(0, 1), random(0, 1), 
            floor(random(0, operationCount)), floor(random(0, nodeNum)), floor(random(0, nodeNum)))); //replaced all nodes' sizes with 0.4, used to be random(0.1,1), random(0,1)
        }
        for (int i = 0; i < muscleNum; i++) {
          int tc1 = 0;
          int tc2 = 0;
          int taxon = getNewMuscleAxon(nodeNum);
          if (i < nodeNum-1) {
            tc1 = i;
            tc2 = i+1;
          } else {
            tc1 = int(random(0, nodeNum));
            tc2 = tc1;
            while (tc2 == tc1) {
              tc2 = int(random(0, nodeNum));
            }
          }
          float len = random(0.5, 1.5);
          muscles.add(new Muscle(taxon, tc1, tc2, len, random(0.02, 0.08)));
        }
        toStableConfiguration(nodeNum, muscleNum);
        adjustToCenter(nodeNum);
        float heartbeat = random(40, 80);
        creatures[y*40+x] = new Creature(y*40+x+1, new ArrayList<Node>(nodes), new ArrayList<Muscle>(muscles), 0, true, heartbeat, 1.0);
        drawCreature(creatures[y*40+x], x*3+5.5, y*2.5+3, 0);
        creatures[y*40+x].checkForOverlap();
        creatures[y*40+x].checkForLoneNodes();
        creatures[y*40+x].checkForBadAxons();
      }
    }
    setMenu(3);
    popMatrix();
    noStroke();
    fill(100, 100, 200);
    rect(900, 664, 260, 40);
    fill(0);
    textAlign(CENTER);
    textFont(font, 24);
    text("Here are your 1000 randomly generated creatures!!!", windowWidth/2-200, 690);
    text("Back", windowWidth-250, 690);
  }
}

// The "Here are your 1000 randomly generated creatures!!!" screen with a back button
// TODO: Try to merge this with Menu 2
class Menu3ViewController extends ViewController {
  void mouseReleased() {
    // back button
    if (abs(actualMouseX()-1030) <= 130 && abs(actualMouseY()-684) <= 20) {
      gen = 0;
      setMenu(1);
    }
  }

  void draw() {
  }
}

static int fastSimulations = 0;
static double averageTimeForSimulations = 0.0;

// Segues to Menu5ViewController, Menu6ViewController
class Menu4ViewController extends ViewController {
  void mouseReleased() {
    if (actualMouseY() >= windowHeight-40) {
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
    }
  }

  void newDraw() {
    setGlobalVariables(creatures[creaturesTested]);
    camZoom = 0.01;
    setMenu(5);
    if (!stepbystepslow) {
      println("Starting fast simulation...");
      Date beforeSimulation = new Date();
      for (int i = 0; i < 1000; i++) {
        List<Creature> creaturesToSimulate = new ArrayList<Creature>();
        creaturesToSimulate.add(creatures[i]);
        List<SimulationResult> simResults = simulateCreaturesIn(creaturesToSimulate);
      }
      Date afterSimulation = new Date();
      long msForSimulation = afterSimulation.getTime() - beforeSimulation.getTime();
      println("Simulation took " + msForSimulation + "ms");
      ++fastSimulations;
      averageTimeForSimulations = (averageTimeForSimulations * (fastSimulations - 1) + msForSimulation) / fastSimulations;
      println("Average sim time is " + averageTimeForSimulations + "ms");

      setMenu(6);
    }
  }

  void oldDraw() {
    setGlobalVariables(creatures[creaturesTested]);
    camZoom = 0.01;
    setMenu(5);
    if (!stepbystepslow) {
      println("Starting fast simulation...");
      Date beforeSimulation = new Date();
      for (int i = 0; i < 1000; i++) {
            println("simulating creature " + creatures[i].id);

        setGlobalVariables(creatures[i]);
        for (int s = 0; s < 900; s++) {
          simulate();
        }
        setAverages();
        setFitness(i);
        println("creature " + i + " fitness: " + creatures[i].simulatedFitness);

      }
      Date afterSimulation = new Date();
      long msForSimulation = afterSimulation.getTime() - beforeSimulation.getTime();
      println("Simulation took " + msForSimulation + "ms");
      ++fastSimulations;
      averageTimeForSimulations = (averageTimeForSimulations * (fastSimulations - 1) + msForSimulation) / fastSimulations;
      println("Average sim time is " + averageTimeForSimulations + "ms");

      setMenu(6);
    }
  }
  
  void draw() {
    //oldDraw();
    newDraw();
  }
}

// Shows full screen running simulation for 1 creature
// Segues to Menu4ViewController, Menu6ViewController
class Menu5ViewController extends ViewController {
  void mouseReleased() {
    if (actualMouseY() >= windowHeight-40) {
      if (actualMouseX() < 90) { // Skip button?
        for (int s = timer; s < 900; s++) {
          simulate();
        }
        timer = 1021;
      } else if (actualMouseX() >= 120 && actualMouseX() < 360) { // Speed button
        speed *= 2;
        if (speed == 1024) speed = 900;
        if (speed >= 1800) speed = 1;
      } else if (actualMouseX() >= windowWidth-120) { // Finish Button?
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
    }
  }

  void draw() { //simulate running
    // TODO: Make the timer an instance variable/ non-global
    if (timer <= 900) {
      background(120, 200, 255);
      for (int s = 0; s < speed; s++) {
        if (timer < 900) {
          simulate();
        }
      }
      setAverages();
      if (speed < 30) {
        for (int s = 0; s < speed; s++) {
          camX += (averageX-camX)*0.06;
          camY += (averageY-camY)*0.06;
        }
      } else {
        camX = averageX;
        camY = averageY;
      }
      pushMatrix();
      translate(width/2.0, height/2.0);
      scale(1.0/camZoom/scaleToFixBug);
      translate(-camX*scaleToFixBug, -camY*scaleToFixBug);

      drawPosts(0);
      drawGround(0);
      drawCreaturePieces(nodes, muscles, 0, 0, 0);
      drawArrow(averageX);
      popMatrix();
      drawStats(windowWidth-10, 0, 0.7);
      drawSkipButton();
      drawOtherButtons();
    }
    if (timer == 900) {
      if (speed < 30) {
        noStroke();
        fill(0, 0, 0, 130);
        rect(0, 0, windowWidth, windowHeight);
        fill(0, 0, 0, 255);
        rect(windowWidth/2-500, 200, 1000, 240);
        fill(255, 0, 0);
        textAlign(CENTER);
        textFont(font, 96);
        text("Creature's "+fitnessName+":", windowWidth/2, 300);
        text(nf(averageX*0.2, 0, 2) + " "+fitnessUnit, windowWidth/2, 400);
      } else {
        timer = 1020;
      }
      setFitness(creaturesTested);
    }
    if (timer >= 1020) {
      setMenu(4);
      creaturesTested++;
      if (creaturesTested == 1000) {
        setMenu(6);
      }
      camX = 0;
    }
    if (timer >= 900) {
      timer += speed;
    }
  }

  void mouseWheel(MouseEvent event) {
    float delta = event.getCount();
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

// Segues to menu 7 and 10
class Menu6ViewController extends ViewController {
  void draw() {
    //sort
    creatures2 = new ArrayList<Creature>(0);
    for (int i = 0; i < 1000; i++) {
      creatures2.add(creatures[i]);
    }
    creatures2 = quickSort(creatures2);
    percentile.add(new Float[29]);
    for (int i = 0; i < 29; i++) {
      percentile.get(gen+1)[i] = creatures2.get(p[i]).simulatedFitness;
    }
    creatureDatabase.add(creatures2.get(999).copyCreature(-1));
    creatureDatabase.add(creatures2.get(499).copyCreature(-1));
    creatureDatabase.add(creatures2.get(0).copyCreature(-1));

    Integer[] beginBar = new Integer[barLen];
    for (int i = 0; i < barLen; i++) {
      beginBar[i] = 0;
    }
    barCounts.add(beginBar);
    Integer[] beginSpecies = new Integer[101];
    for (int i = 0; i < 101; i++) {
      beginSpecies[i] = 0;
    }
    for (int i = 0; i < 1000; i++) {
      int bar = floor(creatures2.get(i).simulatedFitness*histBarsPerMeter-minBar);
      if (bar >= 0 && bar < barLen) {
        barCounts.get(gen+1)[bar]++;
      }
      int species = (creatures2.get(i).n.size()%10)*10+creatures2.get(i).m.size()%10;
      beginSpecies[species]++;
    }
    speciesCounts.add(new Integer[101]);
    speciesCounts.get(gen+1)[0] = 0;
    int cum = 0;
    int record = 0;
    int holder = 0;
    for (int i = 0; i < 100; i++) {
      cum += beginSpecies[i];
      speciesCounts.get(gen+1)[i+1] = cum;
      if (beginSpecies[i] > record) {
        record = beginSpecies[i];
        holder = i;
      }
    }
    topSpeciesCounts.add(holder);
    if (stepbystep) {
      drawScreenImage(0);
      setMenu(7);
    } else {
      setMenu(10);
    }
  }
}

// Segues to menu 8
class Menu7ViewController extends ViewController {
  void mouseReleased() {
    if (abs(actualMouseX()-1030) <= 130 && abs(actualMouseY()-684) <= 20) { // Sort button?
      setMenu(8);
    }
  }

  void draw() {
  }
}

// Performs the creature sort animation
// Segues to Menu 9
class Menu8ViewController extends ViewController {
  void mouseReleased() {
    if (actualMouseX() < 90 && actualMouseY() >= windowHeight-40) { // Skip button
      timer = 100000;
    }
  }

  void draw() {
    //cool sorting animation
    background(220, 253, 102);
    pushMatrix();
    scale(10.0/scaleToFixBug);
    float transition = 0.5-0.5*cos(min(float(timer)/60, PI));
    for (int j = 0; j < 1000; j++) {
      Creature cj = creatures2.get(j);
      int j2 = cj.id-(gen*1000)-1;
      int x1 = j2%40;
      int y1 = floor(j2/40);
      int x2 = j%40;
      int y2 = floor(j/40)+1;
      float x3 = inter(x1, x2, transition);
      float y3 = inter(y1, y2, transition);
      drawCreature(cj, x3*3+5.5, y3*2.5+4, 0);
    }
    popMatrix();
    if (stepbystepslow) {
      timer+=2;
    } else {
      timer+=10;
    }
    drawSkipButton();
    if (timer > 60*PI) {
      drawScreenImage(1);
      setMenu(9);
    }
  }
}

// Shows the Kill 500 button?
class Menu9ViewController extends ViewController {
  void mouseReleased() {
    if (abs(actualMouseX()-1030) <= 130 && abs(actualMouseY()-690) <= 20) {
      setMenu(10);
    }
  }

  void draw() {
  }
}

// Segues to menu 11 and 12
class Menu10ViewController extends ViewController {
  void draw() {
    //Kill!
    for (int j = 0; j < 500; j++) {
      float f = float(j)/1000;
      float rand = (pow(random(-1, 1), 3)+1)/2; //cube function
      slowDies = (f <= rand);
      int j2;
      int j3;
      if (slowDies) {
        j2 = j;
        j3 = 999-j;
      } else {
        j2 = 999-j;
        j3 = j;
      }
      Creature cj = creatures2.get(j2);
      cj.alive = true;
      Creature ck = creatures2.get(j3);
      ck.alive = false;
    }
    if (stepbystep) {
      drawScreenImage(2);
      setMenu(11);
    } else {
      setMenu(12);
    }
  }
}

class Menu11ViewController extends ViewController {
  void mouseReleased() {
    if (abs(actualMouseX()-1130) <= 80 && abs(actualMouseY()-690) <= 20) { // Reproduce button?
      setMenu(12);
    }
  }

  void draw() {
  }
}

class Menu12ViewController extends ViewController {
  void draw() { //Reproduce and mutate
    justGotBack = true;
    for (int j = 0; j < 500; j++) {
      int j2 = j;
      if (!creatures2.get(j).alive) j2 = 999-j;
      Creature cj = creatures2.get(j2);
      Creature cj2 = creatures2.get(999-j2);

      creatures2.set(j2, cj.copyCreature(cj.id+1000));        //duplicate

      creatures2.set(999-j2, cj.modified(cj2.id+1000));   //mutated offspring 1
      nodes = creatures2.get(999-j2).n;
      muscles = creatures2.get(999-j2).m;
      toStableConfiguration(nodes.size(), muscles.size());
      adjustToCenter(nodes.size());
    }
    for (int j = 0; j < 1000; j++) {
      Creature cj = creatures2.get(j);
      creatures[cj.id-(gen*1000)-1001] = cj.copyCreature(-1);
    }
    drawScreenImage(3);
    gen++;
    if (stepbystep) {
      setMenu(13);
    } else {
      setMenu(1);
    }
  }
}

class Menu13ViewController extends ViewController {
  void mouseReleased() {
    if (abs(actualMouseX()-1130) <= 80 && abs(actualMouseY()-690) <= 20) { // Back button
      setMenu(1);
    }
  }

  void draw() {
  }
}

class PostDrawViewController extends ViewController {
  void draw() {
    noStroke();
    if (gen >= 1) {
      textAlign(CENTER);
      if (gen >= 5) {
        genSelected = round((sliderX-760)*(gen-1)/410)+1;
      } else {
        genSelected = round((sliderX-760)*gen/410);
      }
      if (drag) sliderX = min(max(sliderX+(actualMouseX()-25-sliderX)*0.2, 760), 1170);
      fill(100);
      rect(760, 340, 460, 50);
      fill(220);
      rect(sliderX, 340, 50, 50);
      int fs = 0;
      if (genSelected >= 1) {
        fs = floor(log(genSelected)/log(10));
      }
      fontSize = fontSizes[fs];
      textFont(font, fontSize);
      fill(0);
      text(genSelected, sliderX+25, 366+fontSize*0.3333);
    }
    if (genSelected >= 1) {
      textAlign(CENTER);
      for (int k = 0; k < 3; k++) {
        fill(220);
        rect(760+k*160, 180, 140, 140);
        pushMatrix();
        translate(830+160*k, 290);
        scale(60.0/scaleToFixBug);
        drawCreature(creatureDatabase.get((genSelected-1)*3+k), 0, 0, 0);
        popMatrix();
      }
      fill(0);
      textFont(font, 16);
      text("Worst Creature", 830, 310);
      text("Median Creature", 990, 310);
      text("Best Creature", 1150, 310);
    }
    if (justGotBack) justGotBack = false;
  }
}