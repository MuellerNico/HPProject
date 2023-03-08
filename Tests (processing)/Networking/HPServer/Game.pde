class Game { //environment, score, time, points, capture, respawn?, win
  ArrayList<Player> players;
  //map
  //spells

  Game() {
    players = new ArrayList<Player>();
  }

  void update() {
    for(int i=0; i<players.size(); i++) {
      players.get(i).drawPlayer();
    }
  }
  
  Player newPlayer(Client c) { //TODO: operations on join. spawnpoint, team, etc
    Player p = new Player(c, new PVector(width/2, height/2));
    return p;
  }
}
