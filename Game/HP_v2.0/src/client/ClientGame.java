package client;

import core.LocalPlayer;
import core.Player;
import core.World;
import gui.GameScreen;
import main.NameDialog;
import main.Settings;
import processing.data.JSONArray;
import processing.data.JSONObject;

import java.net.InetAddress;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * "manager layer" between:
 * <p>
 * client, world, screen, localPlayer
 * <p>
 * - modifies world according to client (net) inputs
 * - passes chunks to screen // nope
 * - keeps track of score and maybe UI logic
 * - inputs are handled by LocalPlayer
 */

public class ClientGame {

    public World world;
    public Client client;
    public GameScreen screen;
    public LocalPlayer localPlayer;

    private List<Player> players = new ArrayList<>();    // no localPlayer
    private Map<String, Player> playersByName = new HashMap<>(); // no localPlayer


    public ClientGame(InetAddress address, int port, int localPort) {

        world = new World();
        client = new Client(this, localPort);

        // "load" profile
        JSONObject profile = new JSONObject().put("name", NameDialog.requestUserName());
        localPlayer = new LocalPlayer(this, profile);
        System.out.println("ClientGame: chosen name: " + localPlayer.name);
        screen = new GameScreen(this);

        connect(address, port);

        new Thread(this::gameloop, "game-loop").start();
    }


    private void connect(InetAddress address, int port) {
        JSONObject init = client.connect(address, port);
        world.init(init);

        JSONArray playerArray = init.getJSONArray("players");

        for (int i = 0; i < playerArray.size(); i++) {
            newPlayer(playerArray.getJSONObject(i));
        }
    }

    void applyPlayerData(JSONObject jsonData) {
        String name = jsonData.getString("name");
        Player p = playersByName.get(name);

        if (p != null && !name.equals(localPlayer.name)) {
            p.applyData(jsonData);
        }
    }

    void newPlayer(JSONObject profile) {
        Player p = new Player(world, profile);

        players.add(p);
        playersByName.put(profile.getString("name"), p);

        System.out.println("player added. players: (" + players.size() + ") " + playersByName.keySet());
    }

    void removePlayer(String name) {
        players.remove(playersByName.get(name));
        playersByName.remove(name);
        System.out.println("ClientGame.removePlayer: " + name);
    }

    private void gameloop() {
        long lastTick = System.currentTimeMillis();
        while (true) {
            if (System.currentTimeMillis() - lastTick > 1000 / Settings.tickRate) {
                lastTick = System.currentTimeMillis();
                world.update();
            }
        }
    }
}
