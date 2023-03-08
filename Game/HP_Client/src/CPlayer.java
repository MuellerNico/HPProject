import processing.core.PApplet;
import processing.core.PImage;
import processing.core.PVector;
import processing.data.JSONObject;

class CPlayer implements Displayable{   // on client

    PVector position = new PVector();
    PVector velocity = new PVector();
    PVector orientation = new PVector();

    PImage img;
    String imgName = "student_griff_01"; // so we can handle load in screen
    int speed = 20;


    void applyData(JSONObject data) {    // not called on localPlayer. one-directional
        //this.data = data;
        this.position.set(data.getInt("posX"), data.getInt("posY"));
        this.velocity.set(data.getInt("velX"), data.getInt("velY"));
        this.orientation.set(data.getInt("oriX"), data.getInt("oriY"));
    }

    void update() {
        position.add(velocity);
    }

    public void render(PApplet parent, PVector offset){
        parent.pushMatrix();
        parent.translate(this.position.x - offset.x, this.position.y - offset.y);
        parent.rotate(this.orientation.heading());
        parent.image(img, 0, 0);
        parent.popMatrix();
    }
}
