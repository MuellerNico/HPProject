package core.physics;

import gui.Screen;
import processing.core.PConstants;
import processing.core.PVector;
import java.awt.geom.Rectangle2D;
import java.awt.geom.RectangularShape;

public class RectHitBox extends HitBox {

    public RectHitBox(PVector pos, int w, int h) {
        super(pos, w + h);
        shape = new Rectangle2D.Float(pos.x, pos.y, w, h);
    }

    @Override
    public RectangularShape getShape() {
        shape.setFrame(position.x, position.y, shape.getWidth(), shape.getHeight());
        return shape;
    }

    @Override
    public void render(Screen s) {
        s.pushStyle();
        s.noFill();
        s.stroke(255, 0, 0);
        s.rect(this.getShape());
        s.popStyle();
    }
}
