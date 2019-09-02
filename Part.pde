class Part {
  float x, y, xs, ys;

  Part(float newx, float newy, float newxs, float newys) {
    this.x = newx;
    this.y = newy;
    this.xs = newxs;
    this.ys = newys;
  }

  void resetValues(float newx, float newy, float newxs, float newys) {
    this.x = newx;
    this.y = newy;
    this.xs = newxs;
    this.ys = newys;
  }

  void display() {
    ellipse(this.x, this.y, pSize, pSize);
  }
  
  void shiftV(){ //recalculates xs/ys when the average speed changes
    float newV = sqrt(pow(this.xs, 2)+pow(this.ys, 2))+sdiff;
    float anglethis = angle(this.xs, this.ys);
    this.xs = cos(anglethis)*newV;
    this.ys = sin(anglethis)*newV;
  }

  void move() {
    if (this.x < 0 && rleft) this.xs *= -1;
    else if (this.x > width && rright) this.xs *= -1;
    if (this.y < 0 && rtop) this.ys *= -1;
    else if (this.y > height && rbottom) this.ys *= -1;
    this.x += this.xs;
    this.y += this.ys;
  }

  void elasticCollide(Part other) { //based on the links I sent you!
    float phi;
    if (other.x-this.x == 0) phi = PI/2;
    else phi = atan((other.y-this.y)/(other.x-this.x));

    float vother = sqrt(pow(other.xs, 2)+pow(other.ys, 2));
    float vthis = sqrt(pow(this.xs, 2)+pow(this.ys, 2));
    float angleother = angle(other.xs, other.ys);
    float anglethis = angle(this.xs, this.ys);

    this.xs = vother*cos(angleother-phi)*cos(phi) + vthis*sin(anglethis-phi)*cos(phi+PI/2);
    this.ys = vother*cos(angleother-phi)*sin(phi) + vthis*sin(anglethis-phi)*sin(phi+PI/2);
    other.xs = vthis*cos(anglethis-phi)*cos(phi) + vother*sin(angleother-phi)*cos(phi+PI/2);
    other.ys = vthis*cos(anglethis-phi)*sin(phi) + vother*sin(angleother-phi)*sin(phi+PI/2);

    float dis = pSizeS - distance(this.x+this.xs, this.y+this.ys, other.x+other.xs, other.y+other.ys);

    if (dis >= 0) {
      dis /= 2;
      int crash = 0;

      if (this.xs <= 0) {
        if (this.ys <= 0) {
          for (Barrier b : barriers) { //to avoid my internal collision algorithm from pushing a particle over the barrier
            if (intersect(this.x, this.y, this.x-dis*cos(phi), this.y-dis*sin(phi), b.x1, b.y1, b.x2, b.y2)) crash = 1;
            else if (intersect(other.x, other.y, other.x+dis*cos(phi), other.y+dis*sin(phi), b.x1, b.y1, b.x2, b.y2)) crash = 2;
          }

          if (crash == 1) {
            other.x += 2*dis*cos(phi);
            other.y += 2*dis*sin(phi);
          } else if (crash == 2) {
            this.x -= 2*dis*cos(phi);
            this.y -= 2*dis*sin(phi);
          } else {
            this.x -= dis*cos(phi);
            this.y -= dis*sin(phi);
            other.x += dis*cos(phi);
            other.y += dis*sin(phi);
          }
        } else {
          for (Barrier b : barriers) {
            if (intersect(this.x, this.y, this.x-dis*cos(phi), this.y+dis*sin(phi), b.x1, b.y1, b.x2, b.y2)) crash = 1;
            else if (intersect(other.x, other.y, other.x+dis*cos(phi), other.y-dis*sin(phi), b.x1, b.y1, b.x2, b.y2)) crash = 2;
          }

          if (crash == 1) {
            other.x += 2*dis*cos(phi);
            other.y -= 2*dis*sin(phi);
          } else if (crash == 2) {
            this.x -= 2*dis*cos(phi);
            this.y += 2*dis*sin(phi);
          } else {
            this.x -= dis*cos(phi);
            this.y += dis*sin(phi);
            other.x += dis*cos(phi);
            other.y -= dis*sin(phi);
          }
        }
      } else {        
        if (this.ys <= 0) {
          for (Barrier b : barriers) {
            if (intersect(this.x, this.y, this.x+dis*cos(phi), this.y-dis*sin(phi), b.x1, b.y1, b.x2, b.y2)) crash = 1;
            else if (intersect(other.x, other.y, other.x-dis*cos(phi), other.y+dis*sin(phi), b.x1, b.y1, b.x2, b.y2)) crash = 2;
          }  

          if (crash == 1) {
            other.x -= 2*dis*cos(phi);
            other.y += 2*dis*sin(phi);
          } else if (crash == 2) {
            this.x += 2*dis*cos(phi);
            this.y -= 2*dis*sin(phi);
          } else {
            this.x += dis*cos(phi);
            this.y -= dis*sin(phi);
            other.x -= dis*cos(phi);
            other.y += dis*sin(phi);
          }
        } else {
          for (Barrier b : barriers) {
            if (intersect(this.x, this.y, this.x+dis*cos(phi), this.y+dis*sin(phi), b.x1, b.y1, b.x2, b.y2)) crash = 1;
            else if (intersect(other.x, other.y, other.x-dis*cos(phi), other.y-dis*sin(phi), b.x1, b.y1, b.x2, b.y2)) crash = 2;
          }  
          if (crash == 1) {
            other.x -= 2*dis*cos(phi);
            other.y -= 2*dis*sin(phi);
          } else if (crash == 2) {
            this.x += 2*dis*cos(phi);
            this.y += 2*dis*sin(phi);
          } else {
            this.x += dis*cos(phi);
            this.y += dis*sin(phi);
            other.x -= dis*cos(phi);
            other.y -= dis*sin(phi);
          }
        }
      }
    }
  }
}
