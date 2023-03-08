package core.physics;

import gui.Screen;
import processing.core.PVector;

import java.awt.geom.Ellipse2D;
import java.awt.geom.RectangularShape;

public class CircularHitBox extends HitBox {

    public CircularHitBox(PVector pos, int r) {
        super(pos, r);
        shape = new Ellipse2D.Float(pos.x - r, pos.y - r, r*2, r*2);
    }

    @Override
    public RectangularShape getShape() {
        shape.setFrame(position.x - r, position.y - r, shape.getWidth(), shape.getHeight());
        return shape;
    }

    @Override
    public void render(Screen s) {
        s.pushStyle();
        s.noFill();
        s.stroke(255, 0, 0);
        s.ellipse(this.getShape());
        s.popStyle();
    }
}
