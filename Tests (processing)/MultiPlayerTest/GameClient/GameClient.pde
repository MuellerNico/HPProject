//192.168.1.117:5005
import java.util.Arrays;
import processing.net.*; 
import javax.swing.*;
import java.io.*;

Client localClient; 
boolean firstDraw = true;
boolean readyToJoin = false;
String LOCAL_IP;
String SERVER_IP;
int SERVER_PORT;
String inputString;

HashMap<Character, Boolean> keyDown;

LocalPlayer localPlayer;
Game game;

int cnter = 0;

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
  initialize();
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
      if (inputString.indexOf("\r") > 0) {
        if (inputString.contains("{")) {  // FIX: get position data anyway
          int jsonStart = inputString.indexOf("{");
          String jsonString = inputString.substring(jsonStart, inputString.indexOf("\r", jsonStart));
          game.gameEvent(JSONObject.parse(jsonString));
        } else { 
          inputString = inputString.substring(0, inputString.indexOf("\r"));
          game.applyData(float(split(inputString, ',')));
        }
      }
    }
  }
}

void mousePressed() {  // useless since mouse pressed is called at the \r
  println("sent test " + cnter);
  localClient.write("{'eventType':'test'}\r");
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
