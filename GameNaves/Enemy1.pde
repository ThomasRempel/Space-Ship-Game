class Enemy1 {
  private PVector pos;
  private float vel;
  private float av = PI / 3.0; 
  private float dv = 150;
  private PVector dc = new PVector(0, 1); 
  private float radius = 100; 
  private float angle = 0; 

  Enemy1(float x, float y, float vel) {
    pos = new PVector(x, y);
    this.vel = vel;
  }

  void update(float et, PVector playerPos) {
    if (isPlayerInFieldOfView(playerPos)) {
      PVector fleeDirection = PVector.sub(pos, playerPos);
      pos.add(fleeDirection.normalize().mult(vel * et));
    } else {     
      angle += et; 
      pos.x += cos(angle) * vel * et;
      pos.y += sin(angle) * vel * et;
    }

    pos.x = constrain(pos.x, 0, width);
    pos.y = constrain(pos.y, 0, height);
    if (pos.x == 0 && pos.y == height) { 
      pos.x = width;
      pos.y = 0;
    } else if (pos.x == width && pos.y == height) { 
      pos.x = 0;
      pos.y = 0;
    } else if (pos.x == 0 && pos.y == 0) { 
      pos.x = width;
      pos.y = height;
    } else if (pos.x == width && pos.y == 0) { 
      pos.x = 0;
      pos.y = height;
    }
  }

  boolean isPlayerInFieldOfView(PVector playerPos) {
    PVector directionToPlayer = PVector.sub(playerPos, pos);
    float angleToPlayer = PVector.angleBetween(directionToPlayer, dc); 
    float distanceToPlayer = directionToPlayer.mag();
    return (angleToPlayer < av / 2 && distanceToPlayer < dv);
  }

  void render() {
    fill(255, 0, 0); 
    circle(pos.x, pos.y, 50);
  }
}
