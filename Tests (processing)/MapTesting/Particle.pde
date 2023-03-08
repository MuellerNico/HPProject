//-------- copy pasted from tower defense --------------

ArrayList<Particle> particles = new ArrayList<Particle>();

class Particle {
  PVector position;
  PVector velocity;
  float acceleration;
  int birth;
  int lifespan; // in millis
  color c;
  float size;
  float alpha;

  Particle(PVector position_, PVector velocity_, float acceleration_, color c_, float size_, int lifespan_) {
    position = position_;
    velocity = velocity_;
    acceleration = acceleration_;
    c = c_;
    size = size_;
    lifespan = lifespan_;
    alpha = 255;
    particles.add(this);
    birth = millis();
  }

  void update() {

    if (millis() > birth + lifespan) {
      particles.remove(this);
    } else {
      alpha -= 10; //linear fade
      position.add(velocity);
      velocity.mult(1+acceleration);
      pushMatrix();
      translate(position.x, position.y);
      fill(c, alpha);
      ellipse(0, 0, size, size);
      popMatrix();
    }
  }
}


void blood(PVector position_, float intensity_) {
  //general effect
  float intensity = intensity_;//dmg/100
  float roughSpeed = 1 * intensity;
  int numberOfParticles = (int) (10 * intensity);
  int particleLifespan = 1000; //millis
  float acceleration = -0.02;
  color c = color(200, 0, 0);
  float size = 7;

  for (int i=0; i < numberOfParticles; i++) {
    //for each particle random
    PVector direction = PVector.random2D().normalize(); 
    float offset = random(0, p.size);
    PVector partPos = position_.copy();
    partPos.add(direction.copy().setMag(offset));
    float speed = random(roughSpeed/2, roughSpeed*2) * intensity;
    int ls = (int) random(particleLifespan/2, particleLifespan*2);
    
    new Particle(partPos, direction.copy().setMag(speed), acceleration, c, size, ls);
  }
}