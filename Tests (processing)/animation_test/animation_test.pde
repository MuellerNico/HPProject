
ArrayList<Particle> particles = new ArrayList<Particle>();
final int FRAMERATE = 30;

void setup() {
  frameRate(FRAMERATE);
  size(600, 400);
  noStroke();
}

void draw() {
  background(200);
  for (int i=0; i<particles.size(); i++) {
    particles.get(i).update();
  }
  if (mousePressed) spell(new PVector(mouseX, mouseY), new PVector(mouseX-pmouseX, mouseY-pmouseY).setMag(10));
}


void spell(PVector pos, PVector vel) {
    PVector v = vel
      .copy()
      .mult(-1)
      .rotate(random(-PI/4, PI/4));

    new Particle(color(255, 0, 0), pos, v); 
}
