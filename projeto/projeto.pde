float ang = 0;
int n = 100;
float[] freqs = new float[n];


int h = 800;
int w = 800;


float cx = w*0.5;
float cy = h*0.5;


void setup() {
  size(800, 800);  // A5
  initValues(freqs, 20, 15000);
  Candidate c = new Candidate();
  c.renderCandidate();
  
}


float log10 (float x) {
  return (log(x) / log(10));
}

void circleOfCircles(float r, float scale, int n, float values[]) {
  push();
  translate(cx, cy);
  
  for (int i = 0; i < n; i++) {
        // noFill();
        noStroke();
        fill(random(255), random(255),0);
        // RGB + alpha
        float orderOfMagnitude = floor(log10(values[i]));
        // println(orderOfMagnitude);
        float new_r = orderOfMagnitude * (values[i] / pow(10, orderOfMagnitude) * scale);
        // stroke(0, 0, 0/*, values[i] * orderOfMagnitude*/);
        // strokeWeight(new_r / 20);
        circle(r * .5 * cos(ang), r * .5 * sin(ang), new_r);
        ang += TWO_PI / n;
    }
    pop();
}

void initValues(float[] values, int minRange, int maxRange) {
  for (int i = 0; i < values.length; i++) {
    values[i] = random(minRange, maxRange);
  }
}
