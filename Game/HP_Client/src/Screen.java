import processing.core.PApplet;

import java.util.ArrayList;

public class Screen extends PApplet {   // display, render, DOES NOT handle logic except input

    private CGame game;  // contains player data etc
    private LocalPlayer localPlayer;
    ArrayList<Displayable> renderQueue = new ArrayList<>();

    Screen(CGame game) {
        this.game = game;
        this.localPlayer = game.localPlayer;
        PApplet.runSketch(new String[]{"--present", Screen.class.getName()}, this);
    }


    public void settings() {
        fullScreen(2);
    }


    public void setup() {   // processing commands only
        frameRate(CGame.UPDATE_RATE);   // tmp
        imageMode(CENTER);
        ellipseMode(CENTER);
        rectMode(CORNER);
        noStroke();

        for (CPlayer p : game.players) {    // TODO: doesn't look right
            try {
                p.img = loadImage("graphics/" + p.imgName + ".png");
            } catch (Exception e) {
                System.out.println("Screen.setup: invalid file path");
            }
        }
    }


    public void draw() {
        pushMatrix();
        renderGame();
        popMatrix();
        // menu
        // GUI
        fill(255);
        text("FPS: " + (int) frameRate, 10, 10);
    }


    private void renderGame() {     // graphics only. not variable changing

        background(13, 55, 13);
        translate(width / 2, height / 2);

        for (int i = 0; i < renderQueue.size(); i++) {   // concurrent modification
            renderQueue.get(i).render(this, localPlayer.position);
        }
    }


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
}
