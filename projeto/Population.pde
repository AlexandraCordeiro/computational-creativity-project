    class Population {
    Individual[] individuals;

    Population() {
        individuals = new Individual[popSize];
        init();
    }

    void init() {
        for (int i = 0; i < individuals.length; i++) {
            individuals[i] = new Individual();
        }
    }

    int getSize() {
        return individuals.length;
    }

    Individual getIndiv(int index) {
        return individuals[index];
    }

}