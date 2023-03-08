package main;

import gui.ResLoader;
import gui.audio.Soundtrack;


/**
 * A single machine can run a server and client at the same time
 * but not 2 clients (player identification via ip)
 * <p>
 * 2D graphics rendered in 3D for automatic layer handling
 * test collisions 2D only
 */

public class Main {

    public static void main(String[] args) {

        System.out.println("Location: " + System.getProperty("user.dir"));
        System.out.println("HP_v2.0 - by Nico Müller\n-------------------------\n");

        //ResLoader.loadClip("dumbledores_army.wav").start();
        //Soundtrack.init();
        //Soundtrack.playRandom();

//         starting launcher
        Launcher launcher = new Launcher();
        launcher.setDefault(27914, Settings.defaultServer, Utils.Debug.randomPort());
        launcher.setVisible(true);
    }
}
