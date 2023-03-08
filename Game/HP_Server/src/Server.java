import processing.data.JSONObject;

import java.io.IOException;
import java.lang.management.PlatformLoggingMXBean;
import java.net.*;


public class Server {

    private int port;
    private SGame game;
    private Thread listener;
    private Thread writer;
    private DatagramSocket socket;
    private final int UPDATE_RATE = 16;
    private byte[] receivingBuffer = new byte[Constants.MAX_PACKET_SIZE];

    Server(int port, SGame game) {
        this.port = port;
        this.game = game;
    }


    public int getPort() {
        return port;
    }


    void start() {
        try {
            socket = new DatagramSocket(port);
        } catch (SocketException e) {
            e.printStackTrace();
            System.out.println("ERROR: not starting game");
            return;
        }

        game.start();
        listener = new Thread(this::listen, "HP-Server-InputListener");
        writer = new Thread(this::write, "HP-Server-OutputWriter");
        listener.start();
        //writer.start();   // don't spam gameStates
    }


    private void listen() {
        System.out.println("listening");

        while (true) {
            DatagramPacket packet = new DatagramPacket(receivingBuffer, Constants.MAX_PACKET_SIZE);
            try {
                socket.receive(packet);
            } catch (IOException e) {
                e.printStackTrace();
            }
            processPacket(packet);  //executed when packet received
        }
    }


    private void write() {
        long lastSent = 0;
        while (true) {
            if (System.currentTimeMillis() - 1000 / UPDATE_RATE > lastSent) {
                lastSent = System.currentTimeMillis();
                sendToAll(game.getGameState());
                System.out.println(game.getGameState());
            }
        }
    }


    private void send(byte[] data, InetAddress address, int port) {
        DatagramPacket packet = new DatagramPacket(data, data.length, address, port);
        try {
            socket.send(packet);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }


    private void processPacket(DatagramPacket packet) {     // TODO: too large => split up, switch header

        byte[] data = packet.getData();
        System.out.println(new String(data));

        switch (data[0]) {
            case Constants.Headers.CONNECT:
                System.out.println("player connected");
                game.newPlayer(packet.getAddress(), packet.getPort());
                break;

            case Constants.Headers.PLAYER_DATA:
                System.out.println("playerData: " + Constants.Headers.PLAYER_DATA + "  " + new String(data));
                try {
                    String content = new String(data, Constants.HEADER_SIZE, data.length - Constants.HEADER_SIZE);
                    JSONObject json = JSONObject.parse(content);
                    game.applyPlayerData(json);
                    sendToAll(data);    // repeat playerData
                } catch (RuntimeException e) {
                    e.printStackTrace();
                }
                break;

            case Constants.Headers.PLAYER_ACTION:
                System.out.println("playerAction: " + new String(data));
                try {
                    String content = new String(data, Constants.HEADER_SIZE, data.length - Constants.HEADER_SIZE);
                    JSONObject json = JSONObject.parse(content);
                    game.handlePlayerAction(json);
                    sendToAll(data);    // repeat playerData
                } catch (RuntimeException e) {
                    e.printStackTrace();
                }
                break;
        }
    }


    private void sendToAll(byte[] data) {
        for (SPlayer p : game.players) {
            send(data, p.address, p.port);
        }
    }
}
