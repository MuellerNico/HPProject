package gui;

import processing.core.PImage;
import processing.data.JSONObject;

import javax.imageio.ImageIO;
import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.Clip;
import java.io.*;
import java.nio.file.Path;
import java.nio.file.Paths;

public class ResLoader {

    public static String resPath = System.getProperty("user.dir") + "/res/";

    public static PImage loadImage(String filename) {
        Path path = Paths.get(resPath, "graphics/", filename);
        try {
            return new PImage(ImageIO.read(path.toFile()));
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }


    public static Clip loadClip(String filename) {
        Path path = Paths.get(resPath, "/audio/soundtrack/", filename);
        try {
            AudioInputStream audioIn = AudioSystem.getAudioInputStream(path.toFile());
            Clip clip = AudioSystem.getClip();
            clip.open(audioIn);
            return clip;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }


    public static String loadString(String filename) {
        StringBuffer file = new StringBuffer();
        String line;
        try {
            BufferedReader br = new BufferedReader(new FileReader(resPath + "data/" + filename));
            while ((line = br.readLine()) != null) {
                file.append(line);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return file.toString();
    }


    public static JSONObject loadJSON(String filename) {
        return JSONObject.parse(loadString(filename));
    }
}

