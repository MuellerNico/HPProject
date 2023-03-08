package core;

import core.physics.CircularHitBox;
import gui.Screen;
import main.Settings;
import processing.core.PVector;
import processing.data.JSONObject;
import java.net.InetAddress;

public class Player extends Entity {   // on client

    public PVector velocity = new PVector();
    public PVector orientation = new PVector();

    public String name;
    public JSONObject profile;

    public int port;
    public InetAddress address;

    public Player(World world, JSONObject profile) {

        super(world);

        this.world = world;
        this.profile = profile;
        this.name = profile.getString("name");
        this.hitBox = new CircularHitBox(position, Settings.playerRadius);
    }


    public void applyData(JSONObject data) {    // not called on localPlayer. one-directional
        //this.data = data;
        this.position.set(data.getInt("posX"), data.getInt("posY"));
        this.velocity.set(data.getInt("velX"), data.getInt("velY"));
        this.orientation.set(data.getInt("oriX"), data.getInt("oriY"));
    }


    @Override
    public void update() {
        position.add(velocity);
    }


    public void render(Screen s) {
        s.pushMatrix();
        s.pushStyle();
        s.translate(position);
//        s.rotate(this.orientation.heading());
//        s.image(img, 0, 0);
        s.fill(89, 25, 132);
        s.ellipse(0, 0, Settings.playerRadius, Settings.playerRadius);
        s.popStyle();
        s.popMatrix();
    }
}
