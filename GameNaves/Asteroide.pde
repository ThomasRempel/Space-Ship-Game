  class Asteroide {
    private PVector pos;
    private float[] xOffsets;
    private float[] yOffsets;
    private int numVertices;
    private float radius;
    private float rotationSpeed; 
  
    Asteroide(float x, float y, float radius) {
      pos = new PVector(x, y);
      this.radius = radius;
      rotationSpeed = random(-0.02, 0.02); 
  

      numVertices = floor(random(5, 12)); 
      xOffsets = new float[numVertices];
      yOffsets = new float[numVertices];
      for (int i = 0; i < numVertices; i++) {
        float angle = map(i, 0, numVertices, 0, TWO_PI);
        float xOffset = cos(angle) * random(radius * 0.5, radius * 1.5);
        float yOffset = sin(angle) * random(radius * 0.5, radius * 1.5);
        xOffsets[i] = xOffset;
        yOffsets[i] = yOffset;
      }
    }
  
    void update(float et) {
    }
  
    void render() {
      fill(150);
      noStroke();
      pushMatrix();
      translate(pos.x, pos.y); 
      rotate(frameCount * rotationSpeed); 
      beginShape();
      for (int i = 0; i < numVertices; i++) {
        float x = xOffsets[i];
        float y = yOffsets[i];
        vertex(x, y);
      }
      endShape(CLOSE);
      popMatrix(); 
    }
  }
