class Jet {
  float amplitude, wavelength, k;
  float angle;
  float x, y;
  float xs, ys;
  int frame;

  Jet(float a, float w, float xc, float yc, float ang, float xspeed, float yspeed) {
    this.amplitude = a;
    this.wavelength = w;
    this.x = xc;
    this.y = yc;
    this.angle = radians(ang);
    this.xs = xspeed;
    this.ys = yspeed;
    this.frame = 0;
    this.k = TWO_PI*avgS/w;
  }
  
  void setk(){ //resets K when wavelength/average speed changes
    this.k = TWO_PI*avgS/wavelength; 
  }

  void display() {
    beginShape();
    vertex(this.x+10*cos(angle)-50*sin(angle), this.y+10*sin(angle)+50*cos(angle)); //Processing's rotate function sucks so I coded my own
    vertex(this.x+10*cos(angle)+50*sin(angle), this.y+10*sin(angle)-50*cos(angle));
    vertex(this.x-10*cos(angle)+50*sin(angle), this.y-10*sin(angle)-50*cos(angle));
    vertex(this.x-10*cos(angle)-50*sin(angle), this.y-10*sin(angle)+50*cos(angle));
    endShape();
    strokeWeight(3); //drawing that black line
    line(this.x+5*cos(angle)-50*sin(angle), this.y+5*sin(angle)+50*cos(angle),this.x+5*cos(angle)+50*sin(angle), this.y+5*sin(angle)-50*cos(angle)); 
    strokeWeight(1);
  }

  void move() {
    x += xs;
    y += ys;
  }

  void generate() {
    if (int(this.frame*avgS) % int(wavelength/50) == 0) { 
      int num;
      if (this.wavelength > 0) {
        num = round(this.amplitude*sin(k*this.frame)+this.amplitude);
      } else num = round(amplitude);
      float gap = 100/(num+1);

      if (cycleselectB.getSelectedText().equals("None")) { //various cycle modes
        for (int i = 0; i < num; i++) {
          Part a = new Part(this.x+gap*(i-(num-1)/2.0)*sin(-angle), this.y+gap*(i-(num-1)/2.0)*cos(angle), 
            cos(angle)*avgS, sin(angle)*avgS);
          particles.add(a);
        }
      } else if (cycleselectB.getSelectedText().equals("Multi")) {
        if (random(1) < 0.5) {
          for (int i = 0; i < num; i++) {
            particles.get(i).resetValues(this.x+gap*(i-(num-1)/2.0)*sin(-angle), this.y+gap*(i-(num-1)/2.0)*cos(angle), 
              cos(angle)*avgS, sin(angle)*avgS);
          }
        } else {
          for (int i = 0; i < num; i++) {
            particles.get(particles.size()-i-1).resetValues(this.x+gap*(i-(num-1)/2.0)*sin(-angle), this.y+gap*(i-(num-1)/2.0)*cos(angle), 
              cos(angle)*avgS, sin(angle)*avgS);
          }
        }
      } else if (cycleselectB.getSelectedText().equals("Right")) {
        for (int i = 0; i < num; i++) {
          particles.get(particles.size()-i-1).resetValues(this.x+gap*(i-(num-1)/2.0)*sin(-angle), this.y+gap*(i-(num-1)/2.0)*cos(angle), 
            cos(angle)*avgS, sin(angle)*avgS);
        }
      } else {
        for (int i = 0; i < num; i++) {
          particles.get(i).resetValues(this.x+gap*(i-(num-1)/2.0)*sin(-angle), this.y+gap*(i-(num-1)/2.0)*cos(angle), 
            cos(angle)*avgS, sin(angle)*avgS);
        }
      }
    }
   this.frame++;
  }
}
