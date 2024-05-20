  PVector playerPos = new PVector(512, 384);
  PVector playerDir = new PVector(1, 0);
  PVector enemyPos = new PVector(612, 200);
  float playerStartTime = 0;
  float playerVel = 200f;
  float lastEnemyRespawnTime = 0; 
  float enemyRespawnTime = 3.0f; 
  float lastEnemyHitTime = -enemyRespawnTime; 
  float enemyVelClose = 300f; 
  float enemyVelFar = 100f; 
  float fleeDistance = 200; 
  float changeInterval = 2; 
  float lastChangeTime = 0; 
  ArrayList<Shot> playerShots = new ArrayList<>();
  ArrayList<Asteroide> asteroides;
  final int NUM_ASTEROIDES = 16; 
  int pontuacao = 0; 
  int playerLives = 5; 
  boolean mostrarTelaFinal = false; 
  boolean enemyRespawning = false; 
  
  Enemy2 enemy2;
  TelaFinal telaFinal;
  TelaInicial telaInicial;
  
  void setup() {
    size(1024, 700);
    playerStartTime = millis();
    enemy2 = new Enemy2(300, 300, 150f);
    telaInicial = new TelaInicial("Thomas Rempel", "O Seu objetivo é matar o foguete vermelho, e não deixar a azul acertar um tiro em você \n Você tem 5 vidas \n Cada asteroide que você destruir, você ganha 10 pontos, e a cada vez que matar o foguete vermelho você ganha 20 pontos \n Quando tiver 200 pontos, você poderá pegar um poder para acabar com o jogo.");
    telaFinal = new TelaFinal();
    asteroides = new ArrayList<>();
    for (int i = 0; i < NUM_ASTEROIDES; i++) {
      float x = random(width);
      float y = random(height);
      float radius = random(20, 50);
      asteroides.add(new Asteroide(x, y, radius));
    }
  }
  
  
  
  
  void draw() {
    if (telaInicial.telaInicial) {
      telaInicial.desenhar();
    } else if (telaInicial.jogando && !mostrarTelaFinal) {
      float playerElapsedTime = (millis() - playerStartTime) / 1000f;
      playerStartTime = millis();
  
      background(0);
      updatePlayer(playerElapsedTime);
  
      if (!enemyRespawning && millis() / 1000f - lastEnemyHitTime >= enemyRespawnTime) {
        updateEnemy(playerElapsedTime);
      }
  
      updateEnemy2(playerElapsedTime);
      checkShotCollision();
  
      for (Asteroide asteroide : asteroides) {
        asteroide.update(playerElapsedTime);
        asteroide.render();
      }
  
      render();
      fill(255);
      textSize(20);
      text("Vidas: " + playerLives, 50, 40);
      text("Pontuação: " + pontuacao, 70, 70);
  
      if (pontuacao >= 200) {
        fill(255, 223, 0);
        stroke(255, 255, 0);
        triangle(width / 2, height / 2 - 50, width / 2 - 20, height / 2, width / 2, height / 2 + 50);
        triangle(width / 2, height / 2 - 50, width / 2 + 20, height / 2, width / 2, height / 2 + 50);
      }
  
      if (pontuacao >= 200 && collideWithTriangle(playerPos.x, playerPos.y)) {
        mostrarTelaFinal = true;
      }
    } else {
      telaFinal.exibir();
    }
  
    if (enemyRespawning && millis() - lastEnemyRespawnTime >= 3000) {
      enemyPos = new PVector(random(width), random(height));
      enemyRespawning = false;
    }
  }
  

  void updatePlayer(float et) {
    PVector mouse = new PVector(mouseX, mouseY);
    playerDir = PVector.sub(mouse, playerPos).normalize();
    PVector m = PVector.mult(playerDir, playerVel * et);
    playerPos.add(m);
    
    Shot shotToRemove = null;
    for (Shot shot: playerShots) {
      if (shot.update(et))
        shotToRemove = shot;
    }
    if (shotToRemove != null) {
      playerShots.remove(shotToRemove);
    }
  }
  
  void updateEnemy(float et) {
    PVector fleeDirection = PVector.sub(enemyPos, playerPos); 
    if (fleeDirection.mag() < fleeDistance) { 
      enemyPos.add(fleeDirection.normalize().mult(enemyVelClose * et)); 
    } else {

      if (millis() / 1000f - lastEnemyHitTime >= enemyRespawnTime) { 
        float radius = 100; 
        float angle = millis() * 0.001f * enemyVelFar / radius; 
        enemyPos.x += cos(angle) * enemyVelFar * et; 
        enemyPos.y += sin(angle) * enemyVelFar * et; 
      }
    }
    
    enemyPos.x = constrain(enemyPos.x, 0, width);
    enemyPos.y = constrain(enemyPos.y, 0, height);
  }
  
  
  
  void updateEnemy2(float et) {
    enemy2.update(et, playerPos); 
  }
  
  void checkShotCollision() {
    // Verifica colisão entre os tiros do jogador e os asteroides
    for (int i = playerShots.size() - 1; i >= 0; i--) {
      Shot shot = playerShots.get(i);
      for (int j = asteroides.size() - 1; j >= 0; j--) {
        Asteroide asteroide = asteroides.get(j);
        float distance = PVector.dist(shot.pos, asteroide.pos);
        if (distance < asteroide.radius) {
          playerShots.remove(i); 
          asteroides.remove(j); 
          pontuacao += 10; 
          break; 
        }
      }
    }
    
    // Verifica colisão entre os tiros do jogador e o inimigo
    for (int i = playerShots.size() - 1; i >= 0; i--) {
      Shot shot = playerShots.get(i);
      float distance = PVector.dist(shot.pos, enemyPos);
      if (distance < 32) {
        playerShots.remove(i); 
        pontuacao += 20;
        enemyPos = new PVector(-100, -100);
        enemyRespawning = true;
        lastEnemyRespawnTime = millis();
      }
    }
    
    // Verifica colisão entre os tiros do inimigo2 e o jogador
    for (int i = enemy2.shots.size() - 1; i >= 0; i--) {
      Shot shot = enemy2.shots.get(i);
      float distance = PVector.dist(shot.pos, playerPos);
      if (distance < 32) {
        enemy2.shots.remove(i); 
        playerLives--; 
        if (playerLives <= 0) { 
          mostrarTelaFinal = true;
        }
      }
    }
  }
  
  
  void render() {
    fill(0, 255, 0);
    circle(playerPos.x, playerPos.y, 50);
    fill(255, 0, 0);
    circle(enemyPos.x, enemyPos.y, 50);
    enemy2.render(); 
    fill(155);  
    for (Shot shot: playerShots) {
      shot.render();
    }
  }
  
  void mousePressed() {
    if (telaInicial.telaInicial) {
      telaInicial.verificarClique();
    } else if (telaInicial.jogando) {
      playerShots.add(shoot());
    }
  }
  
  Shot shoot() {
    return new Shot(new PVector(playerPos.x, playerPos.y), new PVector(playerDir.x, playerDir.y));
  }
