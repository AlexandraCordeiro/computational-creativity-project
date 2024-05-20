float ang = 0;
int n = 100;
float[] freqs = new float[n];

int w = 800;
int h = 800;


float cx = w*0.5;
float cy = h*0.5;

int scale = 2;
float t = 0;

int music_duration = int(random(6000, 360000));
int r = int(map(music_duration, 0, 360000, 0, w*0.2));

float radius = r;
int k = 0;
void setup() {
  size(800, 800);  // A5
  initValues(freqs, 20, 15000);
}

void draw() {
  // background(255);
  imperfectCircle(radius, n);
  radius += 25;
  k++;
  if (k == 25) noLoop();
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
        println(orderOfMagnitude);
        float new_r = orderOfMagnitude * (values[i] / pow(10, orderOfMagnitude) * scale);
        // stroke(0, 0, 0/*, values[i] * orderOfMagnitude*/);
        // strokeWeight(new_r / 20);
        circle(r * .5 * cos(ang), r * .5 * sin(ang), new_r);
        ang += TWO_PI / n;
    }
    pop();
}

void imperfectCircle(float r, float n) {
  
  push();
  translate(cx, cy);
  
  noFill();
  float speed = 0.03; 
  float bobbleRate = 1;
  float phase = t*speed;
  beginShape();
  
  for (float i = 0; i <= TWO_PI; i += PI/180) {
    
    float xoff = map(cos(i), -1, 1, 0, bobbleRate);
    float yoff = map(sin(i), -1, 1, 0, bobbleRate);
    float noise = noise(xoff + phase, yoff + phase);
    
    float new_r = map(noise, 0, 1, 80, r);
    float x = new_r  * cos(i); 
    float y = new_r  * sin(i);
    
    noStroke();
    // stroke(0);
    // strokeWeight(1);
    
    
    int freq = int(random(20, 20000));
    int raio = int(map(freq, 20, 20000, 0, int(random(1, 20))));    
    // rect(x, y, raio, raio);
    fill(0, 0, random(255), random(0, 255));
    circle(x, y, raio);
  }
  
  t +=1;
  endShape();
  pop();

}

void initValues(float[] values, int minRange, int maxRange) {
  for (int i = 0; i < values.length; i++) {
    values[i] = random(minRange, maxRange);
  }
}
