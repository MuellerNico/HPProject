// probably tmp

void connectToServer() {
  String address = JOptionPane.showInputDialog("Enter IP and Port \n(format: 192.168.1.111:1234) \ninvalid IP will cause a crash");
  address = address.trim();
  String a[] = address.split(":");
  SERVER_PORT = Integer.parseInt(a[1]);
  SERVER_IP = a[0];
  localClient = new Client(this, SERVER_IP, SERVER_PORT);
  LOCAL_IP = localClient.ip();
  println("connected to: " + SERVER_IP + ":" + SERVER_PORT);  // TODO: also prints when exception is thrown
}

void initialize() {
  String inputString;
  JSONObject player;
  JSONObject players;
  JSONObject initData;
  JSONObject request = new JSONObject();

  request.put("eventType", "join");
  localClient.write(request.toString()+"\r");
  println("sending join request");

  while (true) {
    if (localClient.available() > 0) {
      inputString = localClient.readString();
      if (inputString == null || inputString == "") {
        continue;
      }
      if (inputString.indexOf("\r") > 0) {
        inputString = inputString.substring(0, inputString.indexOf("\r"));
        if (inputString.charAt(0) == '{') {
          println("INIT inString: " + inputString);
          initData = JSONObject.parse(inputString);
          if (initData.getString("eventType").equals("initSuccess")) {
            game.numberOfPlayers = initData.getInt("numberOfPlayers");
            players = initData.getJSONObject("players");
            for (int i=0; i<game.numberOfPlayers; i++) {            
              if (!players.isNull(Integer.toString(i))) {
                player = players.getJSONObject(Integer.toString(i));
                String ip = player.getString("ip");
                int slot = player.getInt("slot");

                if (ip.equals(LOCAL_IP)) {
                  println("found myself in players list...");
                  localPlayer = new LocalPlayer(ip, slot);
                  game.players[i] = localPlayer;
                } else {
                  game.players[i] = new Player(ip, slot);
                }
              }
            }
            break;
          }
        }
      }
    }
  }
  println("(!) SUCCESS: initialized properly");
}
