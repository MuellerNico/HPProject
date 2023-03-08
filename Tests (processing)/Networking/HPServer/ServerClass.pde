import processing.core.*;
import java.io.*;
import java.lang.reflect.*;
import java.net.*;

public class Server implements Runnable {
  PApplet parent;
  Method serverEventMethod;

  volatile Thread thread;
  ServerSocket server;
  int port;

  protected final Object clientsLock = new Object[0];
  /** Number of clients currently connected. */
  public int clientCount;
  /** Array of client objects, useful length is determined by clientCount. */
  public Client[] clients;

  public Server(PApplet parent, int port) {
    this(parent, port, null);
  }

  public Server(PApplet parent, int port, String host) {
    this.parent = parent;
    this.port = port;

    try {
      if (host == null) {
        server = new ServerSocket(this.port);
      } else {
        server = new ServerSocket(this.port, 10, InetAddress.getByName(host));
      }
      //clients = new Vector();
      clients = new Client[10];

      thread = new Thread(this);
      thread.start();

      parent.registerMethod("dispose", this);

      try {
        serverEventMethod =
          parent.getClass().getMethod("serverEvent", Server.class, Client.class);
      } 
      catch (Exception e) {
        // no such method, or an error.. which is fine, just ignore
      }
    } 
    catch (IOException e) {
      //e.printStackTrace();
      thread = null;
      throw new RuntimeException(e);
      //errorMessage("<init>", e);
    }
  }

  public void disconnect(Client client) {
    client.stop();
    synchronized (clientsLock) {
      int index = clientIndex(client);
      if (index != -1) {
        removeIndex(index);
      }
    }
  }


  protected void removeIndex(int index) {
    synchronized (clientsLock) {
      clientCount--;
      // shift down the remaining clients
      for (int i = index; i < clientCount; i++) {
        clients[i] = clients[i + 1];
      }
      // mark last empty var for garbage collection
      clients[clientCount] = null;
    }
  }


  protected void disconnectAll() {
    synchronized (clientsLock) {
      for (int i = 0; i < clientCount; i++) {
        try {
          clients[i].stop();
        } 
        catch (Exception e) {
          // ignore
        }
        clients[i] = null;
      }
      clientCount = 0;
    }
  }


  protected void addClient(Client client) {
    synchronized (clientsLock) {
      if (clientCount == clients.length) {
        clients = (Client[]) PApplet.expand(clients);
      }
      clients[clientCount++] = client;
    }
  }


  protected int clientIndex(Client client) {
    synchronized (clientsLock) {
      for (int i = 0; i < clientCount; i++) {
        if (clients[i] == client) {
          return i;
        }
      }
      return -1;
    }
  }


  public boolean active() {
    return thread != null;
  }


  public String ip() {
    try {
      return InetAddress.getLocalHost().getHostAddress();
    } 
    catch (UnknownHostException e) {
      e.printStackTrace();
      return null;
    }
  }

  int lastAvailable = -1;

  public Client available() {
    synchronized (clientsLock) {
      int index = lastAvailable + 1;
      if (index >= clientCount) index = 0;

      for (int i = 0; i < clientCount; i++) {
        int which = (index + i) % clientCount;
        Client client = clients[which];
        //Check for valid client
        if (!client.active()) {
          removeIndex(which);  
          i--;                 

          which--;
        }
        if (client.available() > 0) {
          lastAvailable = which;
          return client;
        }
      }
    }
    return null;
  }

  public void stop() {
    dispose();
  }

  public void dispose() {
    thread = null;

    if (clients != null) {
      disconnectAll();
      clientCount = 0;
      clients = null;
    }

    try {
      if (server != null) {
        server.close();
        server = null;
      }
    } 
    catch (IOException e) {
      e.printStackTrace();
    }
  }


  @Override
    public void run() {
    while (Thread.currentThread() == thread) {
      try {
        Socket socket = server.accept();
        Client client = new Client(parent, socket);
        synchronized (clientsLock) {
          addClient(client);
          if (serverEventMethod != null) {
            try {
              serverEventMethod.invoke(parent, this, client);
            } 
            catch (Exception e) {
              System.err.println("Disabling serverEvent() for port " + port);
              Throwable cause = e;
              // unwrap the exception if it came from the user code
              if (e instanceof InvocationTargetException && e.getCause() != null) {
                cause = e.getCause();
              }
              cause.printStackTrace();
              serverEventMethod = null;
            }
          }
        }
      } 
      catch (SocketException e) {
        //thrown when server.close() is called and server is waiting on accept
        System.err.println("Server SocketException: " + e.getMessage());
        thread = null;
      } 
      catch (IOException e) {
        //errorMessage("run", e);
        e.printStackTrace();
        thread = null;
      }
    }
  }


  public void write(int data) {  // will also cover char
    synchronized (clientsLock) {
      int index = 0;
      while (index < clientCount) {
        if (clients[index].active()) {
          clients[index].write(data);
          index++;
        } else {
          removeIndex(index);
        }
      }
    }
  }


  public void write(byte data[]) {
    synchronized (clientsLock) {
      int index = 0;
      while (index < clientCount) {
        if (clients[index].active()) {
          clients[index].write(data);
          index++;
        } else {
          removeIndex(index);
        }
      }
    }
  }


  public void write(String data) {
    synchronized (clientsLock) {
      int index = 0;
      while (index < clientCount) {
        if (clients[index].active()) {
          clients[index].write(data);
          index++;
        } else {
          removeIndex(index);
        }
      }
    }
  }
}
