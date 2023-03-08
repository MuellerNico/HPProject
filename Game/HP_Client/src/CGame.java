import processing.core.PVector;
import processing.data.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;

import static java.lang.Math.random;


class CGame {     // logical part of local game: predicts pos, updates, calls special anim (collision)

    static final int UPDATE_RATE = 30;
    private static final int TICK_DURATION = 1000 / UPDATE_RATE;  // duration of tick in millis

    // maybe make these private and pass to screen through params in render query
    LocalPlayer localPlayer;
    ArrayList<CPlayer> players = new ArrayList<>();     // also contains localPlayer, good?
    ArrayList<Obstacle> obstacles = new ArrayList<>();

    private Screen screen;
    private Thread gameLoop;
    private HashMap<String, CPlayer> getPlayerByIp = new HashMap<>();   // no localPlayer


    CGame(Client client) {
        gameLoop = new Thread(this::gameLoop);
        localPlayer = new LocalPlayer(this, client);
    }


    void start() {  // localPlayer here, initiate all objects, only call once

        localPlayer.position.set(100, 100);     // global position. nothing to do with screen display
        players.add(localPlayer);

        obstacles.add(new Obstacle(new PVector(120, 120), 400, 400));   // TODO: map construction method

        screen = new Screen(this);
        screen.renderQueue.add(localPlayer);
        screen.renderQueue.addAll(obstacles);

        gameLoop.start();
    }


    void applyPlayerData(JSONObject data) {
        String ip = data.getString("ip");
        if (!ip.equals(CMain.localIp)) {
            CPlayer p = getPlayerByIp.get(ip);
            if (p != null) {
                p.applyData(data);
            } else {
                this.newPlayer(ip);
            }
        }
    }   // called by Client.listener Thread


    void gameEvent(JSONObject event){
        String eventType = event.getString("eventType");
        switch (eventType){
            case Constants.EventType.SPELL:
                //new Spell(event);
        }
    }


    private void newPlayer(String ip) {  // adds to list, initiate, apply profile data (img, stats, name)
        CPlayer p = new CPlayer();
        players.add(p);
        getPlayerByIp.put(ip, p);
        screen.renderQueue.add(p);
    }


    private void gameLoop() { // TODO: (!) delta_time based
        long lastTick = 0;

        while (true) {    // tmp: fixed tick rate
            if (System.currentTimeMillis() - TICK_DURATION > lastTick) {
                lastTick = System.currentTimeMillis();

                // do update: add velocities (until receiving adjustment data from server)
                // call animations from screen class
                players.forEach(CPlayer::update);
            }
        }
    }


    boolean collision(PVector v, Obstacle o) {  // overload later
        if (v.x > o.position.x && v.x < o.position.x + o.w) {
            if (v.y > o.position.y && v.y < o.position.y + o.h) {
                return true;
            }
        }
        return false;
    }
}