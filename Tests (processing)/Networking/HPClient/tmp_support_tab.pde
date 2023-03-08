float[] stringToFloat(String[] s, int startPoint) {
  float[] v = new float[s.length]; 
  for (int i=startPoint; i<s.length-startPoint; i++) {
    v[i] = Float.parseFloat(s[i]);
  }
  return v;
}
