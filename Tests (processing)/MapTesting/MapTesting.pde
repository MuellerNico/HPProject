HashMap<Character, PVector> movKeys;  // TODO: input handler class
HashMap<Character, Boolean> pressed;
int UNIT; 
float W2;
float H2;
Player p;
Desk t1, t2, t3;
Map map;
ProgressBar hp;

Integer[][] tiles;

void setup() {
  frameRate(60);  // TODO: time not framebased updating
  noStroke();
  fullScreen();
  //size(1000,1000);
  imageMode(CORNER);

  W2 = width/2;
  H2 = height/2;  
  UNIT = height/54;
  //println("unitsize: " + UNIT);

  tiles = new Integer[width/UNIT][height/UNIT];  
  pressed = new  HashMap<Character, Boolean>();
  movKeys = new HashMap<Character, PVector>() {
    {
      put('w', new PVector(0, -1) );
      put('a', new PVector(-1, 0));
      put('s', new PVector(0, 1));
      put('d', new PVector(1, 0));
    }
  };

  for (char k : movKeys.keySet()) {
    pressed.put(k, false);
  }

  map = new Map();  
  p = new Player();
  hp = new ProgressBar(width/2-100, 50, 200, 40, 100);
  hp.setColor(color(150, 20, 20));
  //just testing. later: loading map inside map class
  t1 = new Desk(new PVector(6000, 6000));  
  t2 = new Desk(new PVector(6000, 6800));
  t3 = new Desk(new PVector(6500, 6350));
  //new Desk(new PVector(6700, 6350));
  //new Desk(new PVector(7000, 6500));
  //new Desk(new PVector(6500, 6800));
}

void draw() {
  
  if (hp.current < 80) {
    hp.current ++;
  }
  
  background(13, 55, 13);  

  /* DRAW TILES
   for (int i=0; i<tiles.length; i++) {
   for (int j=0; j<tiles[0].length; j++) {
   noFill();
   stroke(0);
   rect(i * UNIT, j * UNIT, UNIT, UNIT);
   }
   }
   */

  map.draw();
  hp.display();
  //p.update();
  //p.display(0, 0); // coords not used

  fill(255);
  textSize(UNIT);
  text("FPS: " + frameRate, 10, 20);
}


// INPUT
void keyPressed() {
  try {
    if (!pressed.get(key)) {
      pressed.put(key, true);
      p.dir.add(movKeys.get(key));
    }
  }
  catch(Exception e) {
    println("unknown key down");
  }
}
void keyReleased() {
  try {
    pressed.put(key, false);
    p.dir.sub(movKeys.get(key));
  }
  catch(Exception e) {
    println("unknown key up");
  }
}
void mousePressed() {
  new Stupefy(p.pos.copy().add(p.orientation.copy().setMag(220)), p.orientation);
}

void mouseWheel() {
  scale(2);
}
