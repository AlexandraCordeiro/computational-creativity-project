class Candidate {
  int music_dur;
  int num_layers = 25;
  int[][] freqs = new int[num_layers][361];
  PVector[][] layers = new PVector[num_layers][];
  
  
  Candidate() {
    // freqs
    println(this.num_layers);
    for (int i = 0; i < this.num_layers; i++) {
      // println("+++");
      for (int j = 0; j <= 360; j++) {
        // println("***");
        this.freqs[i][j] = int(random(20, 20000));
        // println("ppp");
      }
      printArray(this.freqs[i]);
    }

    // 1 - 6 min
    this.music_dur = int(random(60000, 360000));
  };
  

  void renderCandidate() {
    int r = int(map(this.music_dur, 0, 360000, 0, w*0.2));
    float t = 0;
    for (int i = 0; i < this.num_layers; i++) {
      this.imperfectCircle(r, t, i);
      r += this.num_layers;
      t++;
    }

  }


  PVector[] imperfectCircle(float r, float t, int index) {
  
    push();
    translate(cx, cy);
    
    noFill();
    float speed = 0.03; 
    float bobbleRate = 1;
    float phase = t*speed;
    beginShape();
    
    PVector[] layerCoordinates = new PVector[361];
    int n = 0;
    for (float i = 0; i <= TWO_PI; i += PI/180) {
      
      float xoff = map(cos(i), -1, 1, 0, bobbleRate);
      float yoff = map(sin(i), -1, 1, 0, bobbleRate);
      float noise = noise(xoff + phase, yoff + phase);
      
      float new_r = map(noise, 0, 1, 80, r);
      float x = new_r  * cos(i); 
      float y = new_r  * sin(i);


      layerCoordinates[n] = new PVector(x, y);
      noStroke();
      // stroke(0);
      // strokeWeight(1);
      
      
      int freq = int(random(20, 20000));
      int raio = int(map(freq, 20, 20000, 0, int(random(1, 20))));    
      // rect(x, y, raio, raio);
      fill(0, 0, random(255), random(0, 255));
      circle(x, y, raio);
      // println(n);
      n++;
    }

    // printArray(layerCoordinates);
    
    t += 1;
    endShape();
    pop();

    return layerCoordinates;

}

/*   int k = 0;
  for (float j = 0; j <= TWO_PI;  j += PI/180) {
    // perlin noise 
    float xoff = map(cos(i), -1, 1, 0, bobbleRate);
    float yoff = map(sin(i), -1, 1, 0, bobbleRate);
    float noise = noise(xoff + phase, yoff + phase);
    
    float new_r = map(noise, 0, 1, 80, r);
    float x = new_r  * cos(i); 
    float y = new_r  * sin(i);
    layerCoordinates[k] = new PVector(x, y);
    noStroke();

    fill(random(255), 0, 0, random(0, 255));
    int freq = this.freqs[i][k];
    int raio = int(map(freq, 20, 20000, 0, int(random(1, 20))));    
    circle(x, y, raio);
    // rect(x, y, random(7), random(7));
    // vertex(x, y);
    k++;
  } */
  
  
  
  
  
  
  
  
  
}
