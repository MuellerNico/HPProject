// has hitbox

abstract class Obstacle extends GameObject {

  float w, h;
  int r;

  Obstacle(PVector p) {
    super(p);
    map.obstacles.add(this);
  }
}