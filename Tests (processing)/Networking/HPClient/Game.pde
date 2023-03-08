class Game {

  ArrayList<Player> players;
  HashMap<String, Player> getPlayer;

  //map
  //spells

  Game() {
    players = new ArrayList<Player>();
    getPlayer = new HashMap<String, Player>();
  }

  void gameloop() {
    text("Number of Players: " + game.players.size(), 30, 30);
    game.update();
  }
  
  void update() {
    background(13, 55, 13);
    LOCAL_PLAYER.update();
    for (int i=0; i<players.size(); i++) {
      players.get(i).drawPlayer();
    }
    //println(LOCAL_PLAYER.pos.x);
  }

  Player newPlayer(String ip, float[] values) {
    Player p = new Player(ip, new PVector(values[0], values[1]));
    getPlayer.put(ip, p);
    //TODO: orientation etc 
    println("NP number of players: " + players.size());
    return p;
  }

  Player newPlayer(String ip, PVector pos) { // Temp?
    Player p = new Player(ip, new PVector(pos.x, pos.y));
    getPlayer.put(ip, p);
    //TODO: orientation etc 
    println("number of players: " + players.size());
    return p;
  }
}
