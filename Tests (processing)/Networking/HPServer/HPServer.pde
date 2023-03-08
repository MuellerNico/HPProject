/* Game will not work when:
  a player disconnects :/


*/


import g4p_controls.*;
import java.util.Arrays;
import javax.swing.*;
import java.net.InetAddress;
import java.net.UnknownHostException;

boolean firstDraw = true;

int PORT = 2709;
String IP;
Server s;
ArrayList<Client> clients;
HashMap<String, Player> getPlayer;
HashMap<Player, Client> getClient;
GWindow controlPanel;
Game game;

void setup() {
  size(600, 400);
  frameRate(30);
  game = new Game();
  clients = new ArrayList<Client>();
  getPlayer = new HashMap<String, Player>();
  getClient = new HashMap<Player, Client>();
  setupServer();
  controlPanel = GWindow.getWindow(this, "Server Information", 630, 10, 300, 500, JAVA2D);
  controlPanel.addDrawHandler(this, "cpDraw");
  controlPanel.setActionOnClose(G4P.KEEP_OPEN);
}

void draw() {
  if (firstDraw) {   //window start position
    surface.setLocation(10, 10);
    firstDraw = false;
  }

  for (Client c : clients) { //handle communication, TODO: separate class
    if (c != null) {
      String input = c.readString(); 
      if (input != null) {
        input = input.substring(0, input.indexOf("\n")); // only 1 line, ??
        String[] s = input.split(",");

        switch(s[0]) {
        case "i":
          i(c, s);
        }
      }
    }
  }
  String output = "";
  for (Player p : game.players) {
    output += (p.wrapData() + "\n");
  }
  s.write(output); 
  background(13, 55, 13); 
  game.update();
}

void serverEvent(Server ser, Client newClient) {
  clients.add(newClient); 
  println("We have a new client: " + newClient.ip() + "\ninitializing..."); 
  //get player info (stats, appereance)
  Player p = game.newPlayer(newClient); 
  game.players.add(p); 
  getPlayer.put(newClient.ip(), p); 
  getClient.put(p, newClient); 
  //tell others about new Player
  println("new players data: " + p.wrapData());  
  newClient.write("n," + game.players.size() + ",\n"); // only number of players. precise data is received in first tick within the default s.write
  s.write("p," + p.IP + "," + p.wrapData() + ",\n");
  println("finished server init");  // later maybe add appereance of players here and for the new Client in the 
  println("number of players: " + game.players.size());
}

void disconnectEvent(Client c) { // TODO: Tell others that player left!
  println("client disconnected"); 
  //Player rp = getPlayer.get(c.ip());
  clients.remove(c); 
  game.players.remove(getPlayer.get(c.ip())); 
  getPlayer.remove(c.ip()); 
  getClient.remove(getPlayer.get(c.ip())); 
  println("remaining players: " + game.players.size());
}

void setupServer() {
  if (JOptionPane.showConfirmDialog(null, "Do you want to start an awesome server?") != 0) {
    exit();
  } else {
    try {
      IP = InetAddress.getLocalHost().getHostAddress(); 
      System.out.println("Current IP address : " + IP); 
      s = new Server(this, PORT);
    }
    catch (UnknownHostException e) {
      e.printStackTrace();
    }
    JOptionPane.showMessageDialog(frame, "Server now ready to join at: " + IP + ":" + PORT + " (close window for interaction)");
  }
}

void i(Client c, String[] s) {
  float[] data = stringToFloat(s); 
  Player p = getPlayer.get(c.ip()); 
  p.vel.set(data[1], data[2]); 
  p.orientation.set(data[3], data[4]); 
  p.update(); 
}
