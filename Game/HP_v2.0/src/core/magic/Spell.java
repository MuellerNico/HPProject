package core.magic;

import core.*;

/**
 * Does nothing.
 *
 * if passing a vector as parameter make sure you use v.copy() when calling constructor
 */

public abstract class Spell extends Entity {
    protected Spell(World world){
        super(world);
    }
}
