class Individual {
    int music_dur;
    int num_layers = 20;
    int num_circles = 360;
    int[][] freqs = new int[num_layers][num_circles + 1];
    PVector[][] layers = new PVector[num_layers][];
    ReadMusicData data = new ReadMusicData();


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

    void renderIndividual(float cx, float cy) {
        int r = 255;
        int g = 0;
        int b = 0;

        for (int i = 0; i < this.num_layers; i++) {
            for (int j = 0; j <= this.num_circles; j++) {
                push();
                translate(cx, cy);
                noStroke();
                fill(0);
                // fill(r, j, b);
                // fill(random(255), random(255), random(255), random(255));
                // rect(this.layers[i][j].x, this.layers[i][j].y, this.layers[i][j].z, this.layers[i][j].z);
                circle(this.layers[i][j].x, this.layers[i][j].y, this.layers[i][j].z);
                pop();
            }
        }
    }

    void createIndividual(float cx, float cy) {
        // ensure randomness for each individual
        noiseSeed(millis());
        int r = int(map(this.music_dur, 0, 360000, 0, width*0.3));
        float t = 0;
        for (int i = 0; i < this.num_layers; i++) {
            this.layers[i] = this.imperfectCircle(cx, cy, r, t, i);
            r += 20;
            t++;
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

            int freq = int(random(20, 20000));
            int raio = int(map(freq, 20, 20000, 1, 7)); 
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
        int mutatedLayers = int(mutationRate * (num_layers)) - 1;
        noiseSeed(millis());
        int r = int(map(this.music_dur, 0, 360000, 0, width*0.3));
        float t = 0;
        for (int i = 0; i < mutatedLayers; i++) {
            this.layers[i] = this.imperfectCircle(cx, cy, r, t, i);
            r += 20;
            t++;
        }
    }

    Individual getCopy() {
        Individual copy = new Individual(this.layers, this.music_dur);
        return copy;
  }
}
