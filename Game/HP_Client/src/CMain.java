import processing.core.PApplet;
import processing.core.PVector;

import javax.swing.*;
import java.net.InetAddress;
import java.net.UnknownHostException;

public class CMain {

    private static InetAddress localAddress;
    private static int localPort;
    static String localIp;

    private static final int serverPort = 27914;


    public static void main(String[] args) {

        localAddress = getLocalAddress();
        localIp = localAddress.getHostAddress();
        InetAddress serverAddress;

        try {
            serverAddress = InetAddress.getByName("192.168.1.108");  // tmp: later input or selection
            localPort = Integer.parseInt(JOptionPane.showInputDialog("Enter a port between 10'000 and 49'000", "27915"));
        } catch (UnknownHostException e) {
            e.printStackTrace();
            System.out.println("CMain.main: error on serverAddress.\nshutting down...");
            return;
        }

        Client client = new Client(localPort);
        client.connect(serverAddress, serverPort);
    }


    private static InetAddress getLocalAddress(){
        try {
            localAddress = InetAddress.getLocalHost();
            return  localAddress;
        } catch (UnknownHostException e) {
            e.printStackTrace();
            System.out.println("CMain.main: ERROR");
            System.exit(-1);
            return null;
        }
    }
}
