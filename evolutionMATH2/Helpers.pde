
float inter(int a, int b, float offset) {
  return float(a)+(float(b)-float(a))*offset;
}

float r() {
  return pow(random(-1, 1), 19);
}

int rInt() {
  return int(random(-0.01, 1.01));
}

int getNewMuscleAxon(int nodeNum) {
  if (random(0, 1) < 0.5) {
    return int(random(0, nodeNum));
  } else {
    return -1;
  }
}

float toMuscleUsable(float f) {
  return min(max(f, 0.5), 1.5);
}

color getColor(int i, boolean adjust) {
  colorMode(HSB, 1.0);
  float col = (i*1.618034)%1;
  if (i == 46) {
    col = 0.083333;
  }
  float light = 1.0;
  if (abs(col-0.333) <= 0.18 && adjust) {
    light = 0.7;
  }
  return color(col, 1.0, light);
}

float extreme(float sign) {
  float record = -sign;
  for (int i = 0; i < gen; i++) {
    float toTest = percentile.get(i+1)[int(14-sign*14)];
    if (toTest*sign > record*sign) {
      record = toTest;
    }
  }
  return record;
}

float setUnit(float best, float worst) {
  float unit2 = 3*log(best-worst)/log(10)-2;
  if ((unit2+90)%3 < 1) {
    return pow(10, floor(unit2/3));
  } else if ((unit2+90)%3 < 2) {
    return pow(10, floor((unit2-1)/3))*2;
  } else {
    return pow(10, floor((unit2-2)/3))*5;
  }
}

String showUnit(float i, float unit) {
  if (unit < 1) {
    return nf(i, 0, 2)+"";
  } else {
    return int(i)+"";
  }
}

ArrayList<Creature> quickSort(ArrayList<Creature> c) {
  if (c.size() <= 1) {
    return c;
  } else {
    ArrayList<Creature> less = new ArrayList<Creature>();
    ArrayList<Creature> more = new ArrayList<Creature>();
    ArrayList<Creature> equal = new ArrayList<Creature>();
    Creature c0 = c.get(0);
    equal.add(c0);
    for (int i = 1; i < c.size(); i++) {
      Creature ci = c.get(i);
      if (ci.simulatedFitness == c0.simulatedFitness) {
        equal.add(ci);
      } else if (ci.simulatedFitness < c0.simulatedFitness) {
        less.add(ci);
      } else {
        more.add(ci);
      }
    }
    ArrayList<Creature> total = new ArrayList<Creature>();
    total.addAll(quickSort(more));
    total.addAll(equal);
    total.addAll(quickSort(less));
    return total;
  }
}

void toStableConfiguration(int nodeNum, int muscleNum) {
  for (int j = 0; j < 200; j++) {
    for (int i = 0; i < muscleNum; i++) {
      muscles.get(i).applyForce(nodes);
    }
    for (int i = 0; i < nodeNum; i++) {
      nodes.get(i).applyForces();
    }
  }
  for (int i = 0; i < nodeNum; i++) {
    Node ni = nodes.get(i);
    ni.vx = 0;
    ni.vy = 0;
  }
}

void adjustToCenter(int nodeNum) {
  float avx = 0;
  float lowY = -1000;
  for (int i = 0; i < nodeNum; i++) {
    Node ni = nodes.get(i);
    avx += ni.x;
    if (ni.y+ni.m/2 > lowY) {
      lowY = ni.y+ni.m/2;
    }
  }
  avx /= nodeNum;
  for (int i = 0; i < nodeNum; i++) {
    Node ni = nodes.get(i);
    ni.x -= avx;
    ni.y -= lowY;
  }
}

void simulate() {
  for (int i = 0; i < muscles.size(); i++) {
    muscles.get(i).applyForce(nodes);
  }
  for (int i = 0; i < nodes.size(); i++) {
    Node ni = nodes.get(i);
    ni.applyGravity();
    ni.applyForces();
    ni.hitWalls();
    ni.doMath(nodes);
  }
  for (int i = 0; i < nodes.size(); i++) {
    nodes.get(i).realizeMathValues();
  }
  averageNodeNausea = totalNodeNausea/nodes.size();
  simulationTimer++;
  timer++;
}

// FIXME
SimulationResult simulateCreatureRefactored(Creature creature, float totalNodeNausea, int simulationTimer, int timer) {
  ArrayList<Muscle> muscles = creature.m;
  ArrayList<Node> nodes = creature.n;
  
  for (Muscle muscle : muscles) {
    muscle.applyForce(nodes);
  }
  for (Node node : nodes) {
    node.applyGravity();
    totalNodeNausea += node.applyForcesRefactored(totalNodeNausea);
    node.hitWalls();
    node.doMathRefactored(nodes, simulationTimer);
  }
  for (Node node : nodes) {
    node.realizeMathValues();
  }
  return new SimulationResult(totalNodeNausea/nodes.size(), simulationTimer + 1, timer + 1, totalNodeNausea);
}

List<SimulationResult> simulateCreaturesIn(List<Creature> creatures) {
  List<SimulationResult> simulationResults = new ArrayList<SimulationResult>();
  for (Creature creature : creatures) {
    float totalNodeNausea = 0;
    int simulationTimer = 0;
    int timer = 0;
    Creature creatureCopy = creature.copyCreature();
    for (int s = 0; s < 900; ++s) {
      SimulationResult simResult = simulateCreatureRefactored(creatureCopy, totalNodeNausea, simulationTimer, timer);
      totalNodeNausea = simResult.totalNodeNausea;
      simulationTimer = simResult.simulationTimer;
      timer = simResult.timer;
      //simulationResults.add(simResult);
    }
    creature.simulatedFitness = creatureCopy.getFitness();
  }
  return simulationResults;
}

void setAverages() {
  averageX = 0;
  averageY = 0;
  for (int i = 0; i < nodes.size(); i++) {
    Node ni = nodes.get(i);
    averageX += ni.x;
    averageY += ni.y;
  }
  averageX = averageX/nodes.size();
  averageY = averageY/nodes.size();
}

void openMiniSimulation() {
  simulationTimer = 0;
  if (gensToDo == 0) {
    miniSimulation = true;
    int id;
    Creature cj;
    if (statusWindow <= -1) {
      cj = creatureDatabase.get((genSelected-1)*3+statusWindow+3);
      id = cj.id;
    } else {
      id = statusWindow;
      cj = creatures2.get(id);
    }
    setGlobalVariables(cj);
    creatureWatching = id;
  }
}

void setMenu(int m) {
  menu = m;

  // TODO: Refactor such that setMenu will be replaced by just rootViewController.presentViewController(...)
  if (menu == 0) {
    rootViewController.presentViewController(new IntroViewController());
  } else if (menu == 1) {
    rootViewController.presentViewController(new MainViewController());
  } else if (menu == 2) {
    rootViewController.presentViewController(new Menu2ViewController());
  } else if (menu == 3) {
    rootViewController.presentViewController(new Menu3ViewController());
  } else if (menu == 4) {
    rootViewController.presentViewController(new Menu4ViewController());
  } else if (menu == 5) {
    rootViewController.presentViewController(new Menu5ViewController());
  } else if (menu == 6) {
    rootViewController.presentViewController(new Menu6ViewController());
  } else if (menu == 7) {
    rootViewController.presentViewController(new Menu7ViewController());
  } else if (menu == 8) {
    rootViewController.presentViewController(new Menu8ViewController());
  } else if (menu == 9) {
    rootViewController.presentViewController(new Menu9ViewController());
  } else if (menu == 10) {
    rootViewController.presentViewController(new Menu10ViewController());
  } else if (menu == 11) {
    rootViewController.presentViewController(new Menu11ViewController());
  } else if (menu == 12) {
    rootViewController.presentViewController(new Menu12ViewController());
  } else if (menu == 13) {
    rootViewController.presentViewController(new Menu13ViewController());
  }
}

String zeros(int n, int zeros) {
  String s = n+"";
  for (int i = s.length(); i < zeros; ++i) {
    s = "0"+s;
  }
  return s;
}

void startASAP() {
  setMenu(4);
  creaturesTested = 0;
  stepbystep = false;
  stepbystepslow = false;
}

void setGlobalVariables(Creature thisCreature) {
  nodes.clear();
  muscles.clear();
  for (int i = 0; i < thisCreature.n.size(); i++) {
    nodes.add(thisCreature.n.get(i).copyNode());
  }
  for (int i = 0; i < thisCreature.m.size(); i++) {
    muscles.add(thisCreature.m.get(i).copyMuscle());
  }
  id = thisCreature.id;
  timer = 0;
  camZoom = 0.01;
  camX = 0;
  camY = 0;
  cTimer = thisCreature.creatureTimer;
  simulationTimer = 0;
  energy = baselineEnergy;
  totalNodeNausea = 0;
  averageNodeNausea = 0;
}

void setFitness(int i) {
  creatures[i].simulatedFitness = averageX*0.2; // Multiply by 0.2 because a meter is 5 units for some weird reason.
}

void setFitnessRefactored(int creatureIndex, float fitness) {
  creatures[creatureIndex].simulatedFitness = fitness; // Multiply by 0.2 because a meter is 5 units for some weird reason.
}

float actualMouseX() {
  return mouseX/windowSizeMultiplier;
}

float actualMouseY() {
  return mouseY/windowSizeMultiplier;
}

int calculateNextStatusWindow() {
  int statusWindow = -4;
  if (!(gensToDo == 0 && !drag)) { // guard
    return statusWindow;
  }

  // mouseY at 329 +- 312 -> (17...641)?
  if (menu == 7 && abs(actualMouseX()-639.5) <= 599.5 && abs(actualMouseY()-329) <= 312) {
    // 40 -> 0, 70 -> 1, etc...
    int floor1 = floor((actualMouseX()-40)/30);
    // 17 -> 0, 42 -> 1, etc...
    int floor2 = floor((actualMouseY()-17)/25);
    statusWindow = creaturesInPosition[floor1+floor2*40];
  }

  // mouseX (40...1240)?
  if (menu >= 9 && menu <= 11 && abs(actualMouseX()-639.5) <= 599.5 && abs(actualMouseY()-354) <= 312) { // mouseY in 354 +- 312 -> (...)
    statusWindow = floor((actualMouseX()-40)/30)+floor((actualMouseY()-42)/25)*40; // buggy?
  }

  if (menu == 1 && genSelected >= 1 && abs(actualMouseY()-250) <= 70 && abs(actualMouseX()-990) <= 230) {
    float modX = (actualMouseX()-760)%160;
    if (modX < 140) {
      statusWindow = floor((actualMouseX()-760)/160)-3;
    }
  }

  return statusWindow;
}