import processing.net.*;

Server s;
Client c;
String in;
int t;

void setup() {
  frameRate(30);
  frameRate(10);
  s = new Server(this, 5005);
  c = new Client(this, s.ip(), 5005);   // same ip
  t = millis();
}
void draw() {
  c.write("important\r");
  c.write("crap\r");

  if (millis() - t > 1000) {
    t = millis();
    Client cc = s.available();
    if (cc !=null) {
      in = cc.readString();
      if (in != null) {
        println(in.substring(0,in.indexOf("\r")));
      }
    }
  }
}
void mousePressed() {
  c.write("test");
}
