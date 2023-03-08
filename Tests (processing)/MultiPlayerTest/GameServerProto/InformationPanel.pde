
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
  app.text("Server IP: " + server.IP, 10, 60);
  app.text("Server Port: " + server.JSON_PORT, 10, 80);
  app.text("Clients connected: " + server.clients.size(), 10, 100);  // TODO: serparate players and clients
  app.text("Players in game: " + game.players.size(), 10, 120);

  if (server.clients.size()==0) {
    app.text("-", 10, 190);
  } else {
    for (int i=0; i<server.clients.size(); i++) {
      app.text(server.clients.get(i).ip(), 10, 190 + 20*i);
    }
  }
}
