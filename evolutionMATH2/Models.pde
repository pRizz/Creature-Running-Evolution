

class Rectangle {
  float x1, y1, x2, y2;
  Rectangle(float tx1, float ty1, float tx2, float ty2) {
    x1 = tx1;
    y1 = ty1;
    x2 = tx2;
    y2 = ty2;
  }
}

class Node {
  float x, y, vx, vy, prevX, prevY, pvx, pvy, m, f, value, valueToBe;
  int operation, axon1, axon2;
  boolean safeInput;
  float pressure;
  Node(float tx, float ty, float tvx, float tvy, float tm, float tf, float val, int op, int a1, int a2) {
    prevX = x = tx;
    prevY = y = ty;
    pvx = vx = tvx;
    pvy = vy = tvy;
    m = tm;
    f = tf;
    value = valueToBe = val;
    operation = op;
    axon1 = a1;
    axon2 = a2;
    pressure = 0;
  }
  void applyForces() {
    vx *= airFriction;
    vy *= airFriction;
    y += vy;
    x += vx;
    float acc = dist(vx, vy, pvx, pvy);
    totalNodeNausea += acc*acc*nauseaUnit;
    pvx = vx;
    pvy = vy;
  }

  // takes and returns the new totalNodeNausea
  float applyForcesRefactored(float totalNodeNausea) {
    vx *= airFriction;
    vy *= airFriction;
    y += vy;
    x += vx;
    float acc = dist(vx, vy, pvx, pvy);
    totalNodeNausea += acc*acc*nauseaUnit;
    pvx = vx;
    pvy = vy;
    return totalNodeNausea;
  }

  void applyGravity() {
    vy += gravity;
  }

  // Does not mutate globals
  void pressAgainstGround(float groundY) {
    float dif = y-(groundY-m/2);
    pressure += dif*pressureUnit;
    y = (groundY-m/2);
    vy = 0;
    x -= vx*f;
    if (vx > 0) {
      vx -= f*dif*FRICTION;
      if (vx < 0) {
        vx = 0;
      }
    } else {
      vx += f*dif*FRICTION;
      if (vx > 0) {
        vx = 0;
      }
    }
  }

  // Does not mutate globals
  void hitWalls() {
    pressure = 0;
    float dif = y+m/2;
    if (dif >= 0 && haveGround) {
      pressAgainstGround(0);
    }
    if (y > prevY && hazelStairs >= 0) {
      float bottomPointNow = y+m/2;
      float bottomPointPrev = prevY+m/2;
      int levelNow = (int)(ceil(bottomPointNow/hazelStairs));
      int levelPrev = (int)(ceil(bottomPointPrev/hazelStairs));
      if (levelNow > levelPrev) {
        float groundLevel = levelPrev*hazelStairs;
        pressAgainstGround(groundLevel);
      }
    }
    for (int i = 0; i < rects.size(); i++) {
      Rectangle r = rects.get(i);
      boolean flip = false;
      float px, py;
      if (abs(x-(r.x1+r.x2)/2) <= (r.x2-r.x1+m)/2 && abs(y-(r.y1+r.y2)/2) <= (r.y2-r.y1+m)/2) {
        if (x >= r.x1 && x < r.x2 && y >= r.y1 && y < r.y2) {
          float d1 = x-r.x1;
          float d2 = r.x2-x;
          float d3 = y-r.y1;
          float d4 = r.y2-y;
          if (d1 < d2 && d1 < d3 && d1 < d4) {
            px = r.x1;
            py = y;
          } else if (d2 < d3 && d2 < d4) {
            px = r.x2;
            py = y;
          } else if (d3 < d4) {
            px = x;
            py = r.y1;
          } else {
            px = x;
            py = r.y2;
          }
          flip = true;
        } else {
          if (x < r.x1) {
            px = r.x1;
          } else if (x < r.x2) {
            px = x;
          } else {
            px = r.x2;
          }
          if (y < r.y1) {
            py = r.y1;
          } else if (y < r.y2) {
            py = y;
          } else {
            py = r.y2;
          }
        }
        float distance = dist(x, y, px, py);
        float rad = m/2;
        float wallAngle = atan2(py-y, px-x);
        if (flip) {
          wallAngle += PI;
        }
        if (distance < rad || flip) {
          dif = rad-distance;
          pressure += dif*pressureUnit;
          float multi = rad/distance;
          if (flip) {
            multi = -multi;
          }
          x = (x-px)*multi+px;
          y = (y-py)*multi+py;
          float veloAngle = atan2(vy, vx);
          float veloMag = dist(0, 0, vx, vy);
          float relAngle = veloAngle-wallAngle;
          float relY = sin(relAngle)*veloMag*dif*FRICTION;
          vx = -sin(relAngle)*relY;
          vy = cos(relAngle)*relY;
        }
      }
    }
    prevY = y;
    prevX = x;
  }
  void doMath(ArrayList<Node> n) {
    float axonValue1 = n.get(axon1).value;
    float axonValue2 = n.get(axon2).value;
    if (operation == 0) { // constant
    } else if (operation == 1) { // time
      valueToBe = simulationTimer/60.0;
    } else if (operation == 2) { // x - coordinate
      valueToBe = x*0.2;
    } else if (operation == 3) { // y - coordinate
      valueToBe = -y*0.2;
    } else if (operation == 4) { // plus
      valueToBe = axonValue1+axonValue2;
    } else if (operation == 5) { // minus
      valueToBe = axonValue1-axonValue2;
    } else if (operation == 6) { // times
      valueToBe = axonValue1*axonValue2;
    } else if (operation == 7) { // divide
      valueToBe = axonValue1/axonValue2;
    } else if (operation == 8) { // modulus
      valueToBe = axonValue1%axonValue2;
    } else if (operation == 9) { // sin
      valueToBe = sin(axonValue1);
    } else if (operation == 10) { // sig
      valueToBe = 1/(1+pow(2.71828182846, -axonValue1));
    } else if (operation == 11) { // pressure
      valueToBe = pressure;
    }
  }
  void realizeMathValues() {
    value = valueToBe;
  }
  Node copyNode() {
    return (new Node(x, y, 0, 0, m, f, value, operation, axon1, axon2));
  }
  Node modifyNode(float mutability, int nodeNum) {
    float newX = x+r()*0.5*mutability;
    float newY = y+r()*0.5*mutability;
    float newM = m+r()*0.1*mutability;
    newM = min(max(newM, 0.3), 0.5);
    newM = 0.4;

    float newV = value*(1+r()*0.2*mutability);
    int newOperation = operation;
    int newAxon1 = axon1;
    int newAxon2 = axon2;
    if (random(0, 1)<bigMutationChance*mutability) {
      newOperation = int(random(0, operationCount));
    }
    if (random(0, 1)<bigMutationChance*mutability) {
      newAxon1 = int(random(0, nodeNum));
    }
    if (random(0, 1)<bigMutationChance*mutability) {
      newAxon2 = int(random(0, nodeNum));
    }

    if (newOperation == 1) { // time
      newV = 0;
    } else if (newOperation == 2) { // x - coordinate
      newV = newX*0.2;
    } else if (newOperation == 3) { // y - coordinate
      newV = -newY*0.2;
    }

    Node newNode = new Node(newX, newY, 0, 0, newM, min(max(f+r()*0.1*mutability, 0), 1), newV, newOperation, newAxon1, newAxon2);
    return newNode;//max(m+r()*0.1,0.2),min(max(f+r()*0.1,0),1)
  }
}

class Muscle {
  int axon, c1, c2;
  float len;
  float rigidity;
  float previousTarget;
  Muscle(int taxon, int tc1, int tc2, float tlen, float trigidity) {
    axon  = taxon;
    previousTarget = len = tlen;
    c1 = tc1;
    c2 = tc2;
    rigidity = trigidity;
  }
  void applyForce(ArrayList<Node> n) {
    float target = previousTarget;
    if (energyDirection == 1 || energy >= 0.0001) {
      if (axon >= 0 && axon < n.size()) {
        target = len*toMuscleUsable(n.get(axon).value);
      } else {
        target = len;
      }
    }
    Node ni1 = n.get(c1);
    Node ni2 = n.get(c2);
    float distance = dist(ni1.x, ni1.y, ni2.x, ni2.y);
    float angle = atan2(ni1.y-ni2.y, ni1.x-ni2.x);
    force = min(max(1-(distance/target), -0.4), 0.4);
    ni1.vx += cos(angle)*force*rigidity/ni1.m;
    ni1.vy += sin(angle)*force*rigidity/ni1.m;
    ni2.vx -= cos(angle)*force*rigidity/ni2.m;
    ni2.vy -= sin(angle)*force*rigidity/ni2.m;
    energy = max(energy+energyDirection*abs(previousTarget-target)*rigidity*energyUnit, 0);
    previousTarget = target;
  }
  Muscle copyMuscle() {
    return new Muscle(axon, c1, c2, len, rigidity);
  }
  Muscle modifyMuscle(int nodeNum, float mutability) {
    int newc1 = c1;
    int newc2 = c2;
    int newAxon = axon;
    if (random(0, 1)<bigMutationChance*mutability) {
      newc1 = int(random(0, nodeNum));
    }
    if (random(0, 1)<bigMutationChance*mutability) {
      newc2 = int(random(0, nodeNum));
    }
    if (random(0, 1)<bigMutationChance*mutability) {
      newAxon = getNewMuscleAxon(nodeNum);
    }
    float newR = min(max(rigidity*(1+r()*0.9*mutability), 0.01), 0.08);
    float newLen = min(max(len+r()*mutability, 0.4), 1.25);

    return new Muscle(newAxon, newc1, newc2, newLen, newR);
  }
}

class Creature {
  ArrayList<Node> n;
  ArrayList<Muscle> m;
  float simulatedFitness;
  int id;
  boolean alive;
  float creatureTimer;
  float mutability;

  Creature(int tid, ArrayList<Node> tn, ArrayList<Muscle> tm, float td, boolean talive, float tct, float tmut) {
    id = tid;
    m = tm;
    n = tn;
    simulatedFitness = td;
    alive = talive;
    creatureTimer = tct;
    mutability = tmut;
  }

  Creature modified(int id) {
    Creature modifiedCreature = new Creature(id, 
      new ArrayList<Node>(0), new ArrayList<Muscle>(0), 0, true, creatureTimer+r()*16*mutability, min(mutability*random(0.8, 1.25), 2));
    for (int i = 0; i < n.size(); i++) {
      modifiedCreature.n.add(n.get(i).modifyNode(mutability, n.size()));
    }
    for (int i = 0; i < m.size(); i++) {
      modifiedCreature.m.add(m.get(i).modifyMuscle(n.size(), mutability));
    }
    if (random(0, 1) < bigMutationChance*mutability || n.size() <= 2) { //Add a node
      modifiedCreature.addRandomNode();
    }
    if (random(0, 1) < bigMutationChance*mutability) { //Add a muscle
      modifiedCreature.addRandomMuscle(-1, -1);
    }
    if (random(0, 1) < bigMutationChance*mutability && modifiedCreature.n.size() >= 4) { //Remove a node
      modifiedCreature.removeRandomNode();
    }
    if (random(0, 1) < bigMutationChance*mutability && modifiedCreature.m.size() >= 2) { //Remove a muscle
      modifiedCreature.removeRandomMuscle();
    }
    modifiedCreature.checkForOverlap();
    modifiedCreature.checkForLoneNodes();
    modifiedCreature.checkForBadAxons();
    return modifiedCreature;
  }

  void checkForOverlap() {
    ArrayList<Integer> bads = new ArrayList<Integer>();
    for (int i = 0; i < m.size(); i++) {
      for (int j = i+1; j < m.size(); j++) {
        if (m.get(i).c1 == m.get(j).c1 && m.get(i).c2 == m.get(j).c2) {
          bads.add(i);
        } else if (m.get(i).c1 == m.get(j).c2 && m.get(i).c2 == m.get(j).c1) {
          bads.add(i);
        } else if (m.get(i).c1 == m.get(i).c2) {
          bads.add(i);
        }
      }
    }
    for (int i = bads.size()-1; i >= 0; i--) {
      int b = bads.get(i)+0;
      if (b < m.size()) {
        m.remove(b);
      }
    }
  }

  void checkForLoneNodes() {
    if (n.size() >= 3) {
      for (int i = 0; i < n.size(); i++) {
        int connections = 0;
        int connectedTo = -1;
        for (int j = 0; j < m.size(); j++) {
          if (m.get(j).c1 == i || m.get(j).c2 == i) {
            connections++;
            connectedTo = j;
          }
        }
        if (connections <= 1) {
          int newConnectionNode = floor(random(0, n.size()));
          while (newConnectionNode == i || newConnectionNode == connectedTo) {
            newConnectionNode = floor(random(0, n.size()));
          }
          addRandomMuscle(i, newConnectionNode);
        }
      }
    }
  }

  void checkForBadAxons() {
    for (int i = 0; i < n.size(); i++) {
      Node ni = n.get(i);
      if (ni.axon1 >= n.size()) {
        ni.axon1 = int(random(0, n.size()));
      }
      if (ni.axon2 >= n.size()) {
        ni.axon2 = int(random(0, n.size()));
      }
    }
    for (int i = 0; i < m.size(); i++) {
      Muscle mi = m.get(i);
      if (mi.axon >= n.size()) {
        mi.axon = getNewMuscleAxon(n.size());
      }
    }

    for (int i = 0; i < n.size(); i++) {
      Node ni = n.get(i);
      ni.safeInput = (operationAxons[ni.operation] == 0);
    }
    int iterations = 0;
    boolean didSomething = false;

    while (iterations < 1000) {
      didSomething = false;
      for (int i = 0; i < n.size(); i++) {
        Node ni = n.get(i);
        if (!ni.safeInput) {
          if ((operationAxons[ni.operation] == 1 && n.get(ni.axon1).safeInput) ||
            (operationAxons[ni.operation] == 2 && n.get(ni.axon1).safeInput && n.get(ni.axon2).safeInput)) {
            ni.safeInput = true;
            didSomething = true;
          }
        }
      }
      if (!didSomething) {
        iterations = 10000;
      }
    }

    for (int i = 0; i < n.size(); i++) {
      Node ni = n.get(i);
      if (!ni.safeInput) { // This node doesn't get its input from a safe place.  CLEANSE IT.
        ni.operation = 0;
        ni.value = random(0, 1);
      }
    }
  }

  void addRandomNode() {
    int parentNode = floor(random(0, n.size()));
    float ang1 = random(0, 2*PI);
    float distance = sqrt(random(0, 1));
    float x = n.get(parentNode).x+cos(ang1)*0.5*distance;
    float y = n.get(parentNode).y+sin(ang1)*0.5*distance;

    int newNodeCount = n.size()+1;

    n.add(new Node(x, y, 0, 0, 0.4, random(0, 1), random(0, 1), floor(random(0, operationCount)), 
      floor(random(0, newNodeCount)), floor(random(0, newNodeCount)))); //random(0.1,1),random(0,1)
    int nextClosestNode = 0;
    float record = 100000;
    for (int i = 0; i < n.size()-1; i++) {
      if (i != parentNode) {
        float dx = n.get(i).x-x;
        float dy = n.get(i).y-y;
        if (sqrt(dx*dx+dy*dy) < record) {
          record = sqrt(dx*dx+dy*dy);
          nextClosestNode = i;
        }
      }
    }
    addRandomMuscle(parentNode, n.size()-1);
    addRandomMuscle(nextClosestNode, n.size()-1);
  }

  void addRandomMuscle(int tc1, int tc2) {
    int axon = getNewMuscleAxon(n.size());
    if (tc1 == -1) {
      tc1 = int(random(0, n.size()));
      tc2 = tc1;
      while (tc2 == tc1 && n.size () >= 2) {
        tc2 = int(random(0, n.size()));
      }
    }
    float len = random(0.5, 1.5);
    if (tc1 != -1) {
      len = dist(n.get(tc1).x, n.get(tc1).y, n.get(tc2).x, n.get(tc2).y);
    }
    m.add(new Muscle(axon, tc1, tc2, len, random(0.02, 0.08)));
  }

  void removeRandomNode() {
    int choice = floor(random(0, n.size()));
    n.remove(choice);
    int i = 0;
    while (i < m.size ()) {
      if (m.get(i).c1 == choice || m.get(i).c2 == choice) {
        m.remove(i);
      } else {
        i++;
      }
    }
    for (int j = 0; j < m.size(); j++) {
      if (m.get(j).c1 >= choice) {
        m.get(j).c1--;
      }
      if (m.get(j).c2 >= choice) {
        m.get(j).c2--;
      }
    }
  }

  void removeRandomMuscle() {
    int choice = floor(random(0, m.size()));
    m.remove(choice);
  }

  Creature copyCreature(int newID) {
    ArrayList<Node> n2 = copyOfNodes();
    ArrayList<Muscle> m2 = copyOfMuscles();
    if (newID == -1) {
      newID = id;
    }
    return new Creature(newID, n2, m2, simulatedFitness, alive, creatureTimer, mutability);
  }

  float getAverageX() {
    float averageX = 0;
    for (Node node : n) {
      averageX += node.x;
    }
    averageX = averageX/n.size();
    return averageX;
  }

  float getAverageY() {
    float averageY = 0;
    for (Node node : n) {
      averageY += node.y;
    }
    averageY = averageY/n.size();
    return averageY;
  }

  // TODO: Replace the 'd' variable with this query
  float getFitness() {
    return getAverageX()*0.2; // Multiply by 0.2 because a meter is 5 units for some weird reason.
  }

  ArrayList<Node> copyOfNodes() {
    ArrayList<Node> nodes = new ArrayList<Node>(n.size());
    for (Node node : n) {
      nodes.add(node.copyNode());
    }
    return nodes;
  }

  ArrayList<Muscle> copyOfMuscles() {
    ArrayList<Muscle> muscles = new ArrayList<Muscle>(m.size());
    for (Muscle muscle : m) {
      muscles.add(muscle.copyMuscle());
    }
    return muscles;
  }
}

class SimulationResult {
  final float averageNodeNausea;
  final int simulationTimer;
  final int timer;
  final float fitness;
  final float totalNodeNausea;

  SimulationResult(float averageNodeNausea, int simulationTimer, int timer, float fitness, float totalNodeNausea) {
    this.averageNodeNausea = averageNodeNausea;
    this.simulationTimer = simulationTimer;
    this.timer = timer;
    this.fitness = fitness;
    this.totalNodeNausea = totalNodeNausea;
  }
}