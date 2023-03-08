import processing.core.PApplet;
import processing.core.PVector;

public interface Displayable {  // TODO: make display without offset at 0,0 possible
    PVector position = new PVector();
    void render(PApplet parent, PVector offset);
}
