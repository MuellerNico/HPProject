
//192.168.1.117:2709
import java.util.Arrays;
import processing.net.*; 
import javax.swing.*;

Client c; 
boolean firstDraw = true;
boolean RDY_TO_PLAY = false;
String LOCAL_IP;
String SERVER_IP;
int SERVER_PORT;
UserInputHandler uih;
NetworkCommunicationHandler nch;
Player LOCAL_PLAYER;
Game game;

void setup() {
  frameRate(30);
  size(600, 400);
  nch = new NetworkCommunicationHandler();
  connectToServer();

  game = new Game();
  uih = new UserInputHandler();
  //LOCAL_PLAYER = game.newPlayer(c.ip(), new PVector(0, 0));
}

void draw() {
  if (firstDraw) {   //window start position
    surface.setLocation(700, 10);
    firstDraw = false;
  }
  if (RDY_TO_PLAY) {
    game.gameloop();
  }
}

void connectToServer() {
  String address = JOptionPane.showInputDialog("Enter IP and Port \n(format: 192.168.1.111:1234) \ninvalid IP will cause a crash");
  String a[] = address.split(":");
  SERVER_PORT = Integer.parseInt(a[1]);
  SERVER_IP = a[0];
  c = new Client(this, SERVER_IP, SERVER_PORT);
  LOCAL_IP = c.ip();
  println("SUCCESS now connected to: " + SERVER_IP + " port: " + SERVER_PORT + "\nYour IP: " + LOCAL_IP);
}

void clientEvent(Client c) {
  String inString = c.readString();
  if (inString != null && inString != "") {
    println("inString: " + inString);
    nch.getData(inString);
    c.clear();
  }
}

void keyPressed() {
  if (RDY_TO_PLAY) {
    try {
      if (uih.keyDown.get(key) == false) {
        println("keydown: " + key);
        uih.down(key);
      }
    }
    catch(Exception e) {
      println("unknown key");
    }
  }
}

void keyReleased() {
  if (RDY_TO_PLAY) {
    uih.up(key);
  }
}
