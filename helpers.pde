ArrayList<Part> mergeSort(ArrayList<Part> org, int b, int e) {
  if ( b == e ) {  
    ArrayList<Part> one = new ArrayList<Part>(1);
    one.add(org.get(b));
    return one;
  } 
  
  else {
    int m = (e + b) / 2;  //finds the middle index between start and end

    ArrayList<Part> sortedLeftHalf  = mergeSort(org, b, m);     // recursive function-call
    ArrayList<Part> sortedRightHalf = mergeSort(org, m + 1, e );   // recursive function-call

    return merge( sortedLeftHalf, sortedRightHalf );  // merges the two sorted halves
  }
}

ArrayList<Part> merge( ArrayList<Part> a, ArrayList<Part> b ) {
  ArrayList<Part> c = new ArrayList<Part>(); 
  
  int i = 0;   //i is the current index for a
  int j = 0;   //j is the current index for b 

  while (i < a.size() && j < b.size() ) {
    if (a.get(i).x < b.get(j).x || a.get(i).x == b.get(j).x && a.get(i).y == b.get(j).y) {
      c.add(a.get(i));
      i++;
    } else {
      c.add(b.get(j));
      j++;
    }
  }

  for (int v = i; v < a.size(); v++) {
    c.add(a.get(v));  
  }

  for (int v = j; v < b.size(); v++) {
    c.add(b.get(v));
  }

  return c;
}

float distance(float x1, float y1, float x2, float y2) {
  return pow(x2-x1, 2) + pow(y2-y1, 2);
}

float angle(float x, float y) { //optimize
  if (x < 0) return PI+ atan(y/x);
  if (x == 0) {
    if (y == 0) return 0;
    if (y > 0) return PI/2;
    else return 3*PI/2;
  } else {
    if (y >= 0) return atan(y/x);
    else return 2*PI+atan(y/x);
  }
}

boolean intersect(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {
  int o1 = turn(x1, y1, x2, y2, x3, y3); 
  int o2 = turn(x1, y1, x2, y2, x4, y4); 
  int o3 = turn(x3, y3, x4, y4, x1, y1); 
  int o4 = turn(x3, y3, x4, y4, x2, y2);

  if (o1 != o2 && o3 != o4) {
    return true;
  }
  return false;
}

int turn(float x1, float y1, float x2, float y2, float x3, float y3) {
  float val = (y2 - y1) * (x3 - x2) - (x2 - x1) * (y3 - y2); 
  if (val == 0) return 0;
  else if (val < 0) return -1;
  else return 1;
}
