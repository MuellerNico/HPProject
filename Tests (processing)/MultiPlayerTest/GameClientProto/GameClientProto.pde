//192.168.1.117:5005
import java.util.Arrays;
import processing.net.*; 
import javax.swing.*;
import java.io.*;
import java.net.InetAddress;
import java.net.UnknownHostException;

Client localClient; 
boolean firstDraw = true;
boolean readyToJoin = false;
int LOCAL_IP;
String SERVER_IP;
int SERVER_PORT;
String inputString;

HashMap<Character, Boolean> keyDown;

LocalPlayer localPlayer;
Game game;

void setup() {
  frameRate(60);  // TODO: time based update
  size(600, 400);
  game = new Game();
  keyDown = new HashMap<Character, Boolean>();  //todo: cleanup
  keyDown.put('w', false);
  keyDown.put('a', false);
  keyDown.put('s', false);
  keyDown.put('d', false);

  connectToServer();

  try {
    Thread.sleep(1000);
  }
  catch(InterruptedException e) {
    e.printStackTrace();
  }

  localPlayer = new LocalPlayer(LOCAL_IP);
}

void draw() {  //tmp game loop, change that
  // IMPORTANT: until udp connection is setup, Events MUST be sent before  
  localClient.write(localPlayer.wrapData());
  game.update();
}

void clientEvent(Client c) {
  if (c.available()>0) {
    inputString = c.readString();
    if (inputString != null && inputString != "") {
      println("inString: " + inputString);
      inputString = inputString.substring(0, inputString.indexOf("\r"));
      game.applyData(float(inputString.split(",")));
    }
  }
}

void keyPressed() {
  if (keyDown.get(key) != null) {
    if (keyDown.get(key) == false) {
      keyDown.put(key, true);
      if (key == 'w') {
        localPlayer.direction.add(0, -1);
      } else if (key == 'a') {
        localPlayer.direction.add(-1, 0);
      } else if (key == 's') {
        localPlayer.direction.add(0, 1);
      } else if (key == 'd') {
        localPlayer.direction.add(1, 0);
      }
    }
  }
}

void keyReleased() {
  if (keyDown.get(key) != null) {
    keyDown.put(key, false);
    if (key == 'w') {
      localPlayer.direction.sub(0, -1);
    } else if (key == 'a') {
      localPlayer.direction.sub(-1, 0);
    } else if (key == 's') {
      localPlayer.direction.sub(0, 1);
    } else if (key == 'd') {
      localPlayer.direction.sub(1, 0);
    }
  }
}

// tmp
void p(int i) {
  println("check: " + i);
}