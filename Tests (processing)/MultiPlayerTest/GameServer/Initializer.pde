
// handle new client, check his data, put him in game without lag for others
// newClient is only passed into "clients" at the very \r
public class PlayerInitializer implements Runnable { 

  private Client newClient;

  PlayerInitializer(Client newClient) {
    this.newClient = newClient;
  }

  public void run() {

    println("- initializing player in seperate thread");
    if (game.numberOfPlayers >= game.maxNumberOfPlayers) {
      println("(!) maximum players reached");
    } else {

      while (true) {
        String inputString = newClient.readString(); 
        if (inputString != null) {
          inputString = inputString.substring(0, inputString.indexOf("\r"));  // Only up to the newline
          println(inputString + " (from init)");         
          if (inputString.charAt(0) == '{') {
            JSONObject json = JSONObject.parse(inputString);
            if (json.getString("eventType").equals("join")) {

              // initializing new player, TODO: part of this in game object
              int slot = game.emptySlots.pop();
              Player p = new Player(newClient, slot);
              game.players[slot] = p;
              game.numberOfPlayers ++;
              game.getPlayer.put(newClient.ip(), p);
              p.position.set(10, 20);  // TODO: not hardcoded
              server.clients.add(newClient);

              // send confirmation
              sendInitData();
              break;
            }
          }
        }
      }
    }
  }

  void sendInitData() {  // TODO: position needed for smooth predictedPosition
    JSONObject initData = new JSONObject();
    JSONObject players = new JSONObject();
    JSONObject player = new JSONObject();

    for (int i=0; i<game.numberOfPlayers; i++) {
      player = game.players[i].profile;
      players.put(Integer.toString(game.players[i].slot), player);
    }

    initData.put("eventType", "initSuccess");
    initData.put("numberOfPlayers", game.numberOfPlayers);
    initData.put("players", players);

    newClient.write(initData.toString()+"\r");
    println(initData.toString());
    
  }
}
