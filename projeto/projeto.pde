float[][] coordinates = new float[3][2];
float[][] offspringCoordinates = new float[2][2];

int popSize = 2;
float mutationRate = 0.05;

float cx;
float cy;
int w, h;


Population population;
Individual[] offspring;
Individual[] mutated;

void settings() {
    size(int(displayWidth * 0.9), int(displayHeight * 0.8));
}

void setup() {
    h = 100;
    w = 100;
    cx = width * 0.5;
    cy = height * 0.5;

    // parents coordinates
    coordinates[0][0] = width * 0.2;
    coordinates[0][1] = height * 0.3;
    coordinates[1][0] = width * 0.5;
    coordinates[1][1] = height * 0.3;
    coordinates[2][0] = width * 0.8;
    coordinates[2][1] = height * 0.3;


    // offspring coordinates
    offspringCoordinates[0][0] = width * 0.35;
    offspringCoordinates[0][1] = height * 0.7;
    offspringCoordinates[1][0] = width * 0.65;
    offspringCoordinates[1][1] = height * 0.7;

    population = new Population();

    for (int i = 0; i < population.getSize(); i++) {
        population.getIndiv(i).createIndividual(coordinates[i][0], coordinates[i][1]);
        population.getIndiv(i).renderIndividual(coordinates[i][0], coordinates[i][1]);
    }

    /* offspring = new Individual[population.getSize() - 1];
    recombinePairsOfIndividuals();

    for (int i = 0; i < offspring.length; i++) {
        offspring[i].renderIndividual(offspringCoordinates[i][0], offspringCoordinates[i][1]);
    } */

    mutated = new Individual[population.getSize() - 1];
    mutateIndividuals();

    for (int i = 0; i < mutated.length; i++) {
        mutated[i].renderIndividual(offspringCoordinates[i][0], offspringCoordinates[i][1]);
    }



}


void recombinePairsOfIndividuals() {
    for (int i = 0; i < offspring.length; i++) {
        Individual parent1 = population.getIndiv(i);
        Individual parent2 = population.getIndiv(i + 1);
        offspring[i] = parent1.onePointCrossover(parent2);
    }
}


void mutateIndividuals() {
  for (int i = 0; i < mutated.length; i++) {
    mutated[i] = population.getIndiv(i).getCopy();
    mutated[i].mutate();
  }
}