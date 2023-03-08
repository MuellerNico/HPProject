import java.net.InetAddress;
import java.net.UnknownHostException;

public class SMain { //SERVER

    public static final int port = 27914;

    public static void main(String args[]) {

        // TODO: one project only? what about local player, but shared constants and more

        SGame game = new SGame();
        Server s = new Server(port, game);
        s.start();

        try {
            InetAddress address = InetAddress.getLocalHost();
            System.out.println("Server running at: " + address + ":" + port);
        } catch (UnknownHostException e) {
            e.printStackTrace();
        }

    }
}
