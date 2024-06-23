import processing.pdf.*;


class Individual {
    int song;
    float fitness = 0;
    int num_layers = 20;
    int num_circles = 360;
    int[][] freqs = new int[num_layers][num_circles + 1];
    PVector[][] layers = new PVector[num_layers][];
    ReadMusicData data = new ReadMusicData();
    int resolution = 1080;
    int music_dur = this.data.durationList.get(song);
    int layer_offset = this.data.bpmList.get(song);
   
    Individual() {
        // init PVector
       
        for (int i = 0; i < this.num_layers; i++) {
            this.layers[i] = new PVector[this.num_circles + 1];
            for (int j = 0; j <= this.num_circles; j++) {
                this.layers[i][j] = new PVector(); // Initialize each PVector
            }
        }
    };
    
     Individual(int song) {
        // init PVector
        this.song = song;
        for (int i = 0; i < this.num_layers; i++) {
            this.layers[i] = new PVector[this.num_circles + 1];
            for (int j = 0; j <= this.num_circles; j++) {
                this.layers[i][j] = new PVector(); // Initialize each PVector
            }
        }
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
        // Adjust the radius increment based on BPM
        int initialRadius = int(map(this.music_dur, 0, 360000, 0, 40));
        float t = 0;
        for (int i = 0; i < num_layers; i++) {
            layers[i] = imperfectCircle(cx, cy, initialRadius, t, i);
            initialRadius += int(map(this.layer_offset, 60, 180, 25, 40));        
            t++;
        }
    }
    

    // Render individual shapes
    void renderIndividual(PGraphics canvas, float cx, float cy) {

    for (int i = 0; i < num_layers; i++) {
        for (int j = 0; j <= num_circles; j++) {
        canvas.pushMatrix();
        canvas.translate(0, 0);
        canvas.noStroke();
        canvas.fill(0);
        float spectralBandwith = this.data.spectralBandwidthList.get(this.song)[i][j]; 
        int ratioColor = int(map(spectralBandwith, this.data.spectralMin.get(this.song), this.data.spectralMax.get(this.song), 0, 255));     
        canvas.fill(ratioColor, ratioColor, ratioColor);
        canvas.circle(layers[i][j].x, layers[i][j].y, layers[i][j].z);
        canvas.popMatrix();
        }
     }
    }

    PVector[] imperfectCircle(float xi, float yi, float r, float t, int layer) {
        
        float speed = 0.03; 
        float phase = t*speed;
        PVector[] layerCoordinates = new PVector[this.num_circles + 1];
        int n = 0;
       
        push();
        translate(xi, yi);
        for (float i = 0; i <= TWO_PI; i += PI/180) {
            float mfcc = this.data.mfccList.get(this.song)[layer][n];
            int mfcc_normalized = int(map(mfcc,this.data.mfccMin.get(this.song), this.data.mfccMax.get(this.song), 0.5,2)); 
            float bobbleRate = mfcc_normalized;

            float xoff = map(cos(i), -1, 1, 0, bobbleRate);
            float yoff = map(sin(i), -1, 1, 0, bobbleRate);
            float noise = noise(xoff + phase, yoff + phase);
            float new_r = map(noise, 0, 1, 80, r);
            
            float amplitude = this.data.amplitudeList.get(this.song)[layer][n];
            float x = new_r  * cos(i /* * mfcc_normalized */); 
            float y = new_r  * sin(i /* * mfcc_normalized */);           
            int raio = int(map(amplitude, 0, 1, 1, 50)); 
            layerCoordinates[n] = new PVector(x, y, raio);
            n++;               
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
        int initialRadius = int(map(this.music_dur, 0, 360000, 0, width * 0.3));
        float t = 0;
        for (int i = 0; i < mutatedLayers; i++) {
            this.layers[i] = this.imperfectCircle(0, 0, initialRadius, t, i);
            initialRadius += int(map(this.layer_offset, 60, 180, 25, 40));  
            t++;
        }
    }

    Individual getCopy() {
        Individual copy = new Individual(this.layers, this.music_dur);
        copy.fitness = fitness;
        copy.data = data;    
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
    
    // Set the song value
    void setSong(int songID) {
        this.song = songID;
    }
     
  // Get the image
  PImage getPhenotype(int resolution) {
    PGraphics canvas = createGraphics(resolution,resolution);
    canvas.beginDraw();
    canvas.background(255);
    canvas.noFill();
    canvas.stroke(0);
    canvas.strokeWeight(canvas.height * 0.002);
    render(canvas, canvas.width / 2, canvas.height / 2, canvas.width, canvas.height);
    canvas.endDraw();
    return canvas;
  }
  
   // Draw the individual on a given canvas
   void render(PGraphics canvas, float cx, float cy, float w, float h) {
    canvas.pushMatrix();
    canvas.translate(cx, cy);
    canvas.beginShape();
    renderIndividual(canvas,cx,cy);
    canvas.popMatrix();
  }

  void export(int gen, int song) {
    String output_filename = "gen" + gen + "_" + song;
    String output_path = sketchPath("outputs/" + output_filename);
    println("Exporting individual to: " + output_path);
    getPhenotype(1080).save(output_path + ".png");
    PGraphics pdf = createGraphics(1080, 1080, PDF, output_path + ".pdf");
    pdf.beginDraw();
    pdf.noFill();
    pdf.strokeWeight(pdf.height * 0.001);
    pdf.stroke(0);
    render(pdf, pdf.width / 2, pdf.height / 2, pdf.width, pdf.height);
    pdf.dispose();
    pdf.endDraw();
  }

  /* float findMax(float[][] list, int layer) {
        if (layer < 0 || layer >= list.size()) {
            throw new IllegalArgumentException("Invalid layer index");
        }
        
        float[][] array = list.get(layer);
        float max = Float.NEGATIVE_INFINITY;
        
        for (float[] row : array) {
            for (float value : row) {
                if (value > max) {
                    max = value;
                }
            }
        }
        
        return max;
    }
    
    float findMin(float[][] list, int layer) {
        if (layer < 0 || layer >= list.size()) {
            throw new IllegalArgumentException("Invalid layer index");
        }
        
        float[][] array = list.get(layer);
        float min = Float.POSITIVE_INFINITY;
        
        for (float[] row : array) {
            for (float value : row) {
                if (value < min) {
                    min = value;
                }
            }
        }
        
        return min;
    } */
}
