package gui;

import processing.core.PApplet;
import processing.core.PVector;

import java.awt.geom.RectangularShape;

/***
 * Extended PApplet. Added features and utilities like:
 * - PVector as parameter in major functions
 * - draw methods for RectShapes
 */

public abstract class Screen extends PApplet {  // TODO: renderQueue?


    public void settings() {
        fullScreen(P3D, 2);
    }

    public void translate(PVector v) {
        translate(v.x, v.y, v.z);
    }

    public void rect(RectangularShape r) {  // TODO: remove confusion around ellipseMode!
        pushStyle();
        rectMode(CORNER);
        rect((float) r.getX(), (float) r.getY(), (float) r.getWidth(), (float) r.getHeight());
        popStyle();
    }

    public void ellipse(RectangularShape e) {
        pushStyle();
        ellipseMode(CORNER);
        ellipse((float) e.getX(), (float) e.getY(), (float) e.getWidth(), (float) e.getHeight());
        popStyle();
    }

    public void ellipse(PVector v, float r1, float r2) {
        translate(v.x, v.y, v.z);
        ellipse(0, 0, r1, r2);
        translate(-v.x, -v.y, -v.z);
    }

    public void rect(PVector v, float w, float h){
        translate(v.x, v.y, v.z);
        rect(0, 0, w, h);
        translate(-v.x, -v.y, -v.z);
    }
}
