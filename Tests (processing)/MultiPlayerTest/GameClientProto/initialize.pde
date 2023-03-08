// probably tmp

void connectToServer() {
  String address = JOptionPane.showInputDialog("Enter IP and Port \n(format: 192.168.1.111:1234) \ninvalid IP will cause a crash");
  address = address.trim();
  String a[] = address.split(":");
  SERVER_PORT = Integer.parseInt(a[1]);
  SERVER_IP = a[0];
  localClient = new Client(this, SERVER_IP, SERVER_PORT);
  try{
  LOCAL_IP = int(InetAddress.getLocalHost().getHostAddress().replace(".", ""));
  println("connected to: " + SERVER_IP + ":" + SERVER_PORT + " My IP = " + LOCAL_IP);  // TODO: also prints when exception is thrown
  }
    catch (UnknownHostException e) {
      e.printStackTrace();
      println("(!) ERROR: unable to setup server socket \ncheck log for details");
    }
}
