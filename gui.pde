GWindow ctrl;
GButton randgenB, clearallB, clearpartsB, startstopB, deleteB;
GDropList newselectB, oldselectB, cycleselectB;
GLabel newText, selectText;
GLabel xText, yText, ysText, xsText, psText, lenText, paText, ampText, wavText, cycleText, reflectText;
GTextField xField, yField, lenField;
GSlider ysSlider, xsSlider, psSlider, paSlider, ampSlider, wavSlider;
GCheckbox reflectleft, reflectright, reflecttop, reflectbottom;

synchronized public void win_draw1(PApplet appc, GWinData data) { 
  appc.background(230);
}

public void startStop(GButton source, GEvent event) { //start-stop button
  if (play == false) {
    startstopB.setText("Pause");
    play = true;
    setNone();
    randgenB.setVisible(false);
    clearallB.setVisible(false);
    clearpartsB.setVisible(false);
    newselectB.setVisible(false);
    oldselectB.setVisible(false);
    newText.setVisible(false);
    selectText.setVisible(false);
    psText.setVisible(false);
    psSlider.setVisible(false);
    
  } else {
    startstopB.setText("Play");
    play = false;
    if (particles.size() == 0) {
      randgenB.setVisible(true);
    }
    clearallB.setVisible(true);
    clearpartsB.setVisible(true);
    newselectB.setVisible(true);
    oldselectB.setVisible(true);
    newText.setVisible(true);
    selectText.setVisible(true);
    psText.setVisible(true);
    psSlider.setVisible(true);
  }
} 

public void clearAll(GButton source, GEvent event) { //clear everything
  particles.clear();
  jets.clear();
  barriers.clear();

  //clearing the Select... dropList
  setNone(); 
  archive.clear();
  archive.add("None");
  oldselectB.setItems(archive.toArray(dummy), 0);
  randgenB.setVisible(true);
} 

public void clearParts(GButton source, GEvent event) { //clear particles only
  particles.clear(); 
  setNone();
  randgenB.setVisible(true);
}

public void randGen(GButton source, GEvent event) { //_CODE_:randgenB:792257:
  for (int i = 0; i < num; i++) {
    float rAngle = random(-PI, PI);
    float speed = avgS + random(-0.3, 0.3);
    Part a = new Part(random(width), random(height), cos(rAngle)*speed, sin(rAngle)*speed);
    particles.add(a);
  }
  randgenB.setVisible(false);
} 

public void newSelect(GDropList source, GEvent event) { //_CODE_:newselectB:629155:
  oldselectB.setSelected(0);
  if (newselectB.getSelectedText().equals("Particle")) {
    Part a = new Part(400, 350, 0, 0);
    particles.add(a);
    setParticle();
    current[0] = "Particle";
    current[1] = str(particles.size()-1);
    newselectB.setSelected(0);
  } else if (newselectB.getSelectedText().equals("Jet")) {
    Jet a = new Jet(3, 300, 100, 350, 0, 0, 0);
    jets.add(a);
    setJet(a);
    archive.add("Jet " + str(jets.size()));
    oldselectB.setItems(archive.toArray(dummy), 0);
    current[0] = "Jet";
    current[1] = str(jets.size()-1);
    newselectB.setSelected(0);
    oldselectB.setSelected(archive.size()-1);
  } else if (newselectB.getSelectedText().equals("Barrier")) {
    Barrier b = new Barrier(400, 300, 0, 0, 0, 100);
    barriers.add(b);
    setBarrier(b);
    archive.add("Barrier " + str(barriers.size()));
    oldselectB.setItems(archive.toArray(dummy), 0);
    current[0] = "Barrier";
    current[1] = str(barriers.size()-1);
    newselectB.setSelected(0);
    oldselectB.setSelected(archive.size()-1);
  }
} 

public void oldSelect(GDropList source, GEvent event) { //_CODE_:oldselectB:335266:
  newselectB.setSelected(0);
  String[] selected = oldselectB.getSelectedText().split(" ");
  if (selected[0].equals("Jet")) {
    current[0] = "Jet";
    current[1] = str(int(selected[1])-1);
    setJet(jets.get(int(selected[1])-1));
  } else if (selected[0].equals("Barrier")) {
    current[0] = "Barrier";
    current[1] = str(int(selected[1])-1);
    setBarrier(barriers.get(int(selected[1])-1));
  } else {
    setNone();
  }
}

public void xChange(GTextField source, GEvent event) { //_CODE_:oldselectB:335266:
  if (current[0].equals("Particle")) {
    particles.get(int(current[1])).x = float(xField.getText());
  } else if (current[0].equals("Jet")) {
    jets.get(int(current[1])).x = float(xField.getText());
  } else {
    barriers.get(int(current[1])).x = float(xField.getText());
    barriers.get(int(current[1])).change();
  }
}

public void yChange(GTextField source, GEvent event) { //_CODE_:oldselectB:335266:
  if (current[0].equals("Particle")) {
    particles.get(int(current[1])).y = float(yField.getText());
  } else if (current[0].equals("Jet")) {
    jets.get(int(current[1])).y = float(yField.getText());
  } else {
    barriers.get(int(current[1])).y = float(yField.getText());
    barriers.get(int(current[1])).change();
  }
}

public void xsChange(GSlider source, GEvent event) { //_CODE_:oldselectB:335266:
  if (current[0].equals("Particle")) {
    particles.get(int(current[1])).xs = xsSlider.getValueF();
  } else if (current[0].equals("Jet")) {
    jets.get(int(current[1])).xs = xsSlider.getValueF();
  } else {
    barriers.get(int(current[1])).xs = xsSlider.getValueF();
  }
}

public void ysChange(GSlider source, GEvent event) { //_CODE_:oldselectB:335266:
  if (current[0].equals("Particle")) {
    particles.get(int(current[1])).ys = ysSlider.getValueF();
  } else if (current[0].equals("Jet")) {
    jets.get(int(current[1])).ys = ysSlider.getValueF();
  } else {
    barriers.get(int(current[1])).ys = ysSlider.getValueF();
  }
}

public void psChange(GSlider source, GEvent event) { //_CODE_:oldselectB:335266:
  sdiff = psSlider.getValueF()-avgS;
  avgS = psSlider.getValueF();
  for (Jet j : jets) {
    j.setk();
  }
  for (Part p : particles) {
    p.shiftV();
  }
}

public void lenChange(GTextField source, GEvent event) { //_CODE_:oldselectB:335266:
  barriers.get(int(current[1])).len = float(lenField.getText());
  barriers.get(int(current[1])).change();
}

public void paChange(GSlider source, GEvent event) { //_CODE_:oldselectB:335266:
  if (current[0].equals("Jet")) {
    jets.get(int(current[1])).angle = radians(paSlider.getValueF());
  } else {
    barriers.get(int(current[1])).angle = radians(paSlider.getValueF());
    barriers.get(int(current[1])).change();
  }
}

public void ampChange(GSlider source, GEvent event) { //_CODE_:oldselectB:335266:
  jets.get(int(current[1])).amplitude = ampSlider.getValueF();
}

public void wavChange(GSlider source, GEvent event) { //_CODE_:oldselectB:335266:
  jets.get(int(current[1])).wavelength = wavSlider.getValueF();
  jets.get(int(current[1])).setk();
}

public void delete(GButton source, GEvent event) { //_CODE_:oldselectB:335266:
  if (current[0].equals("Particle")) {
    particles.remove(int(current[1]));
  } else if (current[0].equals("Jet")) {
    jets.remove(int(current[1]));
    archive.remove("Jet "+ str(int(current[1])+1));
    oldselectB.setItems(archive.toArray(dummy), 0);
  } else {
    barriers.remove(int(current[1]));
    archive.remove("Barrier "+ str(int(current[1])+1));
    oldselectB.setItems(archive.toArray(dummy), 0);
  }
  setNone();
}

public void refLeft(GCheckbox source, GEvent event) { //_CODE_:oldselectB:335266:
  rleft = reflectleft.isSelected();
}

public void refRight(GCheckbox source, GEvent event) { //_CODE_:oldselectB:335266:
  rright = reflectright.isSelected();
}

public void refTop(GCheckbox source, GEvent event) { //_CODE_:oldselectB:335266:
  rtop = reflecttop.isSelected();
}

public void refBottom(GCheckbox source, GEvent event) { //_CODE_:oldselectB:335266:
  rbottom = reflectbottom.isSelected();
}

// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI() {
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setCursor(ARROW);
  surface.setTitle("Animation");

  ctrl = GWindow.getWindow(this, "Controls", 0, 0, 240, 700, JAVA2D);
  ctrl.noLoop();
  ctrl.addDrawHandler(this, "win_draw1");

  startstopB = new GButton(ctrl, 30, 30, 80, 30);
  startstopB.setText("Play");
  startstopB.addEventHandler(this, "startStop");

  clearallB = new GButton(ctrl, 130, 30, 80, 30);
  clearallB.setText("Clear all");
  clearallB.addEventHandler(this, "clearAll");

  clearpartsB = new GButton(ctrl, 30, 70, 80, 30);
  clearpartsB.setText("Clear particles");
  clearpartsB.addEventHandler(this, "clearParts");

  randgenB = new GButton(ctrl, 130, 70, 80, 30);
  randgenB.setText("Random");
  randgenB.addEventHandler(this, "randGen");

  newText = new GLabel(ctrl, 30, 120, 80, 20);
  newText.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  newText.setText("New...");
  newText.setOpaque(false);

  newselectB = new GDropList(ctrl, 130, 120, 90, 92, 3);
  newselectB.setItems(loadStrings("list_629155"), 0);
  newselectB.addEventHandler(this, "newSelect");

  selectText = new GLabel(ctrl, 30, 160, 80, 20);
  selectText.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  selectText.setText("Select...");
  selectText.setOpaque(false);

  oldselectB = new GDropList(ctrl, 130, 160, 90, 80, 3);
  oldselectB.setItems(loadStrings("list_335266"), 0);
  oldselectB.addEventHandler(this, "oldSelect");

  xText = new GLabel(ctrl, 20, 200, 40, 20);
  xText.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  xText.setText("xPos");
  xText.setOpaque(false);
  xText.setVisible(false);

  xField = new GTextField(ctrl, 70, 200, 40, 20, G4P.SCROLLBARS_NONE);
  xField.setOpaque(true);
  xField.addEventHandler(this, "xChange");
  xField.setVisible(false);

  yText = new GLabel(ctrl, 130, 200, 40, 20);
  yText.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  yText.setText("yPos");
  yText.setOpaque(false);
  yText.setVisible(false);

  yField = new GTextField(ctrl, 180, 200, 40, 20, G4P.SCROLLBARS_NONE);
  yField.setOpaque(true);
  yField.addEventHandler(this, "yChange");
  yField.setVisible(false);

  xsText = new GLabel(ctrl, 20, 240, 60, 20);
  xsText.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  xsText.setText("xSpeed");
  xsText.setOpaque(false);
  xsText.setVisible(false);

  xsSlider = new GSlider(ctrl, 80, 220, 140, 60, 10.0);
  xsSlider.setShowValue(true);
  xsSlider.setLimits(0.0, -5.0, 5.0);
  xsSlider.setNbrTicks(11);
  xsSlider.setShowTicks(true);
  xsSlider.setNumberFormat(G4P.DECIMAL, 3);
  xsSlider.setOpaque(false);
  xsSlider.addEventHandler(this, "xsChange");
  xsSlider.setVisible(false);

  ysText = new GLabel(ctrl, 20, 280, 60, 20);
  ysText.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  ysText.setText("ySpeed");
  ysText.setOpaque(false);
  ysText.setVisible(false);

  ysSlider = new GSlider(ctrl, 80, 260, 140, 60, 10.0);
  ysSlider.setShowValue(true);
  ysSlider.setLimits(0.0, -5.0, 5.0);
  ysSlider.setNbrTicks(11);
  ysSlider.setShowTicks(true);
  ysSlider.setNumberFormat(G4P.DECIMAL, 3);
  ysSlider.setOpaque(false);
  ysSlider.addEventHandler(this, "ysChange");
  ysSlider.setVisible(false);

  lenText = new GLabel(ctrl, 20, 360, 60, 30);
  lenText.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  lenText.setText("Barrier length");
  lenText.setOpaque(false);
  lenText.setVisible(false);

  lenField = new GTextField(ctrl, 80, 360, 40, 20, G4P.SCROLLBARS_NONE);
  lenField.setOpaque(true);
  lenField.addEventHandler(this, "lenChange");
  lenField.setVisible(false);

  paText = new GLabel(ctrl, 20, 320, 60, 30);
  paText.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  paText.setText("jet angle");
  paText.setOpaque(false);
  paText.setVisible(false);

  paSlider = new GSlider(ctrl, 80, 300, 140, 60, 10.0);
  paSlider.setShowValue(true);
  paSlider.setLimits(0, 0, 360);
  paSlider.setNbrTicks(73);
  paSlider.setStickToTicks(true);
  paSlider.setShowTicks(false);
  paSlider.setNumberFormat(G4P.INTEGER, 0);
  paSlider.setOpaque(false);
  paSlider.addEventHandler(this, "paChange");
  paSlider.setVisible(false);

  ampText = new GLabel(ctrl, 20, 360, 60, 20);
  ampText.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  ampText.setText("amplitude");
  ampText.setOpaque(false);
  ampText.setVisible(false);

  ampSlider = new GSlider(ctrl, 80, 340, 140, 60, 10.0);
  ampSlider.setShowValue(true);
  ampSlider.setLimits(3.0, 0.0, 5.0);
  ampSlider.setNbrTicks(6);
  ampSlider.setShowTicks(true);
  ampSlider.setNumberFormat(G4P.DECIMAL, 3);
  ampSlider.setOpaque(false);
  ampSlider.addEventHandler(this, "ampChange");
  ampSlider.setVisible(false);

  wavText = new GLabel(ctrl, 16, 400, 65, 20);
  wavText.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  wavText.setText("wavelength");
  wavText.setOpaque(false);
  wavText.setVisible(false);

  wavSlider = new GSlider(ctrl, 80, 380, 140, 60, 10.0);
  wavSlider.setShowValue(true);
  wavSlider.setLimits(500, 300, 1000);
  wavSlider.setNumberFormat(G4P.INTEGER, 0);
  wavSlider.setOpaque(false);
  wavSlider.addEventHandler(this, "wavChange");
  wavSlider.setVisible(false);

  deleteB = new GButton(ctrl, 30, 440, 80, 30);
  deleteB.setText("Delete");
  deleteB.addEventHandler(this, "delete");
  deleteB.setVisible(false);

  psText = new GLabel(ctrl, 20, 490, 60, 30);
  psText.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  psText.setText("average speed");
  psText.setOpaque(false);

  psSlider = new GSlider(ctrl, 80, 470, 140, 60, 10.0);
  psSlider.setShowValue(true);
  psSlider.setLimits(2.0, 1.5, 5.0);
  psSlider.setNumberFormat(G4P.DECIMAL, 1);
  psSlider.setOpaque(false);
  psSlider.addEventHandler(this, "psChange");

  cycleText = new GLabel(ctrl, 30, 540, 60, 20);
  cycleText.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  cycleText.setText("Cycle");
  cycleText.setOpaque(false);

  cycleselectB = new GDropList(ctrl, 130, 540, 90, 80, 3);
  cycleselectB.setItems(loadStrings("list_000001"), 0);

  reflectText = new GLabel(ctrl, 30, 570, 60, 20);
  reflectText.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  reflectText.setText("Reflect");
  reflectText.setOpaque(false);

  reflectleft = new GCheckbox(ctrl, 130, 570, 60, 20);
  reflectleft.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  reflectleft.setText("Left");
  reflectleft.setOpaque(false);
  reflectleft.setSelected(true);
  reflectleft.addEventHandler(this, "refLeft");


  reflectright = new GCheckbox(ctrl, 130, 590, 60, 20);
  reflectright.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  reflectright.setText("Right");
  reflectright.setOpaque(false);
  reflectright.setSelected(true);
  reflectright.addEventHandler(this, "refRight");


  reflecttop = new GCheckbox(ctrl, 130, 610, 60, 20);
  reflecttop.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  reflecttop.setText("Top");
  reflecttop.setOpaque(false);
  reflecttop.setSelected(true);
  reflecttop.addEventHandler(this, "refTop");


  reflectbottom = new GCheckbox(ctrl, 130, 630, 60, 20);
  reflectbottom.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  reflectbottom.setText("Bottom");
  reflectbottom.setOpaque(false);
  reflectbottom.setSelected(true);
  reflectbottom.addEventHandler(this, "refBottom");

  ctrl.loop();
}

// Variable declarations 
// autogenerated do not edit
