package core;

/**
 * Entity is everything that has an effect or moves
 * if hit box exists, it is round
 */

public abstract class Entity extends GameObject{

    abstract public void update();

    protected Entity(World world){
        super(world);
        world.entities.add(this);
    }
}