package server;

import core.Player;
import main.NetworkConstants;
import processing.data.JSONObject;

import java.io.IOException;
import java.net.*;


// "static" class
public final class Server implements NetworkConstants {

    private static DatagramSocket socket;
    private static byte[] receivingBuffer = new byte[MAX_PACKET_SIZE];

    private ServerGame game;
    private int port;

    public Server(ServerGame game, int port) {
        this.port = port;
        this.game = game;
    }


    public void start() {
        try {
            socket = new DatagramSocket(port);
        } catch (SocketException e) {
            e.printStackTrace();
        }

        new Thread(this::listen).start();

        System.out.println("started server at port " + port);
    }


    private void listen() {
        while (true) {
            DatagramPacket packet = new DatagramPacket(receivingBuffer, MAX_PACKET_SIZE);
            try {
                socket.receive(packet);
            } catch (IOException e) {
                e.printStackTrace();
            }
            processPacket(packet);  //executed when packet received
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


    private void sendToAll(byte[] data) {
        for (Player p : game.players) {
            send(data, p.address, p.port);
        }
    }


    private void processPacket(DatagramPacket packet) {     // function maybe too long

        byte[] data = packet.getData();

        JSONObject jsonData;
        try {   // we don't want to crash because of invalid JSON
            String content = new String(data, HEADER_SIZE, data.length - HEADER_SIZE);
            jsonData = JSONObject.parse(content);
        } catch (Exception e) {
            System.out.println("json error : packet = [" + packet + "]");
            return; // no point in passing data on
        }

        switch (data[0]) {

            case Headers.CONNECT:
                System.out.println("player connected: " + packet.getAddress());
                sendToAll(data);    // before initializing new player
//                System.out.println("CONNECT: gamestatus: " + game.getStatus().toString());
                send(game.getStatus().toString().getBytes(), packet.getAddress(), packet.getPort());    // send status back
                game.newPlayer(jsonData, packet.getAddress(), packet.getPort());
                break;

            case Headers.PLAYER_DATA:
                game.applyPlayerData(jsonData);
                sendToAll(data);    // repeat playerData
                break;

            case Headers.PLAYER_ACTION:
                System.out.println("playerAction: " + new String(data));
                game.handlePlayerAction(jsonData);
                break;

            case Headers.DISCONNECT:
                System.out.println("player disconnected: " + packet.getAddress());
                game.removePlayer(packet.getAddress());
                sendToAll(data);
                break;
        }
    }
}
