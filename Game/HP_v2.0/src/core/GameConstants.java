package core;

public interface GameConstants {
    enum GameEvent{
        SPELL,
        HIT,
        DEATH
    }

    // TODO: move to GameConstants
    enum Level {
        GROUND,
        ON_GROUND,
        PET,
        FENCE,
        SPELL,
        PLAYER,
        HAGRID,
        LAMP,
        ROOF,
        GUI
    }
}
