class Player extends GameObject {

  PVector pos;
  PVector dir;
  PVector orientation;
  PVector vel;
  float speed;
  int size;
  PImage img;
  PImage armImg;

  Player() {
    super(); 
    speed = 8;    
    dir = new PVector(0, 0);
    vel = new PVector(0, 0);
    pos = new PVector(5900, 5900);
    orientation = new PVector(1, 0);    
    img = loadImage("student_griff_01_body.png");
    armImg = loadImage("student_griff_01_arm.png");
    //img.resize(img.width * UNIT/40, img.height * UNIT/40);
    //map.toUpdate.add(this);
    map.addPlayer(this);
  }

  void update() {
    orientation.set(mouseX-width/2, mouseY-height/2).normalize();
    vel = dir.copy().setMag(speed);
    if (!collision()) {  // cheap and easy but far from perfect (no slideing along walls)
      pos.add(vel);
    }
    display(0,0);
  }
  
  void display(int x, int y) {
    pushMatrix();
    translate(W2, H2);
    rotate(orientation.heading());
    imageMode(CENTER);
    image(img, 0, 0);
    imageMode(CORNER);
    image(armImg, -20, -10);
    popMatrix();
  }

  boolean collision() {  //TODO only cancel 1 direction only
    for (Obstacle o : map.obstacles) {
      if (PVector.dist(pos, o.pos) < o.r) {
        if (pos.x + vel.x > o.pos.x && pos.x + vel.x < o.pos.x + o.w) {
          if (pos.y + vel.y > o.pos.y &&  pos.y + vel.y < o.pos.y + o.h) {
            return true;
          }
        }
      }
    }
    return false;
  }
}
