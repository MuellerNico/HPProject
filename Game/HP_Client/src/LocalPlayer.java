import processing.core.PApplet;
import processing.core.PVector;
import processing.data.JSONObject;
import processing.event.KeyEvent;

import java.util.HashMap;

class LocalPlayer extends CPlayer{

    private PVector direction = new PVector(0, 0);
    private JSONObject data = new JSONObject();

    private CGame game;
    private Client client;
    private boolean stateChanged;

    private static HashMap<Character, Boolean> keyDown = new HashMap<>();   // static for multiple screens/fields


    LocalPlayer(CGame game, Client client) {

        super();
        this.game = game;
        this.client = client;

        data.put("ip", CMain.localIp);

        keyDown.put('w', false);
        keyDown.put('a', false);
        keyDown.put('s', false);
        keyDown.put('d', false);
    }


    @Override
    void update() {
        velocity = direction.copy().setMag(speed);

        if (!collision())
            position.add(velocity); // orientation done when mouseMoved

        if (stateChanged)
            client.send((Constants.Headers.PLAYER_DATA + getData()).getBytes());
        // energy, cool downs, hp?
    }


    private String getData() {   // only write to it when needed (game needs to send), int enough precise

        data.put("posX", (int) position.x);
        data.put("posY", (int) position.y);
        data.put("velX", (int) velocity.x);
        data.put("velY", (int) velocity.y);
        data.put("oriX", (int) orientation.x);
        data.put("oriY", (int) orientation.y);

        return data.toString();
    }


    private boolean collision() {
        PVector nextPos = this.position.copy().add(this.velocity);
        for (Obstacle obstacle : game.obstacles)
            if (game.collision(nextPos, obstacle))
                return true;
        return false;
    }


    void keyPressed(char key) {

        if (keyDown.get(key) != null) {
            if (!keyDown.get(key)) {

                if (key == 'w') {
                    direction.add(0, -1);
                } else if (key == 'a') {
                    direction.add(-1, 0);
                } else if (key == 's') {
                    direction.add(0, 1);
                } else if (key == 'd') {
                    direction.add(1, 0);
                }

                keyDown.put(key, true);
                stateChanged = true;
            }
        }
    }


    void keyReleased(char key) {

        if (keyDown.get(key) != null) {

            if (key == 'w') {
                direction.sub(0, -1);
            } else if (key == 'a') {
                direction.sub(-1, 0);
            } else if (key == 's') {
                direction.sub(0, 1);
            } else if (key == 'd') {
                direction.sub(1, 0);
            }

            stateChanged = true;
            keyDown.put(key, false);
        }
    }


    void mouseMoved(PApplet screen) {
        orientation.set(screen.mouseX - screen.width / 2, screen.mouseY - screen.height / 2);
        stateChanged = true;
    }


    void mousePressed(){
        JSONObject action = new JSONObject();
        action.put("actionType", Constants.ActionType.SPELL);   // later intensity etc
        client.send((Constants.Headers.PLAYER_ACTION + action.toString()).getBytes());
    }
}
