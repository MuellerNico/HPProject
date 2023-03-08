package core;

import core.physics.RectHitBox;
import gui.Screen;
import processing.core.PConstants;
import processing.core.PVector;

public class Obstacle extends GameObject{

    private int width, height;

    Obstacle(World world, PVector position, int w, int h) {
        super(world);
        this.position = position;
        this.position.z = GameConstants.Level.FENCE.ordinal();
        this.width = w;
        this.height = h;
        hitBox = new RectHitBox(position, width, height);
    }


    public void render(Screen s) {
        s.pushStyle();
        s.fill(100);
        s.rectMode(PConstants.CORNER);
        s.rect(position.x, position.y, width, height);
        s.popStyle();
    }
}
