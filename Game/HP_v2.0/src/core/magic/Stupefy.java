package core.magic;

import core.GameConstants;
import core.World;
import core.physics.CircularHitBox;
import gui.Screen;
import processing.core.PVector;

import java.awt.*;

public class Stupefy extends Spell {

    private PVector velocity;
    private Color color = new Color(140, 0, 0);
    private int speed = 70;


    public Stupefy(World world, PVector position, PVector orientation) {
        super(world);
        this.position = position;
        this.position.z = GameConstants.Level.SPELL.ordinal();
        this.velocity = orientation.setMag(speed);
        this.hitBox = new CircularHitBox(position, 10);
    }


    @Override
    public void update() {
        position.add(velocity);
    }


    @Override
    public void render(Screen s) {
        s.pushStyle();
        s.fill(color.getRGB());
        s.ellipse(hitBox.getShape());   // tmp
        s.popStyle();
    }
}
