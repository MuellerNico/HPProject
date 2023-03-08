import processing.core.PApplet;
import processing.core.PVector;

public class Spell implements Displayable{    // tmp for testing, TODO: move to spells. Problem: Displayable not visible there

    PVector position;
    PVector velocity;

    private Spell(PVector position, PVector velocity){
        this.position = position;
        this.velocity = velocity;
    }


    public void update(){
        position.add(velocity);
    }


    public void render(PApplet parent, PVector offset) {
        parent.fill(255);
        parent.ellipse(this.position.x - offset.x,this.position.y - offset.y, 15, 15);
    }



}
