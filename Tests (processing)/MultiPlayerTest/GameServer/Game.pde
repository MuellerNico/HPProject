class Game { //environment, score, time, points, capture, respawn?, win

  Player[] players;
  int numberOfPlayers = 0;
  int maxNumberOfPlayers = 100;
  HashMap<String, Player> getPlayer;
  Stack<Integer> emptySlots;
  //map
  //spells

  Game() {
    players = new Player[100];
    getPlayer = new HashMap<String, Player>();
    emptySlots = new Stack<Integer>();
    // with a stack you always have the lowest possible values
    // when a player leaves the next one will join in his slot
    // still have to test if players[slot] == null
    // maybe empty player obj
    for (int i = maxNumberOfPlayers-1; i >= 0; i--) {
      emptySlots.push(i);
    }
  }

  void update() {
    background(13, 55, 13); 
    text("FPS: " + frameRate, 10, 20);            
    
    for (int i=0; i<numberOfPlayers; i++) {  // check for null
      ellipse(players[i].position.x, players[i].position.y, 20, 20);
    }
  }

  void playerLeft(int slot) {
    players[slot] = null;
    emptySlots.push(slot);
    numberOfPlayers --;
  }

  void applyData(float[] values) {  // from all players, apply to game state
    players[int(values[0])].applyData(values);  // data[] = [slot, posX, posY, velX, velY, orX, orY, hp]
  }

  void gameEvent(JSONObject event) {
    if (event.getString("eventType").equals("stupefy")) {
      println("SPEEEELLL");
    }
  }
}
