float[] stringToFloat(String[] s) {
  float[] v = new float[s.length]; //spare room
  for (int i=1; i<s.length-1; i++) {
    v[i] = Float.parseFloat(s[i]);
  }
  return v;
}
