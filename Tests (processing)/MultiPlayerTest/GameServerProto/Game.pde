class Game { //environment, score, time, points, capture, respawn?, win

  ArrayList<Player> players;
  HashMap<Integer , Player> getPlayer;

  Game() {
    players = new ArrayList<Player>();
    getPlayer = new HashMap<Integer, Player>();
  }

  void update() {
    background(13, 55, 13); 
    text("FPS: " + frameRate, 10, 20);            
    for (Player p : players) {  // check for null
      ellipse(p.position.x, p.position.y, 20, 20);
    }
  }

  void applyData(String[] values) {  // from all players, apply to game state
    //println("val from IP: " + values[0]);
    getPlayer.get(int(values[0])).applyData(float(values));  // data[] = [ip, posX, posY, velX, velY, orX, orY, hp, action] action 0=def, 1=spell
  }
}
