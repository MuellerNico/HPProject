package client;

import gui.ResLoader;
import main.NetworkConstants;
import processing.data.JSONObject;

import java.io.IOException;
import java.net.*;

public class Client implements NetworkConstants {

    public int localPort;
    public String localIp;
    private InetAddress connectedAddress;
    private int connectedPort;
    private ClientGame game;

    private Thread listener;
    private DatagramSocket socket;

    private byte[] receivingBuffer = new byte[MAX_PACKET_SIZE];     // currently 256 bytes


    public Client(ClientGame game, int localPort) {
        listener = new Thread(this::listen);
        this.localPort = localPort;
        this.game = game;
    }


    JSONObject connect(InetAddress address, int port) {

        this.connectedAddress = address;
        this.connectedPort = port;

        try {
            localIp = InetAddress.getLocalHost().getHostAddress();
            socket = new DatagramSocket(localPort);
        } catch (SocketException | UnknownHostException e) {
            e.printStackTrace();
        }

        send((Headers.CONNECT + game.localPlayer.profile.toString()).getBytes());

        System.out.println("connecting...");
        String initString = new String(receive().getData());  // maybe separate thread (could get stuck)
        System.out.println("connected!");

        listener.start();   // for further information
        return JSONObject.parse(initString);
    }


    public void send(byte[] data) {
        // maybe overload with string ars
        DatagramPacket packet = new DatagramPacket(data, data.length, connectedAddress, connectedPort);
        try {
            socket.send(packet);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }


    private DatagramPacket receive() {
        DatagramPacket packet = new DatagramPacket(receivingBuffer, MAX_PACKET_SIZE);
        try {
            socket.receive(packet);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return packet;
    }


    private void listen() {     // main thread
        while (true) {
            processPacket(receive());
        }
    }


    private void processPacket(DatagramPacket packet) {

        byte[] data = packet.getData();
//        System.out.println("client.processPacket: " + new String(data));
        JSONObject jsonData;
        try {   // we don't want to crash because of invalid JSON
            String content = new String(data, HEADER_SIZE, data.length - HEADER_SIZE);
            jsonData = JSONObject.parse(content);
        } catch (Exception e) {
            e.printStackTrace();
            return; // no point in passing data on
        }

        switch (data[0]) {
            case Headers.PLAYER_DATA:
                game.applyPlayerData(jsonData);
                break;
            case Headers.CONNECT:   // TODO: (!) id in connect block. Make player name!
                game.newPlayer(jsonData);
                break;
            case Headers.DISCONNECT:
                game.removePlayer(jsonData.getString("name"));
                break;
        }
    }


    public void disconnect() {
        send(new byte[]{Headers.DISCONNECT});
        socket.close();
    }
}
