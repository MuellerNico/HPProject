import processing.net.*;
import g4p_controls.*;
import java.util.Arrays;
import javax.swing.*;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.Stack;
import java.util.StringJoiner;

// - Server Settings -
GWindow informationPanel;
HPServer server;
Game game;

boolean firstDraw = true;

void setup() { 

  frameRate(HPServer.TICK_RATE);
  size(600, 400);
  fill(255);
  game = new Game();

  // create tcp server 
  server = new HPServer(this);
  println("waiting for players...");

  // information and control window
  println("\ncreating additional windows with:");
  informationPanel = GWindow.getWindow(this, "Server Information", 630, 10, 300, 500, JAVA2D);
  println("\n");
  informationPanel.addDrawHandler(this, "cpDraw");
  informationPanel.setActionOnClose(G4P.KEEP_OPEN);
}

//---------------|| DRAW  ||---------------
void draw() {
  if (firstDraw) {   
    // set window start positionition
    surface.setLocation(10, 10);
    firstDraw = false;
  }

  server.handleInput();
  game.update();
}

void serverEvent(Server s, Client newClient) {  
  server.clientConnected(newClient);
}
