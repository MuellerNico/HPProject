// in general: tcp with JSON for gameEvents (spells, item interaction, death)
// later udp now tcp with int array (pos, or, dir, speed, hp)
// using \r as \r of message (\n used in json)

public class HPServer {  

  public static final int TICK_RATE = 32;
  public static final int JSON_PORT = 5005;  // TODO: lobby
  //public static final int DATA_PORT = 5002;

  public String IP;

  public Server tcpConnection;
  public Server dataConnection;
  public ArrayList<Client> clients; // already initialized

  private Client currentClient;
  private String inputString;
  private String jsonString;
  private int[] inputData;

  HPServer(PApplet parent) {
    try {
      IP = InetAddress.getLocalHost().getHostAddress();  
      tcpConnection = new Server(parent, JSON_PORT);
      //dataConnection = new Server(parent, DATA_PORT);
      println("(!) SUCCESS: server created at: " + IP + ":" + JSON_PORT);
    }
    catch (UnknownHostException e) {
      e.printStackTrace();
      println("(!) ERROR: unable to setup server socket \ncheck log for details");
    }
    clients = new ArrayList<Client>();  // FIX: "should" contain all clients and not just players (spectators etc)
  }



  void handleInput() {
    for (int i=0; i<clients.size(); i++) {  // not most efficient way but equal for everyone
      currentClient = clients.get(i);
      inputString = currentClient.readString(); 
      if (inputString != null) {              
        if (inputString.contains("{")) {  // FIX: get position data anyway
          int jsonStart = inputString.indexOf("{");
          jsonString = inputString.substring(jsonStart, inputString.indexOf("\r", jsonStart));
          game.gameEvent(JSONObject.parse(jsonString));
        } else { 
          inputString = inputString.substring(0, inputString.indexOf("\r"));
          game.applyData(float(split(inputString, ',')));  
        }
        tcpConnection.write(inputString + "\r");  // repeats to everyone
      }
    }
  }



  // ----- connection events -----
  void clientConnected(Client newClient) {
    println("- new client connected: " + newClient.ip()); 
    new Thread(new PlayerInitializer(newClient)).start();  // thread allows for while loop
  }

  void clientDisconnected(Client client) {   
    // TODO: Tell others that player left!
    print("- client disconnected: " + client.ip()); 
    if (clients.contains(client)) {
      clients.remove(client); 
      game.playerLeft(game.getPlayer.get(client.ip()).slot);  // ugly?
    }
    println("- remaining players: " + game.numberOfPlayers + " -");
  }
}
