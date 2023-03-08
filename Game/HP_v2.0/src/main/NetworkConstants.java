package main;

public interface NetworkConstants {

    byte HEADER_SIZE = 1;  // do not change!!
    int MAX_PACKET_SIZE = 256;

    // not enum because of byte array packets
    class Headers {   // char because appending to string. 'C' == 67 -> true
        public static final char CONNECT = 'C';
        public static final char DISCONNECT = 'D';
        public static final char GAME_EVENT = 'E';
        public static final char PLAYER_DATA = 'P';
        public static final char PLAYER_ACTION = 'A';
    }
}
