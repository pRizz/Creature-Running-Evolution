
abstract class ViewController {
  abstract void draw();
}

ViewController rootViewController = new RootViewController(); // Singleton

class RootViewController extends ViewController {
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
    float mX = mouseX/windowSizeMultiplier;
    ;
    float mY = mouseY/windowSizeMultiplier;
    ;
    prevStatusWindow = statusWindow;
    if (abs(menu-9) <= 2 && gensToDo == 0 && !drag) {
      if (abs(mX-639.5) <= 599.5) {
        if (menu == 7 && abs(mY-329) <= 312) {
          statusWindow = creaturesInPosition[floor((mX-40)/30)+floor((mY-17)/25)*40];
        } else if (menu >= 9 && abs(mY-354) <= 312) {
          statusWindow = floor((mX-40)/30)+floor((mY-42)/25)*40;
        } else {
          statusWindow = -4;
        }
      } else {
        statusWindow = -4;
      }
    } else if (menu == 1 && genSelected >= 1 && gensToDo == 0 && !drag) {
      statusWindow = -4;
      if (abs(mY-250) <= 70) {
        if (abs(mX-990) <= 230) {
          float modX = (mX-760)%160;
          if (modX < 140) {
            statusWindow = floor((mX-760)/160)-3;
          }
        }
      }
    } else {
      statusWindow = -4;
    }
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
      mX = mouseX/windowSizeMultiplier;
      ;
      mY = mouseY/windowSizeMultiplier;
      ;
      noStroke();
      if (gen >= 1) {
        textAlign(CENTER);
        if (gen >= 5) {
          genSelected = round((sliderX-760)*(gen-1)/410)+1;
        } else {
          genSelected = round((sliderX-760)*gen/410);
        }
        if (drag) sliderX = min(max(sliderX+(mX-25-sliderX)*0.2, 760), 1170);
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
    if (statusWindow >= -3) {
      drawStatusWindow(prevStatusWindow == -4);
      if (statusWindow >= -3 && !miniSimulation) {
        openMiniSimulation();
      }
    }
    /*if(menu >= 1){
     fill(255);
     rect(0,705,100,15);
     fill(0);
     textAlign(LEFT);
     textFont(font,12);
     int g = gensToDo;
     if(gensToDo >= 10000){
     g = 1000000000-gensToDo;
     }
     text(g,2,715);
     }*/
    overallTimer++;
  }
}

// Menu 0
class IntroViewController extends ViewController {
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

// Menu 1
class MainViewController extends ViewController {
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
      rect(760, 20, 460, 40);
      rect(760, 70, 460, 40);
      rect(760, 120, 230, 40);
      if (gensToDo >= 2) {
        fill(128, 255, 128);
      } else {
        fill(70, 140, 70);
      }
      rect(990, 120, 230, 40);
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

class Menu2ViewController extends ViewController {
  void draw() {
    creatures = 0;
    background(220, 253, 102);
    pushMatrix();
    scale(10.0/scaleToFixBug);
    for (int y = 0; y < 25; y++) {
      for (int x = 0; x < 40; x++) {
        nodes.clear();
        m.clear();
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
          float s = 0.8;
          if (i >= 10) {
            s *= 1.414;
          }
          float len = random(0.5, 1.5);
          m.add(new Muscle(taxon, tc1, tc2, len, random(0.02, 0.08)));
        }
        toStableConfiguration(nodeNum, muscleNum);
        adjustToCenter(nodeNum);
        float heartbeat = random(40, 80);
        c[y*40+x] = new Creature(y*40+x+1, new ArrayList<Node>(nodes), new ArrayList<Muscle>(m), 0, true, heartbeat, 1.0);
        drawCreature(c[y*40+x], x*3+5.5, y*2.5+3, 0);
        c[y*40+x].checkForOverlap();
        c[y*40+x].checkForLoneNodes();
        c[y*40+x].checkForBadAxons();
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

class Menu4ViewController extends ViewController {
  void draw() {
    setGlobalVariables(c[creaturesTested]);
    camZoom = 0.01;
    setMenu(5);
    if (!stepbystepslow) {
      for (int i = 0; i < 1000; i++) {
        setGlobalVariables(c[i]);
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

class Menu5ViewController extends ViewController {
  void draw() { //simulate running
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
      drawCreaturePieces(nodes, m, 0, 0, 0);
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
}

class Menu6ViewController extends ViewController {
  void draw() {
    //sort
    c2 = new ArrayList<Creature>(0);
    for (int i = 0; i < 1000; i++) {
      c2.add(c[i]);
    }
    c2 = quickSort(c2);
    percentile.add(new Float[29]);
    for (int i = 0; i < 29; i++) {
      percentile.get(gen+1)[i] = c2.get(p[i]).d;
    }
    creatureDatabase.add(c2.get(999).copyCreature(-1));
    creatureDatabase.add(c2.get(499).copyCreature(-1));
    creatureDatabase.add(c2.get(0).copyCreature(-1));

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
      int bar = floor(c2.get(i).d*histBarsPerMeter-minBar);
      if (bar >= 0 && bar < barLen) {
        barCounts.get(gen+1)[bar]++;
      }
      int species = (c2.get(i).n.size()%10)*10+c2.get(i).m.size()%10;
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

class Menu8ViewController extends ViewController {
  void draw() {
    //cool sorting animation
    background(220, 253, 102);
    pushMatrix();
    scale(10.0/scaleToFixBug);
    float transition = 0.5-0.5*cos(min(float(timer)/60, PI));
    for (int j = 0; j < 1000; j++) {
      Creature cj = c2.get(j);
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
      Creature cj = c2.get(j2);
      cj.alive = true;
      Creature ck = c2.get(j3);
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

class Menu12ViewController extends ViewController {
  void draw() { //Reproduce and mutate
    justGotBack = true;
    for (int j = 0; j < 500; j++) {
      int j2 = j;
      if (!c2.get(j).alive) j2 = 999-j;
      Creature cj = c2.get(j2);
      Creature cj2 = c2.get(999-j2);

      c2.set(j2, cj.copyCreature(cj.id+1000));        //duplicate

      c2.set(999-j2, cj.modified(cj2.id+1000));   //mutated offspring 1
      nodes = c2.get(999-j2).n;
      m = c2.get(999-j2).m;
      toStableConfiguration(nodes.size(), m.size());
      adjustToCenter(nodes.size());
    }
    for (int j = 0; j < 1000; j++) {
      Creature cj = c2.get(j);
      c[cj.id-(gen*1000)-1001] = cj.copyCreature(-1);
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