class Stupefy extends Spell {
  
  PVector vel;
  int speed;
  int range;
  
  Stupefy(PVector pos, PVector or) {
    super(pos, or);
    vel = or.copy();
    speed = 50;
    range = (int) width/2;
  }

  void update() {
    if (PVector.dist(pos, origin)>range) {
      map.toUpdate.remove(this);
    }
    vel.setMag(speed);  // TODO accel
    pos.add(vel);
  }

  void display(int x, int y) {   // TODO: animation
    fill(200, 0, 0);
    noStroke();
    ellipse(x, y, 70, 70);
  }

  void onImpact() {
  }
}
