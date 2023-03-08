package core;

import core.physics.HitBox;
import core.physics.RectHitBox;
import gui.Screen;
import processing.core.PApplet;
import processing.core.PVector;

public abstract class GameObject {

    public PVector position = new PVector();
    public World world;
    public HitBox hitBox;

    GameObject(World world) {
        this.world = world;
        this.world.gameObjects.add(this);
    }

    // always render at position
    public void render(Screen s) {
    }

    //public void onCollision(GameObject go) {}
}
