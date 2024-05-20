class Enemy2 {
  private PVector pos;
  private float vel;
  private float av = TWO_PI; 
  private float dv = 150; 
  private PVector dc = new PVector(1, 0);
  private ArrayList<Shot> shots; 
  private float shootInterval = 0.5f;
  private float lastShootTime = 0; 
  private float angle = 0; 
  private boolean pursuingPlayer = false; 
  private float radius = 150; 

  Enemy2(float x, float y, float vel) {
    pos = new PVector(x, y);
    this.vel = vel - 20;
    shots = new ArrayList<>(); 
  }

  void update(float et, PVector playerPos) {
    if (isPlayerInFieldOfView(playerPos)) {
      if (millis() - lastShootTime > shootInterval * 1000) {
        shootTowardsPlayer(playerPos);
        lastShootTime = millis();
      }

      PVector pursueDirection = PVector.sub(playerPos, pos);
      pos.add(pursueDirection.normalize().mult(vel * et));

      pursuingPlayer = true;
    } else {
      if (pursuingPlayer) {
        pursuingPlayer = false;
      }

      angle += et * (vel / radius); 
      pos.x += cos(angle) * radius * et;
      pos.y += sin(angle) * radius * et;
    }


    for (int i = shots.size() - 1; i >= 0; i--) {
      Shot shot = shots.get(i);
      if (shot.update(et)) {
        shots.remove(i);
      }
    }


    pos.x = constrain(pos.x, 0, width);
    pos.y = constrain(pos.y, 0, height);
  }

  boolean isPlayerInFieldOfView(PVector playerPos) {
    PVector directionToPlayer = PVector.sub(playerPos, pos);
    float distanceToPlayer = directionToPlayer.mag();
    return distanceToPlayer < dv;
  }

  void shootTowardsPlayer(PVector playerPos) {
    PVector shotDirection = PVector.sub(playerPos, pos).normalize();
    PVector shotPos = new PVector(pos.x, pos.y);
    shots.add(new Shot(shotPos, new PVector(shotDirection.x, shotDirection.y)));
  }

  void render() {
    fill(0, 0, 255);
    circle(pos.x, pos.y, 50);
    renderFieldOfView();
    for (Shot shot : shots) {
      shot.render();
    }
  }

  void renderFieldOfView() {
    stroke(255); 
    noFill();
    ellipse(pos.x, pos.y, dv * 2, dv * 2); 
  }
}
