class NetworkCommunicationHandler {

  NetworkCommunicationHandler() {
  }

  void sendData() {
    c.write(String.format("i,%f,%f,%f,%f\n", 
      LOCAL_PLAYER.vel.x, 
      LOCAL_PLAYER.vel.y, 
      LOCAL_PLAYER.orientation.x, 
      LOCAL_PLAYER.orientation.y));
    //println("sent data");
  }

  void getData(String input) {
    //if (Character.isDigit(input.charAt(0))) {
    //  updatePlayers(input);
    //  println("true");
    // } else {
    //String[] s = input.split(",");
    char reqType = input.charAt(0);//s[0];
    String[] s;

    switch(reqType) {
    case 'p':
      input = input.substring(0, input.indexOf("\n"));
      s = input.split(",");
      //println("P EVENT");
      p(s);
      break;

    case 'n':
      input = input.substring(0, input.indexOf("\n"));
      s = input.split(",");
      println("N EVENT");
      n(s);
      break;

    default:
      updatePlayers(input);
    }
  }

  void updatePlayers(String input) { // every tick data: pos and orien of all players (later spells)
    String[] data = input.split("\n");
    for (int i=0; i<game.players.size(); i++) { // todo NEXT LINE NOT SAME     
      String[] playerData = data[i].split(",");
      float[] values = stringToFloat(playerData, 0);
      Player p = game.players.get(i);
      p.pos.set(values[0], values[1]);
      p.orientation.set(values[2], values[3]);
    }
  }

  void p(String[] s) { // new Player joined
    if (!s[1].equals(LOCAL_IP)) {
      println("P: new player joined");
      String ip = s[1];
      float[] v = stringToFloat(s, 2);
      Player newPlayer = game.newPlayer(ip, v);
    }
  }
  void n(String[] s) {
    //println("1");
    int numOfPlayers = Integer.parseInt(s[1]);
    for (int i=0; i<numOfPlayers-1; i++) {
      Player p = game.newPlayer("", new PVector());
      println("player added");
      //println("2");
    }
    LOCAL_PLAYER = game.newPlayer(c.ip(), new PVector());
    RDY_TO_PLAY = true;
    println("ready to play?, # of players: " + game.players.size());
  }
}
