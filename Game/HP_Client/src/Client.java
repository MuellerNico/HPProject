import processing.data.JSONObject;
import java.io.IOException;
import java.net.*;

public class Client {

    private int localPort;
    private int serverPort;
    private CGame game;              // where to pass data
    private Thread listener;         // receive data
    private InetAddress serverAddress;
    private DatagramSocket socket;
    private JSONObject jsonData;

    private byte[] receivingBuffer = new byte[Constants.MAX_PACKET_SIZE];     // currently 256 bytes


    Client(int localPort) {
        this.listener = new Thread(this::listen);
        this.localPort = localPort;
        this.game = new CGame(this);
    }


    void connect(InetAddress serverAddress, int serverPort) {

        try {
            socket = new DatagramSocket(localPort);
        } catch (SocketException e) {
            e.printStackTrace();
        }

        this.serverAddress = serverAddress;
        this.serverPort = serverPort;
        listener.start();

        send(new byte[]{Constants.Headers.CONNECT});    // tmp: later more information
        game.start();   // later with received map info
    }


    void disconnect(){
        send(new byte[]{Constants.Headers.DISCONNECT});
        socket.close();
    }


    private void listen() {
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


    private void processPacket(DatagramPacket packet) {
        byte[] data = packet.getData();

        try {
            String content = new String(data, Constants.HEADER_SIZE, data.length - Constants.HEADER_SIZE);
            jsonData = JSONObject.parse(content);
        } catch (Exception e) {
            e.printStackTrace();
            return; // no point in passing data on
        }

        switch (data[0]) {
            case Constants.Headers.PLAYER_DATA:
                game.applyPlayerData(jsonData);
                break;
            case Constants.Headers.GAME_EVENT:
                game.gameEvent(jsonData);
                break;
        }
    }


    void send(byte[] data) {
        DatagramPacket packet = new DatagramPacket(data, data.length, serverAddress, serverPort);

        try {
            socket.send(packet);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
