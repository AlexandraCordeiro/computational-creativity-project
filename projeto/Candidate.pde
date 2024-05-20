class Candidate {
  int music_dur;
  int freqs[][];
  int n;
  
  Candidate() {
    // freqs
    for (int i = 0; i < 360; i++) {
      for (int j = 0; j < n; j++) {
        this.freqs[i][j] = int(random(20, 20000));
      }
    }
    // layers
    this.n = int(random(10, 25));
    // 1 - 6 min
    this.music_dur = int(random(60000, 360000));
  };
  
  void renderCandidate() {
  
  push();
  translate(cx, cy);
  int t = 0;
  float speed = 0.03; 
  float bobbleRate = 1;
  float phase = t*speed;
  beginShape();
  
  for (int i = 0; i < this.n; i++) {
    int k = 0;
    for (float j = 0; j <= TWO_PI;  j += PI/180) {
      // perlin noise 
      float xoff = map(cos(i), -1, 1, 0, bobbleRate);
      float yoff = map(sin(i), -1, 1, 0, bobbleRate);
      float noise = noise(xoff + phase, yoff + phase);
      
      float new_r = map(noise, 0, 1, 80, r);
      float x = new_r  * cos(i); 
      float y = new_r  * sin(i);
      
      noStroke();
      // stroke(0);
      // strokeWeight(1);
      fill(random(255), 0, 0, random(0, 255));
      int freq = this.freqs[i][k];
      int raio = int(map(freq, 20, 20000, 0, int(random(1, 20))));    
      // circle(x, y, raio);
      // rect(x, y, random(7), random(7));
      // vertex(x, y);
      k++;
    }
    t++;
  }
  
  
  

}
  
  
  
  
  
  
  
  
  
}
