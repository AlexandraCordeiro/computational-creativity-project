class Individual {
    int music_dur;
    float fitness = 0; // Fitness value
    int num_layers = 20;
    int num_circles = 360;
    int[][] freqs = new int[num_layers][num_circles + 1];
    PVector[][] layers = new PVector[num_layers][];
    ReadMusicData data = new ReadMusicData();
    int resolution = 1080;


    Individual() {
        // printArray(this.data.frequencyList.get(0)[0]);
        // freqs
        for (int i = 0; i < this.num_layers; i++) {
            for (int j = 0; j <= this.num_circles; j++) {
                this.freqs[i][j] = int(random(20, 20000));
            }
        }

        // init PVector
        for (int i = 0; i < this.num_layers; i++) {
            this.layers[i] = new PVector[this.num_circles + 1];
            for (int j = 0; j <= this.num_circles; j++) {
                this.layers[i][j] = new PVector(); // Initialize each PVector
            }
        }

        // 1 - 6 min
        this.music_dur = int(random(60000, 360000));
    };
    
    Individual(PVector[][] layers, int music_dur) {
        this.music_dur = music_dur;

        for (int i = 0; i < this.num_layers; i++) {
            this.layers[i] = new PVector[this.num_circles + 1];
            for (int j = 0; j <= this.num_circles; j++) {
                this.layers[i][j] = new PVector(layers[i][j].x, layers[i][j].y, layers[i][j].z); 
            }
        }
    }

    

    // Create individual shapes
    void createIndividual(float cx, float cy) {
    noiseSeed(millis());
    int r = int(map(music_dur, 0, 360000, 0, this.resolution * 0.3));
    float t = 0;
    for (int i = 0; i < num_layers; i++) {
        layers[i] = imperfectCircle(cx, cy, r, t, i);
        r += 30;
        t++;
    }
    }

    // Render individual shapes
    void renderIndividual(PGraphics canvas, float cx, float cy) {
    int r = 255;
    int g = 0;
    int b = 0;

    for (int i = 0; i < num_layers; i++) {
        for (int j = 0; j <= num_circles; j++) {
        canvas.pushMatrix();
        canvas.translate(0, 0);
        canvas.noStroke();
        canvas.fill(0);
        // canvas.fill(r, j, b);
        // canvas.fill(0, 0, random(255), random(255));
        // canvas.rect(layers[i][j].x, layers[i][j].y, layers[i][j].z, layers[i][j].z);
    
        canvas.circle(layers[i][j].x, layers[i][j].y, layers[i][j].z);
        canvas.popMatrix();
        }
    }
    }

    PVector[] imperfectCircle(float xi, float yi, float r, float t, int index) {

        float speed = 0.03; 
        float bobbleRate = 1;
        float phase = t*speed;
        PVector[] layerCoordinates = new PVector[this.num_circles + 1];
        int n = 0;

        push();
        translate(xi, yi);
        for (float i = 0; i <= TWO_PI; i += PI/180) {
            
            float xoff = map(cos(i), -1, 1, 0, bobbleRate);
            float yoff = map(sin(i), -1, 1, 0, bobbleRate);
            float noise = noise(xoff + phase, yoff + phase);
            
            float new_r = map(noise, 0, 1, 80, r);
            float x = new_r  * cos(i); 
            float y = new_r  * sin(i);
            
            float amplitude = this.data.amplitudeList.get(0)[n + index * 361];
            //int freq = int(random(20, 20000));
            //float freq = this.data.frequencyList.get(0)[n + index * 361];
            int raio = int(map(amplitude, 0, 1, 1, 50)); 
            //int raio = int(map(freq, 20, 20000, 1, 100)); 
            layerCoordinates[n] = new PVector(x, y, raio);
            n++;
            
            println(n);
        }
        t += 1;
        pop();

        return layerCoordinates;

    }

    Individual onePointCrossover(Individual partner) {
        Individual child = new Individual();
        int crossover_point = int(random(1, this.num_layers - 1));

        for (int i = 0; i < this.num_layers; i++) {
            for (int j = 0; j <= this.num_circles; j++) {
            if (i < crossover_point) {
                
                child.layers[i][j] = new PVector(this.layers[i][j].x, this.layers[i][j].y, this.layers[i][j].z);
            } else {
                child.layers[i][j] = new PVector(partner.layers[i][j].x, partner.layers[i][j].y, partner.layers[i][j].z);
            }
            }

        }
        return child;
    }

    void mutate() {
            int mutatedLayers = int(mutation_rate * (num_layers)) - 1;
            noiseSeed(millis());
            int r = int(map(this.music_dur, 0, 360000, 0, width*0.3));
            float t = 0;
            for (int i = 0; i < mutatedLayers; i++) {
                this.layers[i] = this.imperfectCircle(0, 0, r, t, i);
                r += 20;
                t++;
            }
        }

    Individual getCopy() {
        Individual copy = new Individual(this.layers, this.music_dur);
        return copy;
    }

    // Set the fitness value
    void setFitness(float fitness) {
        this.fitness = fitness;
    }
    
    // Get the fitness value
    float getFitness() {
        return fitness;
    }
    
    String getFitnessText(){
      if (this.fitness == 1){
        return "Like";
      } 
      else {
        return "Dislike";
      }
    }
    
   
  // Get the phenotype (image)
  PImage getPhenotype() {
    PGraphics canvas = createGraphics(this.resolution, this.resolution);
    canvas.beginDraw();
    canvas.background(255);
    canvas.noFill();
    canvas.stroke(0);
    canvas.strokeWeight(canvas.height * 0.002);
    // createIndividual(canvas, canvas.width / 2, canvas.height / 2);
    render(canvas, canvas.width / 2, canvas.height / 2, canvas.width, canvas.height);
   
    canvas.endDraw();
    return canvas;
  }
  
    // Draw the harmonograph line on a given canvas, at a given position and with a given size
    void render(PGraphics canvas, float cx, float cy, float w, float h) {
    canvas.pushMatrix();
    canvas.translate(cx, cy);
    canvas.beginShape();
   // createIndividual(cx,cy);
    renderIndividual(canvas,cx,cy);
    canvas.popMatrix();
  }


}
