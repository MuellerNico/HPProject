package gui.graphics;

import gui.ResLoader;
import processing.core.PImage;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

@Deprecated
public class Images {

    private static String path = System.getProperty("user.dir") + "/res/graphics/";
    private static List<String> fileNames = new ArrayList<>();
    private static HashMap<String, PImage> files = new HashMap<>();

    public static void init() {
        File folder = new File(path);
        File[] listOfFiles = folder.listFiles();

        if (listOfFiles != null) {
            for (File f : listOfFiles) {
                if (f.isFile()) {
                    fileNames.add(f.getName());
                    files.put(f.getName(), ResLoader.loadImage(f.getPath()));
                }
            }
        }
    }

    public static PImage get(String name) {
        return files.get(name);     // null check?
    }
}
