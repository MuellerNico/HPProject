class Player {  // 

  PVector position; 
  PVector predictedPosition;
  PVector orientation;  // only int
  PVector velocity;  // always computed locally
  float speed;  // per second
  int slot;

  final String IP;

  Player(String ip, int slot) {
    this.position = new PVector();
    this.predictedPosition = new PVector();
    this.orientation = new PVector(1, 0);  // for img display required?
    this.velocity = new PVector();
    this.speed = 5;  // TODO: ~time

    this.slot = slot;
    IP = ip;

    // JSON Profile with stats (speed)
  }

  void update() {
    predictedPosition.add(velocity);
    ellipse(predictedPosition.x, predictedPosition.y, 20, 20);
  }

  void applyData(float[] values) {  //values = slot, posX, posY, dirX, dirY, speed, oriX, oriY
    this.position.x = values[1];
    this.position.y = values[2];
    this.velocity.x = values[3];
    this.velocity.y = values[4];
    this.orientation.x = values[5];
    this.orientation.y = values[6];

    //adjust position
    this.predictedPosition = position;
  }

  String wrapData() {  // todo: cleanup
    String output = slot + "," +  position.x + "," + position.y + "," + velocity.x + "," 
      + velocity.y + "," + orientation.x + "," + orientation.y + "\r";           
    return output;
  }
}
