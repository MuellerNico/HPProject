package main;

import client.ClientGame;
import server.ServerGame;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;
import javax.swing.JLabel;

import java.awt.GridLayout;

import java.awt.Color;

import javax.swing.JButton;
import javax.swing.JTextField;

import java.awt.FlowLayout;

import javax.swing.SwingConstants;

import java.awt.SystemColor;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.Set;

class Launcher extends JFrame {

    private JTextField serverPort;
    private JTextField clientConnectIp;
    private JTextField clientConnectPort;  // port to which onClient connects
    private JTextField clientLocalPort;


    void setDefault(int serverPort, String serverIp, int localPort) {
        this.serverPort.setText(String.valueOf(serverPort));
        this.clientConnectIp.setText(serverIp);
        this.clientLocalPort.setText(String.valueOf(localPort));
        this.clientConnectPort.setText(String.valueOf(serverPort));
    }


    private void onClient() {

        System.out.println("Launcher.onClient");
        new ClientGame(
                Utils.getAddress(clientConnectIp.getText()),
                Integer.parseInt(clientConnectPort.getText()),
                Integer.parseInt(clientLocalPort.getText())
        );

        if(!Settings.debugMode)
            this.dispose();
    }


    private void onServer() {

        System.out.println("Launcher.onServer");
        new ServerGame(Integer.parseInt(serverPort.getText()));

        if(!Settings.debugMode)
            this.dispose();
    }

    // window creation
    Launcher() {
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setBounds(100, 100, 450, 300);
        JPanel contentPane = new JPanel();
        contentPane.setBackground(SystemColor.windowBorder);
        contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
        setContentPane(contentPane);
        contentPane.setLayout(new GridLayout(0, 2, 0, 0));

        JPanel serverPanel = new JPanel();
        serverPanel.setBackground(new Color(154, 205, 50));
        serverPanel.setBorder(null);
        contentPane.add(serverPanel);
        serverPanel.setLayout(null);

        JLabel lblServer = new JLabel("server");
        lblServer.setHorizontalAlignment(SwingConstants.CENTER);
        lblServer.setBounds(110, 11, 92, 14);
        serverPanel.add(lblServer);

        JButton startServer = new JButton("Start Server");
        startServer.setBounds(10, 217, 192, 23);
        serverPanel.add(startServer);

        JPanel panel = new JPanel();
        panel.setBackground(new Color(154, 205, 50));
        panel.setBounds(10, 43, 192, 37);
        serverPanel.add(panel);
        panel.setLayout(new FlowLayout(FlowLayout.RIGHT, 5, 5));

        JLabel lblPort_1 = new JLabel("Port");
        panel.add(lblPort_1);

        serverPort = new JTextField();
        serverPort.setHorizontalAlignment(SwingConstants.LEFT);
        panel.add(serverPort);
        serverPort.setColumns(10);

        JLabel lblYourCurrentAddress = new JLabel("Current Address: ");
        lblYourCurrentAddress.setBounds(10, 170, 192, 14);
        serverPanel.add(lblYourCurrentAddress);

        String address = "unexpected error :/";
        try {
            address = InetAddress.getLocalHost().toString();
        } catch (UnknownHostException e) {
            e.printStackTrace();
        }
        JLabel addressLabel = new JLabel(address);
        addressLabel.setBounds(10, 192, 192, 14);
        serverPanel.add(addressLabel);

        JPanel clientPanel = new JPanel();
        clientPanel.setBackground(new Color(107, 142, 35));
        clientPanel.setBorder(null);
        contentPane.add(clientPanel);
        clientPanel.setLayout(null);

        JLabel lblClient = new JLabel("client");
        lblClient.setHorizontalAlignment(SwingConstants.CENTER);
        lblClient.setBounds(107, 11, 95, 14);
        clientPanel.add(lblClient);

        JButton connectClient = new JButton("Connect onClient");
        connectClient.setBounds(10, 217, 192, 23);
        clientPanel.add(connectClient);

        JPanel connectPanel = new JPanel();
        connectPanel.setBackground(new Color(107, 142, 35));
        connectPanel.setBounds(10, 43, 192, 163);
        clientPanel.add(connectPanel);
        connectPanel.setLayout(new GridLayout(3, 2, 0, 0));

        JPanel panel_1 = new JPanel();
        panel_1.setBackground(new Color(107, 142, 35));
        FlowLayout flowLayout = (FlowLayout) panel_1.getLayout();
        flowLayout.setAlignment(FlowLayout.RIGHT);
        connectPanel.add(panel_1);

        JLabel lblIp = new JLabel("IP");
        lblIp.setHorizontalAlignment(SwingConstants.LEFT);
        panel_1.add(lblIp);

        clientConnectIp = new JTextField();
        clientConnectIp.setHorizontalAlignment(SwingConstants.LEFT);
        panel_1.add(clientConnectIp);
        clientConnectIp.setColumns(10);

        JPanel panel_2 = new JPanel();
        panel_2.setBackground(new Color(107, 142, 35));
        FlowLayout flowLayout_2 = (FlowLayout) panel_2.getLayout();
        flowLayout_2.setAlignment(FlowLayout.RIGHT);
        connectPanel.add(panel_2);

        JLabel lblPort = new JLabel("Port");
        lblPort.setHorizontalAlignment(SwingConstants.LEFT);
        panel_2.add(lblPort);

        clientConnectPort = new JTextField();
        clientConnectPort.setHorizontalAlignment(SwingConstants.LEFT);
        clientConnectPort.setColumns(10);
        panel_2.add(clientConnectPort);

        JPanel panel_3 = new JPanel();
        panel_3.setBackground(new Color(107, 142, 35));
        FlowLayout flowLayout_1 = (FlowLayout) panel_3.getLayout();
        flowLayout_1.setAlignment(FlowLayout.RIGHT);
        connectPanel.add(panel_3);

        JLabel lblLocalPort = new JLabel("Local Port");
        lblLocalPort.setHorizontalAlignment(SwingConstants.LEFT);
        panel_3.add(lblLocalPort);

        clientLocalPort = new JTextField();
        clientLocalPort.setHorizontalAlignment(SwingConstants.LEFT);
        clientLocalPort.setColumns(10);
        panel_3.add(clientLocalPort);

        startServer.addActionListener((e) -> onServer());
        connectClient.addActionListener((e) -> onClient());
    }
}
