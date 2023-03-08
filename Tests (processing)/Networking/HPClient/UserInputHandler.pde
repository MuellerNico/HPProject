class UserInputHandler { // USER INPUT

  public HashMap<Character, Boolean> keyDown;
  public HashMap<Character, PVector> movKeys;
  Player assignedPlayer; //prob not needed

  UserInputHandler() {

    keyDown = new  HashMap<Character, Boolean>();
    movKeys = new HashMap<Character, PVector>() {
      {
        put('w', new PVector(0, -1));
        put('a', new PVector(-1, 0));
        put('s', new PVector(0, 1));
        put('d', new PVector(1, 0));
      }
    };

    for (char k : movKeys.keySet()) {
      keyDown.put(k, false);
    }
  }

  void down(Character k){
    keyDown.put(key, true);
    if(movKeys.keySet().contains(k)){
      LOCAL_PLAYER.dir.add(movKeys.get(k));
    }
  }
  
  void up(Character k){
    keyDown.put(key, false);
    if(movKeys.keySet().contains(k)){
      LOCAL_PLAYER.dir.sub(movKeys.get(k));
    }
  }
}
