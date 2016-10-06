import java.util.Date;
import java.util.List;
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

ArrayList<Node> nodes = new ArrayList<Node>();
ArrayList<Muscle> muscles = new ArrayList<Muscle>();
Creature[] creatures = new Creature[1000]; // TODO: rename these creatures variables; figure out their intent
ArrayList<Creature> creatures2 = new ArrayList<Creature>(); // TODO: rename these creatures variables; figure out their intent

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
 //<>//
  graphImage = createGraphics(975, 570);
  screenImage = createGraphics(1920, 1080);
  popUpImage = createGraphics(450, 450);
  segBarImage = createGraphics(975, 150);
  segBarImage.smooth();
  segBarImage.beginDraw();
  segBarImage.background(220);
  segBarImage.endDraw();
  popUpImage.smooth();
  popUpImage.beginDraw();
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