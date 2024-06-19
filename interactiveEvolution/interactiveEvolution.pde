import controlP5.*;
import processing.core.*;

PFont montserrat;
ControlP5 cp5;
ColorPicker cp;

int pop_size = 8;
int elite_size = 1;
int tournament_size = 3;
float crossover_rate = 0.7;
float mutation_rate = 0.2;
int resolution = 1080;

Population population;
PVector[][] cells;
Individual selected_indiv = null;
int circleColor = color(255, 0, 0);

void settings() {
  size(int(displayWidth * 0.9), int(displayHeight * 0.8), P2D);
  smooth(8);
}

void setup() {
  //frameRate(60);
  // Load Montserrat font from file (adjust the path to match your setup)
  montserrat = createFont("./font/Montserrat-Regular.ttf", 12);
  
  // Set text font to Montserrat
  textFont(montserrat);
  
  population = new Population();
  for (int i = 0; i < population.getSize(); i++) {
        population.getIndiv(i).createIndividual(0,0);
    }
  cells = calculateGrid(pop_size, 0, 0, width, height, 50, 10, 30, true);
  textSize(constrain(cells[0][0].z * 0.15, 11, 14));
  textAlign(CENTER, TOP);

  // Initialize controlP5
  cp5 = new ControlP5(this);

  // Create the button
  cp5.addButton("newGeneration")
     .setLabel("Next")
     .setPosition(width - 200,  height - 50)
     .setSize(120, 30);
     
   /*
  // Create color picker
  cp = cp5.addColorPicker("colorPicker")
          .setPosition(50, height - 60)
          .setSize(50, 50)
          .setColorValue(circleColor)
          .setColorBackground(color(100))
          .setColorForeground(color(200));
*/   
}

  
 
void draw() {
  background(235);
  selected_indiv = null; // Temporarily clear selected individual
  fill(0);
  text("Choose your favorite images and press next", width/2, 10);
  int row = 0, col = 0;
  for (int i = 0; i < population.getSize(); i++) {
    float x = cells[row][col].x;
    float y = cells[row][col].y;
    float d = cells[row][col].z;
    // Check if current individual is hovered by the cursor
    noFill();
    if (mouseX > x && mouseX < x + d && mouseY > y && mouseY < y + d) {
      selected_indiv = population.getIndiv(i);
      stroke(0);
      strokeWeight(3);
      rect(x, y, d, d);
    }
    if (population.getIndiv(i).getFitness() > 0) {
      stroke(50, 200, 50);
      strokeWeight(6);
      rect(x, y, d, d);
    }
    // Draw phenotype of current individual
    image(population.getIndiv(i).getPhenotype(), x, y, d, d);
    // Draw fitness of current individual
    fill(0);
   // text(nf(population.getIndiv(i).getFitness(), 0, 2), x + d / 2, y + d + 5);
    text(population.getIndiv(i).getFitnessText() +" (" + nf(population.getIndiv(i).getFitness(), 0, 0) + ")", x + d / 2, y + d + 5);
    
    // Go to next grid cell
    col += 1;
    if (col >= cells[row].length) {
      row += 1;
      col = 0;
    }
  }
  
  fill(0);
  //textAlign(CENTER, BOTTOM);
  text("Generation: " + population.getGenerations(), width / 2, height - 50);
  
}

void keyReleased() {
  if (key == CODED) {
    if (selected_indiv != null) {
      // Change fitness of the selected (hovered) individual
      float fit = selected_indiv.getFitness();
      if (keyCode == UP) {
        fit = min(fit + 0.1, 1);
      } else if (keyCode == DOWN) {
        fit = max(fit - 0.1, 0);
      } else if (keyCode == RIGHT) {
        fit = 1;
      } else if (keyCode == LEFT) {
        fit = 0;
      }
      selected_indiv.setFitness(fit);
    }
  } else if (key == ' ') {
    // Evolve (generate new population)
    population.evolve();
  } else if (key == 'i') {
    // Initialise new population
    population.init();
  } else if (key == 'e') {
    // Export selected individual
    if (selected_indiv != null) {
     // selected_indiv.export();
    }
  }
}

void mouseReleased() {
  // Set fitness of clicked individual to 1
  if (selected_indiv != null) {
    if (selected_indiv.getFitness() < 1) {
      selected_indiv.setFitness(1);
    } else {
      selected_indiv.setFitness(0);
    }
  }
}

// Button callback function
void newGeneration() {
  population.evolve();
}

/*
void controlEvent(ControlEvent event) {
  if (event.isFrom(cp)) {
    circleColor = cp.getColorValue();
    
  }
}
*/

// Calculate grid of square cells
PVector[][] calculateGrid(int cells, float x, float y, float w, float h, float margin_min, float gutter_h, float gutter_v, boolean align_top) {
  int cols = 0, rows = 0;
  float cell_size = 0;
  while (cols * rows < cells) {
    cols += 1;
    cell_size = ((w - margin_min * 2) - (cols - 1) * gutter_h) / cols;
    rows = floor((h - margin_min * 2) / (cell_size + gutter_v));
  }
  if (cols * (rows - 1) >= cells) {
    rows -= 1;
  }
  float margin_hor_adjusted = ((w - cols * cell_size) - (cols - 1) * gutter_h) / 2;
  if (rows == 1 && cols > cells) {
    margin_hor_adjusted = ((w - cells * cell_size) - (cells - 1) * gutter_h) / 2;
  }
  float margin_ver_adjusted = ((h - rows * cell_size) - (rows - 1) * gutter_v) / 2;
  if (align_top) {
    margin_ver_adjusted = min(margin_hor_adjusted, margin_ver_adjusted);
  }
  PVector[][] positions = new PVector[rows][cols];
  for (int row = 0; row < rows; row++) {
    float row_y = y + margin_ver_adjusted + row * (cell_size + gutter_v);
    for (int col = 0; col < cols; col++) {
      float col_x = x + margin_hor_adjusted + col * (cell_size + gutter_h);
      positions[row][col] = new PVector(col_x, row_y, cell_size);
    }
  }
  return positions;
}
