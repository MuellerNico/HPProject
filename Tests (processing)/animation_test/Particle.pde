class Particle {
  color c;
  PVector p;
  PVector v;
  int size = 10;
  int lifespan = FRAMERATE * 1;
  float timeLeft = 1;

  Particle(color col, PVector pos, PVector vel) {
    c = col;
    p = pos;
    v = vel;
    particles.add(this);
  }

  void update() {
    p.add(v);
    fill(c, timeLeft * 255);
    ellipse(p.x, p.y, size, size);
    timeLeft -= 1.0/lifespan;
  

    if (timeLeft <= 0) {
      particles.remove(this);
    }
  }
}
