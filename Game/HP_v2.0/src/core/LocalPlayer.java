package core;

import java.util.HashMap;

import core.physics.CircularHitBox;
import core.physics.HitBox;
import core.magic.Stupefy;
import gui.GameScreen;
import gui.Screen;
import client.ClientGame;
import main.Settings;
import client.Client;
import main.NetworkConstants;

import processing.core.PConstants;
import processing.core.PVector;
import processing.data.JSONObject;

public class LocalPlayer extends Entity implements NetworkConstants, GameConstants {

    private ClientGame game;
    private Client client;

    private PVector velocity = new PVector();
    private PVector direction = new PVector();
    private PVector orientation = new PVector();

    private int radius = Settings.playerRadius; // tmp
    private int speed = 12;

    public String name;
    public JSONObject profile;
    private JSONObject data = new JSONObject(); // pos, vel etc

    private boolean stateChanged;
    private HashMap<Character, Boolean> keyDown = new HashMap<>();


    public LocalPlayer(ClientGame game, JSONObject profile) {

        super(game.world);

        this.game = game;
        this.client = game.client;
        this.profile = profile;

        position.z = Level.PLAYER.ordinal();
        hitBox = new CircularHitBox(position, radius);

        name = profile.getString("name");
        data.put("name", name);

        keyDown.put('w', false);
        keyDown.put('a', false);
        keyDown.put('s', false);
        keyDown.put('d', false);
    }


    @Override
    public void render(Screen p) {
        p.pushMatrix();
        p.pushStyle();
        p.translate(position);
        p.rotate(orientation.heading());
        p.fill(134, 89, 45);
        p.ellipseMode(PConstants.RADIUS);
        p.ellipse(0, 0, radius, radius);
        p.popStyle();
        p.popMatrix();
    }


    @Override
    public void update() {

        velocity = direction.copy().setMag(speed);

        if (!collision())
            position.add(velocity); // orientation done when mouseMoved

        //if (stateChanged){
            client.send((Headers.PLAYER_DATA + getData().toString()).getBytes());
            stateChanged = false;
        //}
        // energy, cool downs, hp?
    }


    private JSONObject getData() {   // only write to it when needed (game needs to send), int enough precise

        data.put("posX", (int) position.x);
        data.put("posY", (int) position.y);
        data.put("velX", (int) velocity.x);
        data.put("velY", (int) velocity.y);
        data.put("oriX", (int) orientation.x);
        data.put("oriY", (int) orientation.y);

        return data;
    }


    private boolean collision() {
        position.add(velocity);
        for (GameObject go : world.gameObjects) {
            if (!go.equals(this)) {
                if (HitBox.collision(go.hitBox, this.hitBox)) {
                    position.sub(velocity);
                    stateChanged = true;
                    return true;
                }
            }
        }

        position.sub(velocity);
        return false;
    }


    // inputs

    public void keyPressed(char key) {

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

    public void keyReleased(char key) {

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

    public void mouseMoved(GameScreen screen) {
        orientation.set(screen.mouseX - screen.screenCenter.x, screen.mouseY - screen.screenCenter.y);
        stateChanged = true;
    }

    public void mousePressed() {
        new Stupefy(world, position.copy(), orientation.copy()); // player info

    }
}
