class score {

  //float[] genotype;
  float fitness;
  int gen;

  score(float f, int g)
  {
    fitness = f;
    gen = g;
  }

  float get_fitness()
  {
    return fitness;
  }

  int get_generation()
  {
    return gen;
  }
}
