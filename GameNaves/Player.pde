class Player {
  private PVector pos;
  private PVector dir;
  private float vel;
  private ArrayList<Shot> shots;
  private float startTime;

  Player(float x, float y, float vel) {
    pos = new PVector(x, y);
    this.vel = vel;
    dir = new PVector(1, 0);
    shots = new ArrayList<>();
    startTime = millis();
  }

  void update(float et) {
    PVector mouse = new PVector(mouseX, mouseY);
    dir = PVector.sub(mouse, pos).normalize();
    PVector m = PVector.mult(dir, vel * et);
    pos.add(m);
    
    Shot shotToRemove = null;
    for (Shot shot: shots) {
      if (shot.update(et))
        shotToRemove = shot;
    }
    if (shotToRemove != null) {
      shots.remove(shotToRemove);
    }
  }

  void render() {
    circle(pos.x, pos.y, 50);
    for (Shot shot: shots) {
      shot.render();
    }
  }

  void shoot() {
    shots.add(new Shot(new PVector(pos.x, pos.y), new PVector(dir.x, dir.y)));
  }
}
