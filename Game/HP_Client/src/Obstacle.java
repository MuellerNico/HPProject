import processing.core.PApplet;
import processing.core.PVector;

public class Obstacle implements Displayable{

    PVector position;
    int w, h;

    Obstacle(PVector position, int w, int h) {
        this.position = position;
        this.w = w;
        this.h = h;
    }


    public void render(PApplet parent, PVector offset) {
        parent.fill(100);
        parent.rect(this.position.x - offset.x, this.position.y - offset.y, w, h);
    }
}
