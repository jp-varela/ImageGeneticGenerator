class organism {

  float[] genotype;
  float fitness = 0;
  float mutation;
  int num_shapes;
  int num_caracteristics;

  organism(int shapes, int chars)
  {
    num_shapes = shapes;
    num_caracteristics = chars;
    genotype = new float[shapes*chars];

    for (int i=0; i<genotype.length; i++)
        genotype[i]=random(0, 1);
  }

  float get_mutation()
  {
    return mutation;
  }

  void set_mutation(float t)
  {
    mutation = t;
  }

  float get_fitness()
  {
    return fitness;
  }

  void set_fitness(float score)
  {
    fitness = score;
  }

  float get_caracteristic(int shape, int index)
  {
    return genotype[shape*num_caracteristics+index];
  }

  float get_weight(int index)
  {
    return genotype[index];
  }

  void set_weight(int index, float value)
  {
    genotype[index] = value;
  }

}
