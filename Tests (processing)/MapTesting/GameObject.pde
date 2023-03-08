// PASSIVE only display

abstract class GameObject { // everything inside the map

  PVector pos;

  GameObject(PVector p) {
    pos = p.copy();
  }
  GameObject() {
    pos = new PVector(0, 0);
  }

  void update() {}
  abstract void display(int x, int y);
}