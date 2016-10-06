import java.util.Date;
import java.util.List;
/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/377698*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */

// Constants

final float windowSizeMultiplier = 0.8;
final int SEED = 0;

final ArrayList<Float[]> percentile = new ArrayList<Float[]>(0);
final ArrayList<Integer[]> barCounts = new ArrayList<Integer[]>(0);
final ArrayList<Integer[]> speciesCounts = new ArrayList<Integer[]>(0);
final ArrayList<Integer> topSpeciesCounts = new ArrayList<Integer>(0);
final ArrayList<Creature> creatureDatabase = new ArrayList<Creature>(0);
final ArrayList<Rectangle> rects = new ArrayList<Rectangle>(0);
final boolean haveGround = true;
final int histBarsPerMeter = 5;
final String[] operationNames = {"#", "time", "px", "py", "+", "-", "*", "÷", "%", "sin", "sig", "pres"};
final int[] operationAxons =    {0, 0, 0, 0, 2, 2, 2, 2, 2, 1, 1, 0};
final int operationCount = 12;
final String fitnessUnit = "m";
final String fitnessName = "Distance";
final float baselineEnergy = 0.0;
final int energyDirection = 1; // if 1, it'll count up how much energy is used.  if -1, it'll count down from the baseline energy, and when energy hits 0, the creature dies.
final float FRICTION = 4;
final float bigMutationChance = 0.06;
final float hazelStairs = -1;
final boolean saveFramesPerGeneration = true;
final float pressureUnit = 500.0/2.37;
final float energyUnit = 20;
final float nauseaUnit = 5;
final int minBar = -10;
final int maxBar = 100;
final int barLen = maxBar-minBar;
final float postFontSize = 0.96;
final float scaleToFixBug = 1000;

final float lineY1 = -0.08; // These are for the lines of text on each node.
final float lineY2 = 0.35;
final color axonColor = color(255, 255, 0);

final int windowWidth = 1280;
final int windowHeight = 720;
final int frames = 60;
final int[] fontSizes = {
  50, 36, 25, 20, 16, 14, 11, 9
};

final int[] creaturesInPosition = new int[1000];

final float gravity = 0.005;
final float airFriction = 0.95;

final int[] p = {
  0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 
  100, 200, 300, 400, 500, 600, 700, 800, 900, 910, 920, 930, 940, 950, 960, 970, 980, 990, 999
};

PFont font;
PGraphics graphImage;
PGraphics screenImage;
PGraphics popUpImage;
PGraphics segBarImage;
int lastImageSaved = -1;
int gensToDo = 0;
float cTimer = 60;
float energy = 0;
float averageNodeNausea = 0;
float totalNodeNausea = 0;

int timer = 0;
float camX = 0;
float camY = 0;
int menu = 0;
int gen = -1;
float sliderX = 1170;
int genSelected = 0;
boolean drag = false;
boolean justGotBack = false;
int creaturesTested = 0;
int fontSize = 0;

int statusWindow = -4;
int prevStatusWindow = -4;
int overallTimer = 0;
boolean miniSimulation = false;
int creatureWatching = 0;
int simulationTimer = 0;

float camZoom = 0.015;

float target;
float averageX;
float averageY;
int speed;
int id;
boolean stepbystep;
boolean stepbystepslow;
boolean slowDies;
int timeShow;

ArrayList<Node> nodes = new ArrayList<Node>();
ArrayList<Muscle> muscles = new ArrayList<Muscle>();
final Creature[] creatures = new Creature[1000]; // TODO: rename these creatures variables; figure out their intent
ArrayList<Creature> creatures2 = new ArrayList<Creature>(); // TODO: rename these creatures variables; figure out their intent

void setup() {
  size(1280, 720);
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
}