// Classe TelaInicial
class TelaInicial {
  String aluno;
  String instrucao;
  float botaoX, botaoY, botaoLargura, botaoAltura;
  boolean telaInicial, jogando;

  TelaInicial(String aluno, String instrucao) {
    this.aluno = aluno;
    this.instrucao = instrucao;
    this.botaoX = 437.5;
    this.botaoY = 300;
    this.botaoLargura = 150;
    this.botaoAltura = 80;
    this.telaInicial = true;
    this.jogando = false;
  }

  void desenhar() {
    background(0);
    textSize(32);
    fill(255);
    textAlign(CENTER, CENTER);
    text("Aluno: " + aluno, width / 2, 50);
    textSize(28);
    text("Instruções", width / 2, height - 220);
    textSize(18);
    text(instrucao, width / 2, height - 150);
    stroke(255);
    fill(0);
    rect(botaoX, botaoY, botaoLargura, botaoAltura);
    fill(255);
    textSize(20);
    text("Jogar", botaoX + botaoLargura / 2, botaoY + botaoAltura / 2);
  }

  void verificarClique() {
    if (mouseX > botaoX && mouseX < botaoX + botaoLargura && mouseY > botaoY && mouseY < botaoY + botaoAltura) {
      telaInicial = false;
      jogando = true;
      playerPos = new PVector(-100, 200);
      background(0);
    }
  }
}
