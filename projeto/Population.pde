    
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
        }
        generations = 0;
        
        // reset initial fitness to 0
        for (int i = 0; i < individuals.length; i++) {
        individuals[i].setFitness(0);
        }
    }


  // Create the next generation
  void evolve() {
    // Create a new a array to store the individuals that will be in the next generation
    Individual[] new_generation = new Individual[individuals.length];
    
    // Sort individuals by fitness
    sortIndividualsByFitness();
    
    // Copy the elite to the next generation
    for (int i = 0; i < elite_size; i++) {
      new_generation[i] = individuals[i].getCopy();
    }
    
    // Create (breed) new individuals with crossover
    for (int i = elite_size; i < new_generation.length; i++) {
      if (random(1) <= crossover_rate) {
        Individual parent1 = tournamentSelection();
        Individual parent2 = tournamentSelection();
        Individual child = parent1.onePointCrossover(parent2);
        //Individual child = parent1.uniformCrossover(parent2);
        new_generation[i] = child;
      } else {
        new_generation[i] = tournamentSelection().getCopy();
      }
    }

    // Mutate new individuals
    for (int i = elite_size; i < new_generation.length; i++) {
       new_generation[i].mutate();
    }
    
    // Replace the individuals in the population with the new generation individuals
    for (int i = 0; i < individuals.length; i++) {
      individuals[i] = new_generation[i];
    }
    
    // Reset the fitness of all individuals to 0, excluding elite
    for (int i = 0; i < individuals.length; i++) {
       individuals[i].setFitness(0);
    }
    
    // Increment the number of generations
    generations++;
  }

    // Select one individual using a tournament selection 
    Individual tournamentSelection() {
        // Select a random set of individuals from the population
        Individual[] tournament = new Individual[tournament_size];
        for (int i = 0; i < tournament.length; i++) {
        int random_index = int(random(0, individuals.length));
        tournament[i] = individuals[random_index];
        }
        // Get the fittest individual from the selected individuals
        Individual fittest = tournament[0];
        for (int i = 1; i < tournament.length; i++) {
        if (tournament[i].getFitness() > fittest.getFitness()) {
            fittest = tournament[i];
        }
        }
        return fittest;
    }
    
    // Sort individuals in the pop by fitness in descending order
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

    // Get the current number of generations
    int getGenerations() {
        return generations;
  }

}
