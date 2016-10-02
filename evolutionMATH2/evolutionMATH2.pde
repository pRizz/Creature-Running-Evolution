/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/377698*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
final float windowSizeMultiplier = 0.8;
final int SEED = 0;

PFont font;
ArrayList<Float[]> percentile = new ArrayList<Float[]>(0);
ArrayList<Integer[]> barCounts = new ArrayList<Integer[]>(0);
ArrayList<Integer[]> speciesCounts = new ArrayList<Integer[]>(0);
ArrayList<Integer> topSpeciesCounts = new ArrayList<Integer>(0);
ArrayList<Creature> creatureDatabase = new ArrayList<Creature>(0);
ArrayList<Rectangle> rects = new ArrayList<Rectangle>(0);
PGraphics graphImage;
PGraphics screenImage;
PGraphics popUpImage;
PGraphics segBarImage;
boolean haveGround = true;
int histBarsPerMeter = 5;
String[] operationNames = {"#", "time", "px", "py", "+", "-", "*", "÷", "%", "sin", "sig", "pres"};
int[] operationAxons =    {0, 0, 0, 0, 2, 2, 2, 2, 2, 1, 1, 0};
int operationCount = 12;
String fitnessUnit = "m";
String fitnessName = "Distance";
float baselineEnergy = 0.0;
int energyDirection = 1; // if 1, it'll count up how much energy is used.  if -1, it'll count down from the baseline energy, and when energy hits 0, the creature dies.
final float FRICTION = 4;
float bigMutationChance = 0.06;
float hazelStairs = -1;
boolean saveFramesPerGeneration = true;

int lastImageSaved = -1;
float pressureUnit = 500.0/2.37;
float energyUnit = 20;
float nauseaUnit = 5;
int minBar = -10;
int maxBar = 100;
int barLen = maxBar-minBar;
int gensToDo = 0;
float cTimer = 60;
float postFontSize = 0.96;
float scaleToFixBug = 1000;
float energy = 0;
float averageNodeNausea = 0;
float totalNodeNausea = 0;

float lineY1 = -0.08; // These are for the lines of text on each node.
float lineY2 = 0.35;
color axonColor = color(255, 255, 0);

int windowWidth = 1280;
int windowHeight = 720;
int timer = 0;
float camX = 0;
float camY = 0;
int frames = 60;
int menu = 0;
int gen = -1;
float sliderX = 1170;
int genSelected = 0;
boolean drag = false;
boolean justGotBack = false;
int creatures = 0;
int creaturesTested = 0;
int fontSize = 0;
int[] fontSizes = {
  50, 36, 25, 20, 16, 14, 11, 9
};
int statusWindow = -4;
int prevStatusWindow = -4;
int overallTimer = 0;
boolean miniSimulation = false;
int creatureWatching = 0;
int simulationTimer = 0;
int[] creaturesInPosition = new int[1000];

float camZoom = 0.015;
float gravity = 0.005;
float airFriction = 0.95;

float target;
float force;
float averageX;
float averageY;
int speed;
int id;
boolean stepbystep;
boolean stepbystepslow;
boolean slowDies;
int timeShow;

int[] p = {
  0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 
  100, 200, 300, 400, 500, 600, 700, 800, 900, 910, 920, 930, 940, 950, 960, 970, 980, 990, 999
};

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

void drawGround(int toImage) {
  int stairDrawStart = max(1, (int)(-averageY/hazelStairs)-10);
  if (toImage == 0) {
    noStroke();    
    fill(0, 130, 0);
    if (haveGround) rect((camX-camZoom*800.0)*scaleToFixBug, 0*scaleToFixBug, (camZoom*1600.0)*scaleToFixBug, (camZoom*900.0)*scaleToFixBug);
    for (int i = 0; i < rects.size(); i++) {
      Rectangle r = rects.get(i);
      rect(r.x1*scaleToFixBug, r.y1*scaleToFixBug, (r.x2-r.x1)*scaleToFixBug, (r.y2-r.y1)*scaleToFixBug);
    }
    if (hazelStairs > 0) {
      for (int i = stairDrawStart; i < stairDrawStart+20; i++) {
        fill(255, 255, 255, 128);
        rect((averageX-20)*scaleToFixBug, -hazelStairs*i*scaleToFixBug, 40*scaleToFixBug, hazelStairs*0.3*scaleToFixBug);
        fill(255, 255, 255, 255);
        rect((averageX-20)*scaleToFixBug, -hazelStairs*i*scaleToFixBug, 40*scaleToFixBug, hazelStairs*0.15*scaleToFixBug);
      }
    }
  } else if (toImage == 2) {
    popUpImage.noStroke();
    popUpImage.fill(0, 130, 0);
    if (haveGround) popUpImage.rect((camX-camZoom*300.0)*scaleToFixBug, 0*scaleToFixBug, (camZoom*600.0)*scaleToFixBug, (camZoom*600.0)*scaleToFixBug);
    float ww = 450;
    float wh = 450;
    for (int i = 0; i < rects.size(); i++) {
      Rectangle r = rects.get(i);
      popUpImage.rect(r.x1*scaleToFixBug, r.y1*scaleToFixBug, (r.x2-r.x1)*scaleToFixBug, (r.y2-r.y1)*scaleToFixBug);
    }
    if (hazelStairs > 0) {
      for (int i = stairDrawStart; i < stairDrawStart+20; i++) {
        popUpImage.fill(255, 255, 255, 128);
        popUpImage.rect((averageX-20)*scaleToFixBug, -hazelStairs*i*scaleToFixBug, 40*scaleToFixBug, hazelStairs*0.3*scaleToFixBug);
        popUpImage.fill(255, 255, 255, 255);
        popUpImage.rect((averageX-20)*scaleToFixBug, -hazelStairs*i*scaleToFixBug, 40*scaleToFixBug, hazelStairs*0.15*scaleToFixBug);
      }
    }
  }
}

void drawNode(Node ni, float x, float y, int toImage) {
  color c = color(512-int(ni.f*512), 0, 0);
  if (ni.f <= 0.5) {
    c = color(255, 255-int(ni.f*512), 255-int(ni.f*512));
  }
  if (toImage == 0) {
    fill(c);
    noStroke();
    ellipse((ni.x+x)*scaleToFixBug, (ni.y+y)*scaleToFixBug, ni.m*scaleToFixBug, ni.m*scaleToFixBug);
    if (ni.f >= 0.5) {
      fill(255);
    } else {
      fill(0);
    }
    textAlign(CENTER);
    textFont(font, 0.4*ni.m*scaleToFixBug);
    text(nf(ni.value, 0, 2), (ni.x+x)*scaleToFixBug, (ni.y+ni.m*lineY2+y)*scaleToFixBug);
    text(operationNames[ni.operation], (ni.x+x)*scaleToFixBug, (ni.y+ni.m*lineY1+y)*scaleToFixBug);
  } else if (toImage == 1) {
    screenImage.fill(c);
    screenImage.noStroke();
    screenImage.ellipse((ni.x+x)*scaleToFixBug, (ni.y+y)*scaleToFixBug, ni.m*scaleToFixBug, ni.m*scaleToFixBug);
    if (ni.f >= 0.5) {
      screenImage.fill(255);
    } else {
      screenImage.fill(0);
    }
    screenImage.textAlign(CENTER);
    screenImage.textFont(font, 0.4*ni.m*scaleToFixBug);
    screenImage.text(nf(ni.value, 0, 2), (ni.x+x)*scaleToFixBug, (ni.y+ni.m*lineY2+y)*scaleToFixBug);
    screenImage.text(operationNames[ni.operation], (ni.x+x)*scaleToFixBug, (ni.y+ni.m*lineY1+y)*scaleToFixBug);
  } else if (toImage == 2) {
    popUpImage.fill(c);
    popUpImage.noStroke();
    popUpImage.ellipse((ni.x+x)*scaleToFixBug, (ni.y+y)*scaleToFixBug, ni.m*scaleToFixBug, ni.m*scaleToFixBug);
    if (ni.f >= 0.5) {
      popUpImage.fill(255);
    } else {
      popUpImage.fill(0);
    }
    popUpImage.textAlign(CENTER);
    popUpImage.textFont(font, 0.4*ni.m*scaleToFixBug);
    popUpImage.text(nf(ni.value, 0, 2), (ni.x+x)*scaleToFixBug, (ni.y+ni.m*lineY2+y)*scaleToFixBug);
    popUpImage.text(operationNames[ni.operation], (ni.x+x)*scaleToFixBug, (ni.y+ni.m*lineY1+y)*scaleToFixBug);
  }
}

void drawNodeAxons(ArrayList<Node> n, int i, float x, float y, int toImage) {
  Node ni = n.get(i);
  if (operationAxons[ni.operation] >= 1) {
    Node axonSource = n.get(n.get(i).axon1);
    float point1x = ni.x-ni.m*0.3+x;
    float point1y = ni.y-ni.m*0.3+y;
    float point2x = axonSource.x+x;
    float point2y = axonSource.y+axonSource.m*0.5+y;
    drawSingleAxon(point1x, point1y, point2x, point2y, toImage);
  }
  if (operationAxons[ni.operation] == 2) {
    Node axonSource = n.get(n.get(i).axon2);
    float point1x = ni.x+ni.m*0.3+x;
    float point1y = ni.y-ni.m*0.3+y;
    float point2x = axonSource.x+x;
    float point2y = axonSource.y+axonSource.m*0.5+y;
    drawSingleAxon(point1x, point1y, point2x, point2y, toImage);
  }
}

void drawSingleAxon(float x1, float y1, float x2, float y2, int toImage) {
  float arrowHeadSize = 0.1;
  float angle = atan2(y2-y1, x2-x1);
  if (toImage == 0) {
    stroke(axonColor);
    strokeWeight(0.03*scaleToFixBug);
    line(x1*scaleToFixBug, y1*scaleToFixBug, x2*scaleToFixBug, y2*scaleToFixBug);
    line(x1*scaleToFixBug, y1*scaleToFixBug, (x1+cos(angle+PI*0.25)*arrowHeadSize)*scaleToFixBug, (y1+sin(angle+PI*0.25)*arrowHeadSize)*scaleToFixBug);
    line(x1*scaleToFixBug, y1*scaleToFixBug, (x1+cos(angle+PI*1.75)*arrowHeadSize)*scaleToFixBug, (y1+sin(angle+PI*1.75)*arrowHeadSize)*scaleToFixBug);
    noStroke();
  } else if (toImage == 1) {
    screenImage.stroke(axonColor);
    screenImage.strokeWeight(0.03*scaleToFixBug);
    screenImage.line(x1*scaleToFixBug, y1*scaleToFixBug, x2*scaleToFixBug, y2*scaleToFixBug);
    screenImage.line(x1*scaleToFixBug, y1*scaleToFixBug, (x1+cos(angle+PI*0.25)*arrowHeadSize)*scaleToFixBug, (y1+sin(angle+PI*0.25)*arrowHeadSize)*scaleToFixBug);
    screenImage.line(x1*scaleToFixBug, y1*scaleToFixBug, (x1+cos(angle+PI*1.75)*arrowHeadSize)*scaleToFixBug, (y1+sin(angle+PI*1.75)*arrowHeadSize)*scaleToFixBug);
    popUpImage.noStroke();
  } else if (toImage == 2) {
    popUpImage.stroke(axonColor);
    popUpImage.strokeWeight(0.03*scaleToFixBug);
    popUpImage.line(x1*scaleToFixBug, y1*scaleToFixBug, x2*scaleToFixBug, y2*scaleToFixBug);
    popUpImage.line(x1*scaleToFixBug, y1*scaleToFixBug, (x1+cos(angle+PI*0.25)*arrowHeadSize)*scaleToFixBug, (y1+sin(angle+PI*0.25)*arrowHeadSize)*scaleToFixBug);
    popUpImage.line(x1*scaleToFixBug, y1*scaleToFixBug, (x1+cos(angle+PI*1.75)*arrowHeadSize)*scaleToFixBug, (y1+sin(angle+PI*1.75)*arrowHeadSize)*scaleToFixBug);
    popUpImage.noStroke();
  }
}

void drawMuscle(Muscle mi, ArrayList<Node> n, float x, float y, int toImage) {
  Node ni1 = n.get(mi.c1);
  Node ni2 = n.get(mi.c2);
  float w = 0.15;
  if (mi.axon >= 0 && mi.axon < n.size()) {
    w = toMuscleUsable(n.get(mi.axon).value)*0.15;
  }
  if (toImage == 0) {
    strokeWeight(w*scaleToFixBug);
    stroke(70, 35, 0, mi.rigidity*3000);
    line((ni1.x+x)*scaleToFixBug, (ni1.y+y)*scaleToFixBug, (ni2.x+x)*scaleToFixBug, (ni2.y+y)*scaleToFixBug);
  } else if (toImage == 1) {
    screenImage.strokeWeight(w*scaleToFixBug);
    screenImage.stroke(70, 35, 0, mi.rigidity*3000);
    screenImage.line((ni1.x+x)*scaleToFixBug, (ni1.y+y)*scaleToFixBug, (ni2.x+x)*scaleToFixBug, (ni2.y+y)*scaleToFixBug);
  } else if (toImage == 2) {
    popUpImage.strokeWeight(w*scaleToFixBug);
    popUpImage.stroke(70, 35, 0, mi.rigidity*3000);
    popUpImage.line((ni1.x+x)*scaleToFixBug, (ni1.y+y)*scaleToFixBug, (ni2.x+x)*scaleToFixBug, (ni2.y+y)*scaleToFixBug);
  }
}

void drawMuscleAxons(Muscle mi, ArrayList<Node> n, float x, float y, int toImage) {
  Node ni1 = n.get(mi.c1);
  Node ni2 = n.get(mi.c2);
  if (mi.axon >= 0 && mi.axon < n.size()) {
    Node axonSource = n.get(mi.axon);
    float muscleMidX = (ni1.x+ni2.x)*0.5+x;
    float muscleMidY = (ni1.y+ni2.y)*0.5+y;
    drawSingleAxon(muscleMidX, muscleMidY, axonSource.x+x, axonSource.y+axonSource.m*0.5+y, toImage);
    float averageMass = (ni1.m+ni2.m)*0.5;
    if (toImage == 0) {
      fill(axonColor);
      textAlign(CENTER);
      textFont(font, 0.4*averageMass*scaleToFixBug);
      text(nf(toMuscleUsable(n.get(mi.axon).value), 0, 2), muscleMidX*scaleToFixBug, muscleMidY*scaleToFixBug);
    } else if (toImage == 1) {
      screenImage.fill(axonColor);
      screenImage.textAlign(CENTER);
      screenImage.textFont(font, 0.4*averageMass*scaleToFixBug);
      screenImage.text(nf(toMuscleUsable(n.get(mi.axon).value), 0, 2), muscleMidX*scaleToFixBug, muscleMidY*scaleToFixBug);
    } else if (toImage == 2) {
      popUpImage.fill(axonColor);
      popUpImage.textAlign(CENTER);
      popUpImage.textFont(font, 0.4*averageMass*scaleToFixBug);
      popUpImage.text(nf(toMuscleUsable(n.get(mi.axon).value), 0, 2), muscleMidX*scaleToFixBug, muscleMidY*scaleToFixBug);
    }
  }
}

float toMuscleUsable(float f) {
  return min(max(f, 0.5), 1.5);
}

void drawPosts(int toImage) {
  int startPostY = min(-8, (int)(averageY/4)*4-4);
  if (toImage == 0) {
    noStroke();
    textAlign(CENTER);
    textFont(font, postFontSize*scaleToFixBug); 
    for (int postY = startPostY; postY <= startPostY+8; postY += 4) {
      for (int i = (int)(averageX/5-5); i <= (int)(averageX/5+5); i++) {
        fill(255);
        rect((i*5.0-0.1)*scaleToFixBug, (-3.0+postY)*scaleToFixBug, 0.2*scaleToFixBug, 3.0*scaleToFixBug);
        rect((i*5.0-1)*scaleToFixBug, (-3.0+postY)*scaleToFixBug, 2.0*scaleToFixBug, 1.0*scaleToFixBug);
        fill(120);
        textAlign(CENTER);
        text(i+" m", i*5.0*scaleToFixBug, (-2.17+postY)*scaleToFixBug);
      }
    }
  } else if (toImage == 2) {
    popUpImage.textAlign(CENTER);
    popUpImage.textFont(font, postFontSize*scaleToFixBug); 
    popUpImage.noStroke();
    for (int postY = startPostY; postY <= startPostY+8; postY += 4) {
      for (int i = (int)(averageX/5-5); i <= (int)(averageX/5+5); i++) {
        popUpImage.fill(255);
        popUpImage.rect((i*5-0.1)*scaleToFixBug, (-3.0+postY)*scaleToFixBug, 0.2*scaleToFixBug, 3*scaleToFixBug);
        popUpImage.rect((i*5-1)*scaleToFixBug, (-3.0+postY)*scaleToFixBug, 2*scaleToFixBug, 1*scaleToFixBug);
        popUpImage.fill(120);
        popUpImage.text(i+" m", i*5*scaleToFixBug, (-2.17+postY)*scaleToFixBug);
      }
    }
  }
}

void drawArrow(float x) {
  textAlign(CENTER);
  textFont(font, postFontSize*scaleToFixBug); 
  noStroke();
  fill(120, 0, 255);
  rect((x-1.7)*scaleToFixBug, -4.8*scaleToFixBug, 3.4*scaleToFixBug, 1.1*scaleToFixBug);
  beginShape();
  vertex(x*scaleToFixBug, -3.2*scaleToFixBug);
  vertex((x-0.5)*scaleToFixBug, -3.7*scaleToFixBug);
  vertex((x+0.5)*scaleToFixBug, -3.7*scaleToFixBug);
  endShape(CLOSE);
  fill(255);
  text((float(round(x*2))/10)+" m", x*scaleToFixBug, -3.91*scaleToFixBug);
}

void drawGraphImage() {
  image(graphImage, 50, 180, 650, 380);
  image(segBarImage, 50, 580, 650, 100);
  if (gen >= 1) {
    stroke(0, 160, 0, 255);
    strokeWeight(3);
    float genWidth = 590.0/gen;
    float lineX = 110+genSelected*genWidth;
    line(lineX, 180, lineX, 500+180);
    Integer[] s = speciesCounts.get(genSelected);
    textAlign(LEFT);
    textFont(font, 12);
    noStroke();
    for (int i = 1; i < 101; i++) {
      int c = s[i]-s[i-1];
      if (c >= 25) {
        float y = ((s[i]+s[i-1])/2)/1000.0*100+573;
        if (i-1 == topSpeciesCounts.get(genSelected)) {
          stroke(0);
          strokeWeight(2);
        } else {
          noStroke();
        }
        fill(255, 255, 255);
        rect(lineX+3, y, 56, 14);
        colorMode(HSB, 1.0);
        fill(getColor(i-1, true));
        text("S"+floor((i-1)/10)+""+((i-1)%10)+": "+c, lineX+5, y+11);
        colorMode(RGB, 255);
      }
    }
    noStroke();
  }
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

void drawGraph(int graphWidth, int graphHeight) { 
  graphImage.beginDraw();
  graphImage.smooth();
  graphImage.background(220);
  if (gen >= 1) {
    drawLines(90, int(graphHeight*0.05), graphWidth-90, int(graphHeight*0.9));
    drawSegBars(90, 0, graphWidth-90, 150);
  }
  graphImage.endDraw();
}

void drawLines(int x, int y, int graphWidth, int graphHeight) {
  float gh = float(graphHeight);
  float genWidth = float(graphWidth)/gen;
  float best = extreme(1);
  float worst = extreme(-1);
  float meterHeight = float(graphHeight)/(best-worst);
  float zero = (best/(best-worst))*gh;
  float unit = setUnit(best, worst);
  graphImage.stroke(150);
  graphImage.strokeWeight(2);
  graphImage.fill(150);
  graphImage.textFont(font, 18);
  graphImage.textAlign(RIGHT);
  for (float i = ceil((worst-(best-worst)/18.0)/unit)*unit; i < best+(best-worst)/18.0; i+=unit) {
    float lineY = y-i*meterHeight+zero;
    graphImage.line(x, lineY, graphWidth+x, lineY);
    graphImage.text(showUnit(i, unit)+" "+fitnessUnit, x-5, lineY+4);
  }
  graphImage.stroke(0);
  for (int i = 0; i < 29; i++) {
    int k;
    if (i == 28) {
      k = 14;
    } else if (i < 14) {
      k = i;
    } else {
      k = i+1;
    }
    if (k == 14) {
      graphImage.stroke(255, 0, 0, 255);
      graphImage.strokeWeight(5);
    } else {
      stroke(0);
      if (k == 0 || k == 28 || (k >= 10 && k <= 18)) {
        graphImage.strokeWeight(3);
      } else {
        graphImage.strokeWeight(1);
      }
    }
    for (int j = 0; j < gen; j++) {
      graphImage.line(x+j*genWidth, (-percentile.get(j)[k])*meterHeight+zero+y, 
        x+(j+1)*genWidth, (-percentile.get(j+1)[k])*meterHeight+zero+y);
    }
  }
}

void drawSegBars(int x, int y, int graphWidth, int graphHeight) {
  segBarImage.beginDraw();
  segBarImage.smooth();
  segBarImage.noStroke();
  segBarImage.colorMode(HSB, 1);
  segBarImage.background(0, 0, 0.5);
  float genWidth = float(graphWidth)/gen;
  int gensPerBar = floor(gen/500)+1;
  for (int i = 0; i < gen; i+=gensPerBar) {
    int i2 = min(i+gensPerBar, gen);
    float barX1 = x+i*genWidth;
    float barX2 = x+i2*genWidth;
    int cum = 0;
    for (int j = 0; j < 100; j++) {
      segBarImage.fill(getColor(j, false));
      segBarImage.beginShape();
      segBarImage.vertex(barX1, y+speciesCounts.get(i)[j]/1000.0*graphHeight);
      segBarImage.vertex(barX1, y+speciesCounts.get(i)[j+1]/1000.0*graphHeight);
      segBarImage.vertex(barX2, y+speciesCounts.get(i2)[j+1]/1000.0*graphHeight);
      segBarImage.vertex(barX2, y+speciesCounts.get(i2)[j]/1000.0*graphHeight);
      segBarImage.endShape();
    }
  }
  segBarImage.endDraw();
  colorMode(RGB, 255);
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
      if (ci.d == c0.d) {
        equal.add(ci);
      } else if (ci.d < c0.d) {
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
      muscles.get(i).applyForce(i, nodes);
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
    muscles.get(i).applyForce(i, nodes);
  }
  for (int i = 0; i < nodes.size(); i++) {
    Node ni = nodes.get(i);
    ni.applyGravity();
    ni.applyForces();
    ni.hitWalls();
    ni.doMath(i, nodes);
  }
  for (int i = 0; i < nodes.size(); i++) {
    nodes.get(i).realizeMathValues(i);
  }
  averageNodeNausea = totalNodeNausea/nodes.size();
  simulationTimer++;
  timer++;
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

ArrayList<Node> nodes = new ArrayList<Node>();
ArrayList<Muscle> muscles = new ArrayList<Muscle>();
Creature[] c = new Creature[1000];
ArrayList<Creature> c2 = new ArrayList<Creature>();

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
      cj = c2.get(id);
    }
    setGlobalVariables(cj);
    creatureWatching = id;
  }
}

void setMenu(int m) {
  menu = m;
  if (m == 1) {
    drawGraph(975, 570);
  }
}

String zeros(int n, int zeros) {
  String s = n+"";
  for (int i = s.length(); i < zeros; i++) {
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


void drawScreenImage(int stage) {
  screenImage.beginDraw();
  screenImage.pushMatrix();
  screenImage.scale(15.0/scaleToFixBug);
  screenImage.smooth();
  screenImage.background(220, 253, 102);
  screenImage.noStroke();
  for (int j = 0; j < 1000; j++) {
    Creature cj = c2.get(j);
    if (stage == 3) cj = c[cj.id-(gen*1000)-1001];
    int j2 = j;
    if (stage == 0) {
      j2 = cj.id-(gen*1000)-1;
      creaturesInPosition[j2] = j;
    }
    int x = j2%40;
    int y = floor(j2/40);
    if (stage >= 1) y++;
    drawCreature(cj, x*3+5.5, y*2.5+4, 1);
  }
  timer = 0;
  screenImage.popMatrix();
  screenImage.pushMatrix();
  screenImage.scale(1.5);

  screenImage.textAlign(CENTER);
  screenImage.textFont(font, 24);
  screenImage.fill(100, 100, 200);
  screenImage.noStroke();
  if (stage == 0) {
    screenImage.rect(900, 664, 260, 40);
    screenImage.fill(0);
    screenImage.text("All 1,000 creatures have been tested.  Now let's sort them!", windowWidth/2-200, 690);
    screenImage.text("Sort", windowWidth-250, 690);
  } else if (stage == 1) {
    screenImage.rect(900, 670, 260, 40);
    screenImage.fill(0);
    screenImage.text("Fastest creatures at the top!", windowWidth/2, 30);
    screenImage.text("Slowest creatures at the bottom. (Going backward = slow)", windowWidth/2-200, 700);
    screenImage.text("Kill 500", windowWidth-250, 700);
  } else if (stage == 2) {
    screenImage.rect(1050, 670, 160, 40);
    screenImage.fill(0);
    screenImage.text("Faster creatures are more likely to survive because they can outrun their predators.  Slow creatures get eaten.", windowWidth/2, 30);
    screenImage.text("Because of random chance, a few fast ones get eaten, while a few slow ones survive.", windowWidth/2-130, 700);
    screenImage.text("Reproduce", windowWidth-150, 700);
    for (int j = 0; j < 1000; j++) {
      Creature cj = c2.get(j);
      int x = j%40;
      int y = floor(j/40)+1;
      if (cj.alive) {
        drawCreature(cj, x*30+55, y*25+40, 0);
      } else {
        screenImage.rect(x*30+40, y*25+17, 30, 25);
      }
    }
  } else if (stage == 3) {
    screenImage.rect(1050, 670, 160, 40);
    screenImage.fill(0);
    screenImage.text("These are the 1000 creatures of generation #"+(gen+2)+".", windowWidth/2, 30);
    screenImage.text("What perils will they face?  Find out next time!", windowWidth/2-130, 700);
    screenImage.text("Back", windowWidth-150, 700);
  }
  screenImage.endDraw();
  screenImage.popMatrix();
}

void drawpopUpImage() {
  camZoom = 0.009;
  setAverages();
  camX += (averageX-camX)*0.1;
  camY += (averageY-camY)*0.1;
  popUpImage.beginDraw();
  popUpImage.smooth();

  popUpImage.pushMatrix();
  popUpImage.translate(225, 225);
  popUpImage.scale(1.0/camZoom/scaleToFixBug);
  popUpImage.translate(-camX*scaleToFixBug, -camY*scaleToFixBug);

  if (simulationTimer < 900) {
    popUpImage.background(120, 200, 255);
  } else {
    popUpImage.background(60, 100, 128);
  }
  drawPosts(2);
  drawGround(2);
  drawCreaturePieces(nodes, muscles, 0, 0, 2);
  popUpImage.noStroke();
  popUpImage.endDraw();
  popUpImage.popMatrix();
}

void drawCreature(Creature cj, float x, float y, int toImage) {
  for (int i = 0; i < cj.m.size(); i++) {
    drawMuscle(cj.m.get(i), cj.n, x, y, toImage);
  }
  for (int i = 0; i < cj.n.size(); i++) {
    drawNode(cj.n.get(i), x, y, toImage);
  }
  for (int i = 0; i < cj.m.size(); i++) {
    drawMuscleAxons(cj.m.get(i), cj.n, x, y, toImage);
  }
  for (int i = 0; i < cj.n.size(); i++) {
    drawNodeAxons(cj.n, i, x, y, toImage);
  }
}

void drawCreaturePieces(ArrayList<Node> n, ArrayList<Muscle> m, float x, float y, int toImage) {
  for (int i = 0; i < m.size(); i++) {
    drawMuscle(m.get(i), n, x, y, toImage);
  }
  for (int i = 0; i < n.size(); i++) {
    drawNode(n.get(i), x, y, toImage);
  }
  for (int i = 0; i < m.size(); i++) {
    drawMuscleAxons(m.get(i), n, x, y, toImage);
  }
  for (int i = 0; i < n.size(); i++) {
    drawNodeAxons(n, i, x, y, toImage);
  }
}

void drawHistogram(int x, int y, int hw, int hh) {
  int maxH = 1;
  for (int i = 0; i < barLen; i++) {
    if (barCounts.get(genSelected)[i] > maxH) {
      maxH = barCounts.get(genSelected)[i];
    }
  }
  fill(200);
  noStroke();
  rect(x, y, hw, hh);
  fill(0, 0, 0);
  float barW = (float)hw/barLen;
  float multiplier = (float)hh/maxH*0.9;
  textAlign(LEFT);
  textFont(font, 16);
  stroke(128);
  strokeWeight(2);
  int unit = 100;
  if (maxH < 300) unit = 50;
  if (maxH < 100) unit = 20;
  if (maxH < 50) unit = 10;
  for (int i = 0; i < hh/multiplier; i += unit) {
    float theY = y+hh-i*multiplier;
    line(x, theY, x+hw, theY);
    if (i == 0) theY -= 5;
    text(i, x+hw+5, theY+7);
  }
  textAlign(CENTER);
  for (int i = minBar; i <= maxBar; i += 10) {
    if (i == 0) {
      stroke(0, 0, 255);
    } else {
      stroke(128);
    }
    float theX = x+(i-minBar)*barW;
    text(nf((float)i/histBarsPerMeter, 0, 1), theX, y+hh+14);
    line(theX, y, theX, y+hh);
  }
  noStroke();
  for (int i = 0; i < barLen; i++) {
    float h = min(barCounts.get(genSelected)[i]*multiplier, hh);
    if (i+minBar == floor(percentile.get(min(genSelected, percentile.size()-1))[14]*histBarsPerMeter)) {
      fill(255, 0, 0);
    } else {
      fill(0, 0, 0);
    }
    rect(x+i*barW, y+hh-h, barW, h);
  }
}

void drawStatusWindow(boolean isFirstFrame) {
  int x, y, px, py;
  int rank = (statusWindow+1);
  Creature cj;
  stroke(abs(overallTimer%30-15)*17);
  strokeWeight(3);
  noFill();
  if (statusWindow >= 0) {
    cj = c2.get(statusWindow);
    if (menu == 7) {
      int id = ((cj.id-1)%1000);
      x = id%40;
      y = floor(id/40);
    } else {
      x = statusWindow%40;
      y = floor(statusWindow/40)+1;
    }
    px = x*30+55;
    py = y*25+10;
    if (px <= 1140) {
      px += 80;
    } else {
      px -= 80;
    }
    rect(x*30+40, y*25+17, 30, 25);
  } else {
    cj = creatureDatabase.get((genSelected-1)*3+statusWindow+3);
    x = 760+(statusWindow+3)*160;
    y = 180;
    px = x;
    py = y;
    rect(x, y, 140, 140);
    int[] ranks = {
      1000, 500, 1
    };
    rank = ranks[statusWindow+3];
  }
  noStroke();
  fill(255);
  rect(px-60, py, 120, 52);
  fill(0);
  textFont(font, 12);
  textAlign(CENTER);
  text("#"+rank, px, py+12);
  text("ID: "+cj.id, px, py+24);
  text("Fitness: "+nf(cj.d, 0, 3), px, py+36);
  colorMode(HSB, 1);
  int sp = (cj.n.size()%10)*10+(cj.m.size()%10);
  fill(getColor(sp, true));
  text("Species: S"+(cj.n.size()%10)+""+(cj.m.size()%10), px, py+48);
  colorMode(RGB, 255);
  if (miniSimulation) {
    int py2 = py-125;
    if (py >= 360) {
      py2 -= 180;
    } else {
      py2 += 180;
    }
    //py = min(max(py,0),420);
    int px2 = min(max(px-90, 10), 970);
    drawpopUpImage();
    image(popUpImage, px2, py2, 300, 300);

    /*fill(255, 255, 255);
     rect(px2+240, py2+10, 50, 30);
     rect(px2+10, py2+10, 100, 30);
     fill(0, 0, 0);
     textFont(font, 30);
     textAlign(RIGHT);
     text(int(simulationTimer/60), px2+285, py2+36);
     textAlign(LEFT);
     text(nf(averageX/5.0, 0, 3), px2+15, py2+36);*/
    drawStats(px2+295, py2, 0.45);

    simulate();
    int shouldBeWatching = statusWindow;
    if (statusWindow <= -1) {
      cj = creatureDatabase.get((genSelected-1)*3+statusWindow+3);
      shouldBeWatching = cj.id;
    }
    if (creatureWatching != shouldBeWatching || isFirstFrame) {
      openMiniSimulation();
    }
  }
}

void drawStats(float x, float y, float size) {
  textAlign(RIGHT);
  textFont(font, 32);
  fill(0);
  pushMatrix();
  translate(x, y);
  scale(size);
  text("Creature ID: "+id, 0, 32);
  if (speed > 60) {
    timeShow = int((timer+creaturesTested*37)/60)%15;
  } else {
    timeShow = (timer/60);
  }
  text("Time: "+nf(timeShow, 0, 2)+" / 15 sec.", 0, 64);
  text("Playback Speed: x"+max(1, speed), 0, 96);
  String extraWord = "used";
  if (energyDirection == -1) {
    extraWord = "left";
  }
  text("X: "+nf(averageX/5.0, 0, 2)+"", 0, 128);
  text("Y: "+nf(-averageY/5.0, 0, 2)+"", 0, 160);
  text("Energy "+extraWord+": "+nf(energy, 0, 2)+" yums", 0, 192);
  text("A.N.Nausea: "+nf(averageNodeNausea, 0, 2)+" blehs", 0, 224);

  popMatrix();
}

void drawSkipButton() {
  fill(0);
  rect(0, windowHeight-40, 90, 40);
  fill(255);
  textAlign(CENTER);
  textFont(font, 32);
  text("SKIP", 45, windowHeight-8);
}

void drawOtherButtons() {
  fill(0);
  rect(120, windowHeight-40, 240, 40);
  fill(255);
  textAlign(CENTER);
  textFont(font, 32);
  text("PB speed: x"+speed, 240, windowHeight-8);
  fill(0);
  rect(windowWidth-120, windowHeight-40, 120, 40);
  fill(255);
  textAlign(CENTER);
  textFont(font, 32);
  text("FINISH", windowWidth-60, windowHeight-8);
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
  c[i].d = averageX*0.2; // Multiply by 0.2 because a meter is 5 units for some weird reason.
}

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