package gui.audio;

import gui.ResLoader;

import javax.sound.sampled.*;
import java.io.File;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Random;

@Deprecated
public class Soundtrack {

    private static String path = System.getProperty("user.dir") + "/res/audio/soundtrack/";
    private static List<String> fileNames = new ArrayList<>();
    private static HashMap<String, Clip> files = new HashMap<>();

    public static void init() {
        File folder = new File(path);
        File[] listOfFiles = folder.listFiles();

        if (listOfFiles != null) {
            for (File f : listOfFiles) {
                if (f.isFile()) {
                    fileNames.add(f.getName());
                    files.put(f.getName(), ResLoader.loadClip(f.getName()));
                }
            }
        }
    }

    public static void play(String name) {
        Clip clip = files.get(name);
        if (clip != null) {
            stop();
            clip.start();
        }
    }

    public static void stop() {
        for (Clip c : files.values())
            c.stop();
    }

    public static void playRandom() {
        int index = new Random().nextInt(fileNames.size());
        play(fileNames.get(index));
    }
}