package core.physics;

import gui.Screen;
import processing.core.PVector;

import java.awt.geom.Rectangle2D;
import java.awt.geom.RectangularShape;

/**
 * A hit box is either a rectangle or a circle
 *
 * DO NOT access shape directly. use getShape() instead!
 *
 * every rect hit box also has an additional circular hit box around it to improve performance
 * <p>
 * The PVector passed through the constructor should normally NOT be a v.copy(). you want the
 * hit box to move with it's entity/obstacle. Exception might be a shield
 */

public abstract class HitBox {

    RectangularShape shape;
    // TODO: public GameObject parent;
    public PVector position;    // reference to parent position
    int r;

    HitBox(PVector position, int r) {
        this.position = position;
        this.r = r;
    }

    public abstract RectangularShape getShape();

    public static boolean collision(HitBox a, HitBox b) {

        if (PVector.dist(a.position, b.position) >= a.r + b.r)  // mostly the case, cheap
            return false;

        else if (a instanceof CircularHitBox && b instanceof CircularHitBox)
            return true;

        else if (b instanceof RectHitBox)
            return a.getShape().intersects((Rectangle2D.Float) b.getShape());

        else if (a instanceof RectHitBox)
            return b.getShape().intersects((Rectangle2D) a.shape);

        else return false;   // should not reach
    }

    public String toString(){
        return String.format("HitBox@ %s", position.toString());
    }

    public abstract void render(Screen s);  // only for debugging
}
