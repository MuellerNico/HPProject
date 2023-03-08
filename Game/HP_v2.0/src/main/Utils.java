package main;

import main.NetworkConstants;

import java.net.InetAddress;
import java.net.UnknownHostException;

/**
 * container for useful functions
 * not the elegant way but efficient
 */

public class Utils {

    public static void log(Object o){
        System.out.println("[log] " + o);
    }

    public static InetAddress getAddress(String ip){
        try {
            return InetAddress.getByName(ip);
        } catch (UnknownHostException e) {
            System.out.println("core.Utils.getAddress: invalid ip");
            e.printStackTrace();
        }
        return null;
    }

    public static class Debug{
        public static String randomName(){
            return "Player" + (int) (Math.random()*128);
        }

        public static int randomPort(){
            // 20'000 < port < 35'000
            return 20000 + (int) (Math.random() * 15000);
        }
    }
}
