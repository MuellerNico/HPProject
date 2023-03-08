class Player {

  PVector pos;
  PVector dir;
  PVector orientation;
  PVector vel;
  float speed;
  int size = 50;
  String IP;
  Client c;

  Player(Client cl, PVector pos) {
    this.pos = pos;
    this.c = cl;
    IP = c.ip();
    orientation = new PVector(1, 0);
    dir = new PVector(0, 0);
    vel = new PVector(0, 0);
    speed = 5;
  }


  void update() {
    pos.add(vel);
  }
  
  void drawPlayer(){
    ellipse(pos.x, pos.y, size, size);
  }
  
  String wrapData(){
    String data = "";
    //data += IP + ",";
    float values[] = {pos.x, pos.y, orientation.x, orientation.y};
    for(float v: values){
      data += v + ",";
    }
    return data;
  }
}
