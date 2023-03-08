import processing.core.*;

import java.io.*;
import java.lang.reflect.*;
import java.net.*;

public class Client implements Runnable {

  protected static final int MAX_BUFFER_SIZE = 1 << 27; // 128 MB

  PApplet parent;
  Method clientEventMethod;
  Method disconnectEventMethod;

  volatile Thread thread;
  Socket socket;
  int port;
  String host;

  public InputStream input;
  public OutputStream output;

  final Object bufferLock = new Object[0];

  byte buffer[] = new byte[32768];
  int bufferIndex;
  int bufferLast;

  boolean disposeRegistered = false;


  public Client(PApplet parent, String host, int port) {
    this.parent = parent;
    this.host = host;
    this.port = port;

    try {
      socket = new Socket(this.host, this.port);
      input = socket.getInputStream();
      output = socket.getOutputStream();

      thread = new Thread(this);
      thread.start();

      parent.registerMethod("dispose", this);
      disposeRegistered = true;

      try {
        clientEventMethod =
          parent.getClass().getMethod("clientEvent", Client.class);
      } 
      catch (Exception e) {
      }
      try {
        disconnectEventMethod =
          parent.getClass().getMethod("disconnectEvent", Client.class);
      } 
      catch (Exception e) {
        // no such method, or an error.. which is fine, just ignore
      }
    } 
    catch (IOException e) {
      e.printStackTrace();
      dispose();
    }
  }



  public Client(PApplet parent, Socket socket) throws IOException {
    this.parent = parent;
    this.socket = socket;

    input = socket.getInputStream();
    output = socket.getOutputStream();

    thread = new Thread(this);
    thread.start();


    try {
      clientEventMethod =
        parent.getClass().getMethod("clientEvent", Client.class);
    } 
    catch (Exception e) {
      // no such method, or an error.. which is fine, just ignore
    }
    // do the same for disconnectEvent(Client c);
    try {
      disconnectEventMethod =
        parent.getClass().getMethod("disconnectEvent", Client.class);
    } 
    catch (Exception e) {
      // no such method, or an error.. which is fine, just ignore
    }
  }

  public void stop() {    
    if (disconnectEventMethod != null && thread != null) {
      try {
        disconnectEventMethod.invoke(parent, this);
      } 
      catch (Exception e) {
        Throwable cause = e;
        // unwrap the exception if it came from the user code
        if (e instanceof InvocationTargetException && e.getCause() != null) {
          cause = e.getCause();
        }
        cause.printStackTrace();
        disconnectEventMethod = null;
      }
    }
    if (disposeRegistered) {
      parent.unregisterMethod("dispose", this);
      disposeRegistered = false;
    }
    dispose();
  }

  public void dispose() {
    thread = null;
    try {
      if (input != null) {
        input.close();
        input = null;
      }
    } 
    catch (Exception e) {
      e.printStackTrace();
    }

    try {
      if (output != null) {
        output.close();
        output = null;
      }
    } 
    catch (Exception e) {
      e.printStackTrace();
    }

    try {
      if (socket != null) {
        socket.close();
        socket = null;
      }
    } 
    catch (Exception e) {
      e.printStackTrace();
    }
  }


  @Override
    public void run() {
    byte[] readBuffer;
    { // make the read buffer same size as socket receive buffer so that
      // we don't waste cycles calling listeners when there is more data waiting
      int readBufferSize = 1 << 16; // 64 KB (default socket receive buffer size)
      try {
        readBufferSize = socket.getReceiveBufferSize();
      } 
      catch (SocketException ignore) {
      }
      readBuffer = new byte[readBufferSize];
    }
    while (Thread.currentThread() == thread) {
      try {
        while (input != null) {
          int readCount;

          // try to read a byte using a blocking read. 
          // An exception will occur when the sketch is exits.
          try {
            readCount = input.read(readBuffer, 0, readBuffer.length);
          } 
          catch (SocketException e) {
            System.err.println("Client SocketException: " + e.getMessage());
            // the socket had a problem reading so don't try to read from it again.
            stop();
            return;
          }

          // read returns -1 if end-of-stream occurs (for example if the host disappears)
          if (readCount == -1) {
            System.err.println("Client got end-of-stream.");
            stop();
            return;
          }

          synchronized (bufferLock) {
            int freeBack = buffer.length - bufferLast;
            if (readCount > freeBack) {
              // not enough space at the back
              int bufferLength = bufferLast - bufferIndex;
              byte[] targetBuffer = buffer;
              if (bufferLength + readCount > buffer.length) {
                // can't fit even after compacting, resize the buffer
                // find the next power of two which can fit everything in
                int newSize = Integer.highestOneBit(bufferLength + readCount - 1) << 1;
                if (newSize > MAX_BUFFER_SIZE) {
                  // buffer is full because client is not reading (fast enough)
                  System.err.println("Client: can't receive more data, buffer is full. " +
                    "Make sure you read the data from the client.");
                  stop();
                  return;
                }
                targetBuffer = new byte[newSize];
              }
              // compact the buffer (either in-place or into the new bigger buffer)
              System.arraycopy(buffer, bufferIndex, targetBuffer, 0, bufferLength);
              bufferLast -= bufferIndex;
              bufferIndex = 0;
              buffer = targetBuffer;
            }
            // copy all newly read bytes into the buffer
            System.arraycopy(readBuffer, 0, buffer, bufferLast, readCount);
            bufferLast += readCount;
          }

          // now post an event
          if (clientEventMethod != null) {
            try {
              clientEventMethod.invoke(parent, this);
            } 
            catch (Exception e) {
              System.err.println("error, disabling clientEvent() for " + host);
              Throwable cause = e;
              // unwrap the exception if it came from the user code
              if (e instanceof InvocationTargetException && e.getCause() != null) {
                cause = e.getCause();
              }
              cause.printStackTrace();
              clientEventMethod = null;
            }
          }
        }
      } 
      catch (IOException e) {
        //errorMessage("run", e);
        e.printStackTrace();
      }
    }
  }


  public boolean active() {
    return (thread != null);
  }

  public String ip() {
    if (socket != null) {
      return socket.getInetAddress().getHostAddress();
    }
    return null;
  }


  public int available() {
    synchronized (bufferLock) {
      return (bufferLast - bufferIndex);
    }
  }

  public void clear() {
    synchronized (bufferLock) {
      bufferLast = 0;
      bufferIndex = 0;
    }
  }

  public int read() {
    synchronized (bufferLock) {
      if (bufferIndex == bufferLast) return -1;

      int outgoing = buffer[bufferIndex++] & 0xff;
      if (bufferIndex == bufferLast) {  // rewind
        bufferIndex = 0;
        bufferLast = 0;
      }
      return outgoing;
    }
  }


  public char readChar() {
    synchronized (bufferLock) {
      if (bufferIndex == bufferLast) return (char) (-1);
      return (char) read();
    }
  }

  public byte[] readBytes() {
    synchronized (bufferLock) {
      if (bufferIndex == bufferLast) return null;

      int length = bufferLast - bufferIndex;
      byte outgoing[] = new byte[length];
      System.arraycopy(buffer, bufferIndex, outgoing, 0, length);

      bufferIndex = 0;  // rewind
      bufferLast = 0;
      return outgoing;
    }
  }


  public byte[] readBytes(int max) {
    synchronized (bufferLock) {
      if (bufferIndex == bufferLast) return null;

      int length = bufferLast - bufferIndex;
      if (length > max) length = max;
      byte outgoing[] = new byte[length];
      System.arraycopy(buffer, bufferIndex, outgoing, 0, length);

      bufferIndex += length;
      if (bufferIndex == bufferLast) {
        bufferIndex = 0;  // rewind
        bufferLast = 0;
      }

      return outgoing;
    }
  }


  public int readBytes(byte bytebuffer[]) {
    synchronized (bufferLock) {
      if (bufferIndex == bufferLast) return 0;

      int length = bufferLast - bufferIndex;
      if (length > bytebuffer.length) length = bytebuffer.length;
      System.arraycopy(buffer, bufferIndex, bytebuffer, 0, length);

      bufferIndex += length;
      if (bufferIndex == bufferLast) {
        bufferIndex = 0;  // rewind
        bufferLast = 0;
      }
      return length;
    }
  }


  public byte[] readBytesUntil(int interesting) {
    byte what = (byte)interesting;

    synchronized (bufferLock) {
      if (bufferIndex == bufferLast) return null;

      int found = -1;
      for (int k = bufferIndex; k < bufferLast; k++) {
        if (buffer[k] == what) {
          found = k;
          break;
        }
      }
      if (found == -1) return null;

      int length = found - bufferIndex + 1;
      byte outgoing[] = new byte[length];
      System.arraycopy(buffer, bufferIndex, outgoing, 0, length);

      bufferIndex += length;
      if (bufferIndex == bufferLast) {
        bufferIndex = 0; // rewind
        bufferLast = 0;
      }
      return outgoing;
    }
  }

  public int readBytesUntil(int interesting, byte byteBuffer[]) {
    byte what = (byte)interesting;

    synchronized (bufferLock) {
      if (bufferIndex == bufferLast) return 0;

      int found = -1;
      for (int k = bufferIndex; k < bufferLast; k++) {
        if (buffer[k] == what) {
          found = k;
          break;
        }
      }
      if (found == -1) return 0;

      int length = found - bufferIndex + 1;
      if (length > byteBuffer.length) {
        System.err.println("readBytesUntil() byte buffer is" +
          " too small for the " + length +
          " bytes up to and including char " + interesting);
        return -1;
      }
      //byte outgoing[] = new byte[length];
      System.arraycopy(buffer, bufferIndex, byteBuffer, 0, length);

      bufferIndex += length;
      if (bufferIndex == bufferLast) {
        bufferIndex = 0;  // rewind
        bufferLast = 0;
      }
      return length;
    }
  }


  public String readString() {
    byte b[] = readBytes();
    if (b == null) return null;
    return new String(b);
  }

  public String readStringUntil(int interesting) {
    byte b[] = readBytesUntil(interesting);
    if (b == null) return null;
    return new String(b);
  }


  public void write(int data) {  // will also cover char
    try {
      output.write(data & 0xff);  // for good measure do the &
      output.flush();   // hmm, not sure if a good idea
    } 
    catch (Exception e) { // null pointer or serial port dead
      //errorMessage("write", e);
      //e.printStackTrace();
      //dispose();
      //disconnect(e);
      e.printStackTrace();
      stop();
    }
  }


  public void write(byte data[]) {
    try {
      output.write(data);
      output.flush();   // hmm, not sure if a good idea
    } 
    catch (Exception e) { // null pointer or serial port dead
      //errorMessage("write", e);
      //e.printStackTrace();
      //disconnect(e);
      e.printStackTrace();
      stop();
    }
  }


  public void write(String data) {
    write(data.getBytes());
  }

}
