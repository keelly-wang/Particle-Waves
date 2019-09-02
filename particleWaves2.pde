import g4p_controls.*;
import java.util.ArrayList.*;

//PARAMETERS
int pSize = 5;
int num = 500;

//INITIAL VALUES
boolean play = false;
boolean rright = true;
boolean rleft = true;
boolean rtop = true;
boolean rbottom = true;
float avgS = 2;
float pSizeS = pow(pSize, 2);
float sdiff = 0;

//DATA STORAGE
ArrayList<Part> particles;
ArrayList<Jet> jets;
ArrayList<Barrier> barriers;
ArrayList<String> archive; //for GUI purposes
String[] current, dummy; //for GUI purposes


void setup() {
  size(800, 700);
  createGUI();
  background(0);
  fill(255);
  rectMode(CORNERS);
  

  //INITIALIZING DATA STORAGE
  particles = new ArrayList<Part>();
  jets = new ArrayList<Jet>();
  barriers = new ArrayList<Barrier>();
  archive = new ArrayList<String>(); //more GUI stuff
  archive.add("None");
  current = new String[2];
  dummy = new String[0];

}

void draw() {
  background(0);
  
  if (play) { //if the simulation is running
  
    //AUTOMATIC PARTICLE CYCLING SETTINGS
    if (particles.size() < 300) { //if there's no particles to cycle, don't cycle
      cycleselectB.setSelected(0);
    } else if (particles.size() > 1600 && cycleselectB.getSelectedText().equals("None")) { //if there's too many particles and we're not cycling
      cycleselectB.setSelected(1); //set to Multi (see generate() in Jet class)
    }

    for (Jet j : jets) { //generate particles from jets
      j.generate();
    }

    if (particles.size() > 0) { //mergeSort all particles (see helpers tab)
      particles = mergeSort(particles, 0, particles.size()-1);
    }
    
    //COLLISIONS
    for (int i = 0; i < particles.size(); i++) { 
      Part a = particles.get(i);
      int j = i+1;
      while (j < particles.size() && particles.get(j).x - a.x < pSize) { //while the x-values are in range of each other (if their x-values are more than pSize apart, they can't be colliding, end loop)
        Part b = particles.get(j); 
        if (distance(a.x, a.y, b.x, b.y) <= pSizeS) particles.get(i).elasticCollide(particles.get(j)); //check for collision, call elasticCollide to calculate new velocities
        j++;
      } //the mergeSort above allows me to not have to check between every pair of points!

      for (Barrier b : barriers) { //check if the point collides with any barriers
        b.barrierCollide(a);
      }
    }
    
    //MOVING EVERYTHING
    for (Part p : particles) { 
      p.move();
    }  

    for (Jet j : jets) {
      j.move();
    }
    for (Barrier b : barriers) {
      b.move();
    }
  }

  //DISPLAYING EVERYTHING
  fill(255);
  for (int i = 0; i < particles.size(); i++) {
    try { 
      particles.get(i).display();
    } 
    catch (Exception e) { //sometimes I got an invalid modification error? I think I cleared the array during one of these (incredibly runtime-consuming) loops
    } //so I added a try/catch to all my display statements
  }

  stroke(0, 255, 0);
  strokeWeight(3);
  for (int i = 0; i < barriers.size(); i++) {
    try { 
      barriers.get(i).display();
    } 
    catch (Exception e) {
    }
  }
  strokeWeight(1);
  stroke(0);

  fill(255, 0, 0);
  for (int i = 0; i < jets.size(); i++) {
    try { 
      jets.get(i).display();
    } 
    catch (Exception e) {
    }
  } //and that's it!
}
