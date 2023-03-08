class Game { //ANIMATIONS, UI, respawn

  ArrayList<Player> players;
  HashMap<Integer, Player> getPlayer;
  int numberOfPlayers;

  Game() {
    players = new ArrayList<Player>();
    getPlayer = new HashMap<Integer, Player>();
  }

  void update() {
    background(13, 55, 13); 
    text("FPS: " + frameRate, 10, 10);
    for (Player p : players) {
      p.update();
    }
  }

  void applyData(float[] values) {  
    if (int(values[0]) != localPlayer.ip) {  // don't adjust own player
      if (getPlayer.get(values[0]) != null) {
        getPlayer.get(values[0]).applyData(values);  // data[] = [slot, posX, posY, velX, velY, orX, orY, hp]
      } else {  // unknown player
        Player p = new Player(int(values[0]));
        players.add(p);
        getPlayer.put(int(values[0]), p);
      }
    }
  }
}
