void setParticle() {
  setFalse();
  xText.setVisible(true);
  xField.setVisible(true);
  yText.setVisible(true);
  yField.setVisible(true);
  xsText.setVisible(true);
  xsSlider.setVisible(true);
  ysText.setVisible(true);
  ysSlider.setVisible(true);
  deleteB.setVisible(true);

  xField.setText("400");
  yField.setText("350");
  xsSlider.setValue(0.0);
  ysSlider.setValue(0.0);
}

void setJet(Jet a) {
  setParticle();
  psText.setVisible(true);
  ampText.setVisible(true);
  ampSlider.setVisible(true);
  wavText.setVisible(true);
  wavSlider.setVisible(true);
  paText.setVisible(true);
  paSlider.setVisible(true);

  xField.setText(str(a.x));
  yField.setText(str(a.y));
  xsSlider.setValue(a.xs);
  ysSlider.setValue(a.ys);
  ampSlider.setValue(a.amplitude);
  wavSlider.setValue(a.wavelength);
  paSlider.setValue(degrees(a.angle));
  paText.setText("jet angle");
}

void setBarrier(Barrier b) {
  setParticle();
  lenText.setVisible(true);
  lenField.setVisible(true);
  paSlider.setVisible(true);
  paText.setVisible(true);
  
  xField.setText(str(b.x));
  yField.setText(str(b.y));
  xsSlider.setValue(b.xs);
  ysSlider.setValue(b.ys);
  lenField.setText(str(b.len));
  paSlider.setValue(degrees(b.angle));
  paText.setText("barrier angle");
}

void setNone() {
  oldselectB.setSelected(0);
  newselectB.setSelected(0);
  setFalse();
}

void setFalse() {
  xText.setVisible(false);
  yText.setVisible(false);
  ysText.setVisible(false);
  xsText.setVisible(false);
  lenText.setVisible(false);
  paText.setVisible(false);
  ampText.setVisible(false);
  wavText.setVisible(false);
  xField.setVisible(false);
  yField.setVisible(false);
  ysSlider.setVisible(false);
  xsSlider.setVisible(false);
  paSlider.setVisible(false);
  lenField.setVisible(false);
  ampSlider.setVisible(false);
  wavSlider.setVisible(false);
  deleteB.setVisible(false);
}
