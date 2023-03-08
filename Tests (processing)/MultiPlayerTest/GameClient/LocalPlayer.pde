class LocalPlayer extends Player {

  PVector direction;

  LocalPlayer(String ip, int slot) {
    super(ip, slot);
    this.direction   = new PVector();
  }
  
  void update() {
    velocity = direction.copy().setMag(speed);
    position.add(velocity);  // position is absolute, client trumps server here
    ellipse(position.x, position.y, 20, 20);  // on abs pos while other players on pred pos
  }
}
