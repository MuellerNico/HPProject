package server;

import core.Player;
import core.World;
import server.Server;
import processing.data.JSONArray;
import processing.data.JSONObject;

import java.net.InetAddress;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ServerGame {

    Server server;
    World world;

    public ArrayList<Player> players = new ArrayList<>();
    public Map<String, Player> playersByName = new HashMap<>();


    public ServerGame(int port) {
        world = new World();    // todo: load map
        server = new Server(this, port);
        server.start();
    }

    public void newPlayer(JSONObject profile, InetAddress address, int port) {
        Player p = new Player(world, profile);
        p.address = address;
        p.port = port;

        players.add(p);
        playersByName.put(profile.getString("name"), p);

        System.out.println("player added. players: " + players.size() + playersByName.keySet());
    }

    public void applyPlayerData(JSONObject jsonData) {
    }

    public void handlePlayerAction(JSONObject jsonData) {
    }

    public void removePlayer(InetAddress address) {
    }

    public JSONObject getStatus(){
        JSONObject status = new JSONObject();
        JSONArray playerList = new JSONArray();

        for (Player p : players){
            playerList.append(p.profile);
        }
        status.put("players", playerList);
        // more
        status.put("confirmation", true);
        return status;
    }
}
