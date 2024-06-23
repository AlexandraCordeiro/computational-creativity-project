    
    import java.util.*; // Needed to sort arrays

    class Population {

    Individual[] individuals;
    int generations; // Integer to keep count of how many generations have been created
  

    Population() {
        individuals = new Individual[pop_size];
        init();
    }

    void init() {
        for (int i = 0; i < individuals.length; i++) {
            individuals[i] = new Individual();
            individuals[i].createIndividual(0,0);
        }     
        generations = 0;
        for (int i = 0; i < individuals.length; i++) {
        individuals[i].setFitness(0);
        }
    }
    
     void initWithSong(int song) {
        for (int i = 0; i < individuals.length; i++) {
            individuals[i] = new Individual(song);
            individuals[i].createIndividual(0,0);
        }     
        generations = 0;
        // reset initial fitness to 0
        for (int i = 0; i < individuals.length; i++) {
        individuals[i].setFitness(0);
        }
    }


  // generate next generation
  void evolve() {
    Individual[] new_generation = new Individual[individuals.length];
    sortIndividualsByFitness();
    
    // Copy elite to the next generation
    for (int i = 0; i < elite_size; i++) {
      new_generation[i] = individuals[i].getCopy();
    }
    
    // Breed new individuals with crossover
    for (int i = elite_size; i < new_generation.length; i++) {
      if (random(1) <= crossover_rate) {
        Individual parent1 = tournamentSelection();
        Individual parent2 = tournamentSelection();
        Individual child = parent1.onePointCrossover(parent2);
        new_generation[i] = child;
      } else {
        new_generation[i] = tournamentSelection().getCopy();
      }
    }

    // Mutate new individuals
    for (int i = elite_size; i < new_generation.length; i++) {
       new_generation[i].mutate();
    }
    
    // Replace individuals with new generation individuals
    for (int i = 0; i < individuals.length; i++) {
      individuals[i] = new_generation[i];
    }
    
    // Reset the fitness of all individuals to 0, excluding elite
    for (int i = 0; i < individuals.length; i++) {
       individuals[i].setFitness(0);
    }
    generations++;
  }

    // Select individual with tournament selection 
    Individual tournamentSelection() {
        Individual[] tournament = new Individual[tournament_size];
        for (int i = 0; i < tournament.length; i++) {
        
        int random_index = int(random(0, individuals.length));
        tournament[i] = individuals[random_index];
        }
        Individual fittest = tournament[0];
        for (int i = 1; i < tournament.length; i++) {
        if (tournament[i].getFitness() > fittest.getFitness()) {
            fittest = tournament[i];
        }
        }
        return fittest;
    }
    
    void sortIndividualsByFitness() {
        Arrays.sort(individuals, new Comparator<Individual>() {
        public int compare(Individual indiv1, Individual indiv2) {
            return Float.compare(indiv2.getFitness(), indiv1.getFitness());
        }
        });
    }

    int getSize() {
        return individuals.length;
    }

    Individual getIndiv(int index) {
        return individuals[index];
    }

    int getGenerations() {
        return generations;
  }

}
