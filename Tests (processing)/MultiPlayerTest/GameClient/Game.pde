class Game { //ANIMATIONS, UI, respawn

  Player[] players;
  int numberOfPlayers;

  Game() {
    players = new Player[100];
  }

  void update() {
    background(13, 55, 13); 
    text("FPS: " + frameRate, 10, 10);
    for (int i=0; i<numberOfPlayers; i++) {
      players[i].update();
    }
  }

  void gameEvent(JSONObject event) {
    if (event.getString("eventType").equals("stupefy")) {
      println("SPEEEELLL");
    }
  }

  void applyData(float[] values) {  
    if (values[0] != localPlayer.slot) {  // don't adjust own player
      players[int(values[0])].applyData(values);  // data[] = [slot, posX, posY, velX, velY, orX, orY, hp]
    }
  }
}
