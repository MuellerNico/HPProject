import processing.core.PVector;
import processing.data.JSONObject;

import java.net.InetAddress;

public class SPlayer {

    public InetAddress address;
    public int port;

    PVector position = new PVector();
    PVector velocity = new PVector();
    PVector orientation = new PVector();

    JSONObject data = new JSONObject();

    SPlayer(InetAddress address, int port){
        this.address = address;
        this.port = port;
    }

    public void applyData(JSONObject data){     // has to contain ip !! // TODO: is not called
        this.data = data;
        this.position.set(data.getInt("posX"), data.getInt("posY"));
        this.velocity.set(data.getInt("velX"), data.getInt("velY"));
        this.orientation.set(data.getInt("oriX"), data.getInt("oriY"));
    }

    void update(){
          position.add(velocity);   //acceleration done client side
    }
}
