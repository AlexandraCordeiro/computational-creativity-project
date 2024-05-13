import processing.sound.*;

SoundFile nocturne;

int w = 559;
int h = 794;
int r = int(w*0.8);

float cx = w*0.5;
float cy = h*0.5;
float ang = 0;
float p;

FFT fft;
int bands = 512;
float[] sum = new float[bands];
float smoothingFactor = 0.2;
int scale = int(random(5, 10));

void setup() {
    size(559, 794);
    
    nocturne = new SoundFile(this, "op9_no1.wav");
    println("Duration of audio file (in seconds): " + nocturne.duration());
    println("Sample rate of audio file: " + nocturne.sampleRate());
    println("Number of channels in audio file: " + nocturne.channels());
    println("FFT object initialized with " + bands + " bands.");
    nocturne.play();
    fft = new FFT(this, bands);
    fft.input(nocturne);
    p = 2 * PI * r;
    
    
    
}

float log10 (float x) {
  return (log(x) / log(10));
}

void analyseFrequencies() {
    push();
    translate(cx, cy);
    // fill(153);
    // noStroke();
    // circle(0, 0, r);

    fft.analyze();
    // printArray(fft.spectrum);

    float maxSpectrumValue = 0;
    for (int i = 0; i < bands; i++) {
        if (fft.spectrum[i] > maxSpectrumValue) {
            maxSpectrumValue = fft.spectrum[i];
        }
    }

    float orderOfMagnitude = pow(10, -floor(log10(maxSpectrumValue)));
    println(orderOfMagnitude);

    for (int i = 0; i < bands; i++) {
        sum[i] += (fft.spectrum[i] - sum[i]) * smoothingFactor;
        // -sum[i]*h*scale
        // println(sum[i]);
        noFill();
        stroke(255, 0, 0, sum[i] * orderOfMagnitude);
        strokeWeight(sum[i] * orderOfMagnitude);
        circle(r * .5 * cos(ang), r * .5 * sin(ang), sum[i] * orderOfMagnitude * scale);
        ang += TWO_PI / bands;
    }
    pop();
}

void draw() {
    // background(255);
    analyseFrequencies();
}