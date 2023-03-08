class Desk extends Obstacle {
  
  PImage img;
  
  Desk(PVector p) {
    super(p);
    img = loadImage("table_01.png");
    w = img.width;
    h = img.height;
    r = (int) (sqrt(sq(w)+sq(h)));
    map.toUpdate.add(this);
  }

  void display(int x, int y) {
    image(img, x, y);
  }
}