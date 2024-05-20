class TelaFinal {
  void exibir() {
    background(0);
    textSize(50);
    fill(255);
    text("O Jogo Acabou!!\nA sua pontuação foi de: " + pontuacao, width/2, height/2 - 50);
    text("Tente aumentar ela ", width/2, height/2 + 60);
    textSize(40);
    text("Vidas restantes: " + playerLives, width/2, height/2 + 130);
  }
}

  boolean collideWithTriangle(float x, float y) {
    return (x > width/2 - 20 && x < width/2 + 20 && y > height/2 - 30 && y < height/2 + 20);
  }
  
