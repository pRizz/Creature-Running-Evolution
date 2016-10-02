
// TODO: Make view classes with these helpers

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

void drawScreenImage(int stage) {
  screenImage.beginDraw();
  screenImage.pushMatrix();
  screenImage.scale(15.0/scaleToFixBug);
  screenImage.smooth();
  screenImage.background(220, 253, 102);
  screenImage.noStroke();
  for (int j = 0; j < 1000; j++) {
    Creature cj = creatures2.get(j);
    if (stage == 3) cj = creatures[cj.id-(gen*1000)-1001];
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
      Creature cj = creatures2.get(j);
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
    cj = creatures2.get(statusWindow);
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