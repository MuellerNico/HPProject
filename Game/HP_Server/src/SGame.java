import processing.data.JSONArray;
import processing.data.JSONObject;

import java.net.InetAddress;
import java.util.ArrayList;
import java.util.HashMap;

public class SGame {

    ArrayList<SPlayer> players = new ArrayList<>();
    private HashMap<InetAddress, SPlayer> getPlayerByAddress = new HashMap<>();
    public HashMap<String, SPlayer> getPlayerByIp = new HashMap<>();

    private Thread gameLoop;    // currently started by client during connection
    private boolean isRunning = false;
    private static final int TICKRATE = 32;
    private static final int TICKDURATION = 1000/TICKRATE;  // duration of tick in millis

    public JSONObject gameState = new JSONObject();

    SGame(){
        gameLoop = new Thread(this::gameLoop);  // no automatic start due to other setup. run game with game.start()
    }


    public void start() {
        if (!isRunning) {   // only call once
            isRunning = true;

//            JSONArray players = new JSONArray();
//            gameState.put("players", players);

            gameLoop.start();
        }
    }


    void newPlayer(InetAddress address, int port) {  // adds to list, initiate, apply profile data (img, stats, name)
        SPlayer p = new SPlayer(address, port);
        players.add(p);
        System.out.println("NEW PLAYER: " + players.size());
        getPlayerByAddress.put(address, p);
        getPlayerByIp.put(address.getHostAddress(), p);
    }


    void applyPlayerData(JSONObject data){
        String ip = data.getString("ip");
        getPlayerByIp.get(ip).applyData(data);
    }


    private void gameLoop() { // main game loop
        long lastTick = 0;

        while (true) {    // tmp: fixed tick rate
            if (System.currentTimeMillis() - TICKDURATION > lastTick) {
                lastTick = System.currentTimeMillis();

                for (SPlayer p : players) {
                    p.update();
                }
            }
        }
    }


    byte[] getGameState(){
        JSONArray playersJson = new JSONArray();
        for(SPlayer p : players){
            playersJson.append(p.data);
        }
        gameState.put("players", playersJson);
        return gameState.toString().getBytes();
    }

    public void handlePlayerAction(JSONObject action) {
        String actionType = action.getString("actionType");
        switch (actionType){
            case Constants.ActionType.SPELL:
        }
    }
}



