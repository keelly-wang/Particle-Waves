class Barrier {
  float angle;
  float x, y, x1, y1, x2, y2;
  float xs, ys;
  float len;

  Barrier(float xc, float yc, float ang, float xspeed, float yspeed, float leng) {
    this.x = xc;
    this.y = yc;
    this.angle = radians(ang);
    this.xs = xspeed;
    this.ys = yspeed;
    this.len = leng;

    change();
  }

  void change() { //I could calculate x1,y1,x2,y2 every time I need them, but because collision checking is already so complex I decided to set variables
    this.x1 = this.x-len/2.0*cos(this.angle); 
    this.y1 = this.y-len/2.0*sin(this.angle);
    this.x2 = this.x+len/2.0*cos(angle);
    this.y2 = this.y+len/2.0*sin(angle);
  }

  void display() {
    line(x1, y1, x2, y2);
  }

  void move() {
    if (this.xs != 0 || this.ys != 0) {
      this.x += this.xs;
      this.x1 += this.xs;
      this.x2 += this.xs;
      this.y += this.ys;
      this.y1 += this.ys;
      this.y2 += this.ys;
    }
  }

  void barrierCollide(Part a) {    
    if (intersect(this.x1, this.y1, this.x2, this.y2, a.x, a.y, a.x + a.xs, a.y+a.ys)) { //if the particle's path intersects with the barrier- see helpers tab, intersect()
      float vthis = sqrt(pow(a.xs, 2)+pow(a.ys, 2));  //reflect the particle off the barrier
      float angleP = angle(a.xs, a.ys);
      a.xs = vthis*cos(2*this.angle-angleP); //I don't know how to explain this formula without a diagram, but I could come in and talk about it after the exam if you want!
      a.ys = vthis*sin(2*this.angle-angleP);
    }
  }
}
