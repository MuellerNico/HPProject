class Player {

  PVector pos;
  PVector dir;
  PVector orientation;
  PVector vel;
  float speed;
  int size = 50;
  String IP;

  Player(String ip, PVector pos) {
    this.pos = pos;
    this.IP = ip;
    orientation = new PVector(1, 0);
    dir = new PVector(0, 0);
    vel = new PVector(0, 0);
    speed = 4;
    game.players.add(this);
  }

  void update() {
    orientation.set(mouseX-pos.x, mouseY-pos.y);
    orientation.normalize();
    vel = dir.copy().setMag(speed);
    
    nch.sendData();
  }
  void drawPlayer(){
    fill(255);
    ellipse(pos.x, pos.y, size, size);
  }
}
