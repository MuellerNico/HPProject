class Map { //items, chests, walls (no players, spells, objectives, messages etc)

  int numberOfPlayers;
  String name;
  Chunk[][] chunks;

  ArrayList<GameObject> toUpdate;  // should load from chunk later
  ArrayList<Obstacle> obstacles; // TODO: low and heigh obstacles. you can bend over a desk but not a wall
  Player[] players;

  Map() {
    toUpdate = new ArrayList<GameObject>();
    obstacles = new ArrayList<Obstacle>();
    players = new Player[100];
  }

  void draw() {  // maybe call individual display functions depending on weight. toDisplay only accepts "displayable"  
    for (int i=0; i<toUpdate.size(); i++) {
      GameObject o = toUpdate.get(i);
      o.update();
      int x = (int) (o.pos.x-p.pos.x+width/2);
      int y = (int) (o.pos.y-p.pos.y+height/2);
      o.display(x, y);
    }
    for (int i=0; i<=numberOfPlayers; i++) {
      if (i>0) {
        players[i-1].update();
      }
    }
  }

  void addPlayer(Player p) {
    players[numberOfPlayers] = p;
    numberOfPlayers ++;
    println("nop: " + numberOfPlayers);
  }
  void loadMap() {
  }
  void saveMap() {
  }
}