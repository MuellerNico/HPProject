/*--------------------
Game handles everything in a session outside the map. 
this incluedes players, networking, fetchting player data with net input, 
score, objectives, chat
-----------------*/

class Game {
  
  String textchat;
  long startTime;
  Player[] players = new Player[100];
  
  Game(){
    
  }
  
  void fetchPlayerData(){
  }
  
}