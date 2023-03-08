class LocalPlayer extends Player {

  PVector direction;

  LocalPlayer(int ip) {
    super(ip);
    this.direction   = new PVector();
    game.players.add(this);
  }
  
  void update() {
    velocity = direction.copy().setMag(speed);
    position.add(velocity);  // position is absolute, client trumps server here
    ellipse(position.x, position.y, 20, 20);  // on abs pos while other players on pred pos
  }
}
