class Player {

  PVector position;  
  PVector direction;  // only use int values
  PVector orientation;  // only int
  PVector velocity;  // always computed locally
  float speed;  // per second
  int slot;
  JSONObject profile;

  final String IP;
  Client client;

  Player(Client client, int slot) {
    this.position = new PVector();
    this.orientation = new PVector(1, 0);  // for img display required?
    this.direction   = new PVector();
    this.velocity = new PVector();

    this.client = client;
    this.slot = slot;
    IP = client.ip();
    
    profile = new JSONObject();
    profile.put("slot", slot).put("ip", IP);
    // speed passed by client
  }

  void update() {
    //position.add(velocity);
  }

  void applyData(float[] values) {  //values: slot, posX, posY, dirX, dirY, speed, oriX, oriY
    this.position.x = values[1];
    this.position.y = values[2];
    this.velocity.x = values[3];
    this.velocity.y = values[4];
    this.orientation.x = values[5];
    this.orientation.y = values[6];
  }
}
