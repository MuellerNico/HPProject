abstract class Spell extends GameObject {  // prob only attack spells

  final PVector origin;

  Spell(PVector pos, PVector or) {
    super(pos);
    origin = pos.copy();
    map.toUpdate.add(this);
  }

  abstract void onImpact();
}