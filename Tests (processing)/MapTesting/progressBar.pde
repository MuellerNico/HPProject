class ProgressBar {

  color c;
  int x, y;
  int w, h;
  float max;
  float current = 0;
  float progress = 0;

  ProgressBar(int x, int y, int w, int h, float max) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.max = max;
  }

  void setCurrent(float curr) {
    this.current = curr;
  }

  void setColor(color c) {
    this.c = c;
  }

  void display() {
    
    if (current >= max) {
      progress = 1;
    } else if (current < 0) {
      progress = 0;
    } else {
      progress = current/max;
    }
    
    stroke(0);
    noFill();
    rect(x, y, w, h);
    noStroke();
    fill(c);
    rect(x, y, progress*w, h);
    fill(0);
    textSize(UNIT);
    text((int) current + "/" + (int) max, x + 5, y + h/2 + UNIT/2); //  TODO: no digits after comma
  }
}
