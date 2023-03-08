public class Constants {  // <65

    static final byte HEADER_SIZE = 1;  // do not change!!
    static final int MAX_PACKET_SIZE = 256;

    public static class Headers {   // char because appending to string. 'C' == 67 -> true
        public static final char CONNECT = 'C';
        public static final char DISCONNECT = 'D';
        public static final char GAME_EVENT = 'E';
        public static final char PLAYER_DATA = 'P';
        public static final char PLAYER_ACTION = 'A';
    }

    public static class EventType {     // subcategory for gameEvent
        public static final String SPELL = "spell";
        public static final String HIT = "hit";
        public static final String DEATH = "death";
    }

    public static class ActionType {    // subcategory for playerAction
        public static final String SPELL = "spell"; // tmp, later specific
    }
}