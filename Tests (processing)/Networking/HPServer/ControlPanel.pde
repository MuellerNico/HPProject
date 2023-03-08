
public void cpDraw(PApplet app, GWinData data) {
  app.background(255);

  // titles
  app.textSize(20);
  app.fill(0);
  app.text("Server Info", 10, 30);
  app.text("Clients", 10, 160);

  //info
  app.fill(40);
  app.textSize(16); 
  app.text("Server IP: " + IP, 10, 60);
  app.text("Server Port: " + PORT, 10, 80);
  app.text("Clients connected: " + clients.size(), 10, 100);
  app.text("Players in game: " + game.players.size(), 10, 120);

  if (clients.size()==0) {
    app.text("-", 10, 190);
  } else {
    for (int i=0; i<clients.size(); i++) {
      app.text(clients.get(i).ip(), 10, 190 + 20*i);
    }
  }
}
