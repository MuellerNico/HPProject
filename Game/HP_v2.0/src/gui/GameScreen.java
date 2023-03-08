package gui;

import core.*;
import client.ClientGame;
import core.physics.HitBox;
import main.Settings;
import processing.core.PApplet;
import processing.core.PVector;


public class GameScreen extends Screen {


    private LocalPlayer localPlayer;
    private ClientGame game;
    private World world;

    public PVector screenCenter;


    public GameScreen(ClientGame game) {
        this.game = game;
        this.world = game.world;
        this.localPlayer = game.localPlayer;
        PApplet.runSketch(new String[]{"--present", GameScreen.class.getName()}, this);
    }


    public void setup() {   // everything Processing-related
        frameRate(Settings.fps);   // tmp
        ellipseMode(RADIUS);
        rectMode(CORNER);
        fill(255);
        noStroke();

        screenCenter = new PVector((float) width / 2, (float) height / 2);
    }


    // drawing

    public void draw() {
        renderGame();
        // GUI

        text("FPS: " + (int) frameRate, 10, 20);
    }


    private void renderGame() {     // graphics only. not variable changing

        pushMatrix();
        background(13, 55, 13);
        translate(PVector.sub(screenCenter, localPlayer.position));

       for (int i=0; i<world.gameObjects.size(); i++)
           world.gameObjects.get(i).render(this);

        if (Settings.debugMode)
            drawDebugInfo();

        popMatrix();
    }


    // User input

    public void keyPressed() {
        localPlayer.keyPressed(key);
    }

    public void keyReleased() {
        localPlayer.keyReleased(key);
    }

    public void mouseMoved() {
        localPlayer.mouseMoved(this);
    }

    public void mousePressed() {
        localPlayer.mousePressed();
    }


    // Debug

    private void drawDebugInfo(){
        pushMatrix();
        pushStyle();

        translate(0,0, GameConstants.Level.GUI.ordinal());
        drawHitBoxes();
        drawOrigin();
        drawObjectPositions();

        popStyle();
        popMatrix();
    }

    private void drawObjectPositions() {
        for (GameObject o : game.world.gameObjects) {
            pushMatrix();
            translate(0,0,o.position.z + 1);    // above
            ellipse(o.position.x, o.position.y, 3, 3);
            popMatrix();
        }
    }

    private void drawHitBoxes() {
        for (GameObject e : game.world.gameObjects) {
            HitBox b = e.hitBox;
            b.render(this);
            fill(255);
            text(b.toString(), (float) (b.position.x - b.getShape().getWidth()/2), b.position.y + 1);
        }
    }

    private void drawOrigin() {
        fill(102, 0, 102);
        ellipse(0, 0, 20, 20);
        fill(255);
        //text("ORIGIN", -20, 5);
    }
}
