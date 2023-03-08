/* 
normaly up to 200 json read and writes per second to file. 
Game should work with 16 tick
*/


import java.io.*;

JSONObject json;
String jsonString = "";
int COUNTER;
FileWriter file;

void setup() {
  frameRate(200);
  size(600,400);
  json = new JSONObject();
  json.put("name", "Es json").put("number", 1);
}

void draw() {
  background(100);
  text("FPS: " + frameRate, 10, 10);
  //write
  try {
    file = new FileWriter("c:\\tmp\\json.json");
  }
  catch(IOException e) {
    println("io exception");
  }

  try {
    file.write(json.toString());
    file.flush();
    file.close();
  }
  catch(IOException e) {
    e.printStackTrace();
  }

  //read
  try {
    FileReader r = new FileReader("c:\\tmp\\json.json");
    BufferedReader bufferedReader = new BufferedReader(r);
    String line = null;
    while ((line = bufferedReader.readLine()) != null) {
      jsonString += line;
    }
    bufferedReader.close();
    r.close();
    json = JSONObject.parse(jsonString);
  }
  catch(Exception e) {
    e.printStackTrace();
  }
  COUNTER = json.getInt("number");
  COUNTER = COUNTER + 1;
  println(json.getInt("number"));
  if (COUNTER % 60 == 0) {
    println("sec " + COUNTER % 60);
  }
}