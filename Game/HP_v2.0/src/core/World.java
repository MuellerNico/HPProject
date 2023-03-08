package core;

import processing.core.PVector;
import processing.data.JSONObject;

import java.util.ArrayList;
import java.util.List;

/**
 * should not modify itself and only serve as container and updater/physics
 *
 * adding and removing either by instance itself or game class
 */

public class World {    // where physics happen (they tell)


    public ArrayList<Entity> entities = new ArrayList<>();  // filled by entity super class
    public ArrayList<GameObject> gameObjects = new ArrayList<>();   // filled by gameObject super class

    public World(){
        new Obstacle(this, new PVector(300,0), 400, 130);
        new Obstacle(this, new PVector(100,100), 200, 200); // tmp
    }

    public boolean init(JSONObject init){   //initializing world with server data. If server side read from file
        return false;
    }

    public void update(){
        for (int i=0; i<entities.size(); i++){
            entities.get(i).update();
        }
    }
}
