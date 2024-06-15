class Individual {
    int music_dur;
    int num_layers = 20;
    int[][] freqs = new int[num_layers][361];
    PVector[][] layers = new PVector[num_layers][];


    Individual() {
        // freqs
        for (int i = 0; i < this.num_layers; i++) {
            for (int j = 0; j <= 360; j++) {
                this.freqs[i][j] = int(random(20, 20000));
            }
        }

        // init PVector
        for (int i = 0; i < this.num_layers; i++) {
            this.layers[i] = new PVector[361];
            for (int j = 0; j <= 360; j++) {
                this.layers[i][j] = new PVector(); // Initialize each PVector
            }
        }

        // 1 - 6 min
        this.music_dur = int(random(60000, 360000));
        };

        void renderIndividual(float cx, float cy) {
            for (int i = 0; i < this.num_layers; i++) {
                for (int j = 0; j <= 360; j++) {
                    push();
                    translate(cx, cy);
                    noStroke();
                    fill(0, 0, random(255), random(255));
                    // rect(this.layers[i][j].x, this.layers[i][j].y, this.layers[i][j].z, this.layers[i][j].z);
                    circle(this.layers[i][j].x, this.layers[i][j].y, this.layers[i][j].z);
                    pop();
                }
            }
    }

    void createIndividual(float cx, float cy) {
        noiseSeed(millis());
        int r = int(map(this.music_dur, 0, 360000, 0, width*0.05));
        float t = 0;
        for (int i = 0; i < this.num_layers; i++) {
            this.layers[i] = this.imperfectCircle(cx, cy, r, t, i);
            r += 20;
            t++;
            // printArray(this.layers[i]);
        }
    }


    PVector[] imperfectCircle(float xi, float yi, float r, float t, int index) {

        float speed = 0.03; 
        float bobbleRate = 1;
        float phase = t*speed;
        PVector[] layerCoordinates = new PVector[361];
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
            int raio = int(map(freq, 20, 20000, 0, 8));    
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
            for (int j = 0; j <= 360; j++) {
            if (i < crossover_point) {
                
                child.layers[i][j] = new PVector(this.layers[i][j].x, this.layers[i][j].y, this.layers[i][j].z);
            } else {
                child.layers[i][j] = new PVector(partner.layers[i][j].x, partner.layers[i][j].y, partner.layers[i][j].z);
            }
            }

        }
        return child;
    }
}
