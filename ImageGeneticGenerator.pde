//ImageGeneticGenerator by macarrony00 - João Varela
import org.gicentre.utils.stat.*;
import org.gicentre.utils.colour.*;

String description = "1000 curves";
//String[] img_name = {"mona", "thor", /*"eletrico",*/ "deadpool", "eiffel", "positano"};
//String[] img_name = {"jedi", "iron", "thanos"};
String[] img_name = {"deadpool"};
int img_index = 0;
int num_organisms=30;
int num_caracteristics=11;
int num_shapes=1000;
float mutation_rate=0.001;
PImage img;

int max_width = 1280/10; //128
int max_height = 720/4; //180

ArrayList<organism> population = new ArrayList<organism>();
//ArrayList<PGraphics> figures = new ArrayList<PGraphics>();
leaderboard best_score = new leaderboard(7);
PGraphics[] figures = new PGraphics[num_organisms];
organism all_time_best = new organism(num_shapes, num_caracteristics);

XYChart top1;
ColourTable gradient;
FloatList gen_array = new FloatList();
FloatList fit_array = new FloatList();

//State variables
int gen = 1;
float top_fit = 0;
int start_time = millis();

void setup() {
  println("Loading...");
  size(1280, 720);
  frameRate(1000);
  ellipseMode(RADIUS);

  img = loadImage(img_name[img_index]+".jpg");
  gradient = ColourTable.readFile(createInput("gradient_0_1020.ctb"));

  top1 = new XYChart(this);
  // Axis formatting and labels.
  top1.showXAxis(true);
  top1.showYAxis(true);
  // Symbol colours
  top1.setPointSize(2);
  top1.setLineWidth(2);
  top1.setMinX(1.0001);
  top1.setXAxisLabel("Generation");
  top1.setYFormat("##.##");
  top1.setXFormat("###");
  top1.setLineColour(#4D4C4B);
  top1.setPointColour(#4D4C4B);

  //First Generation Creation
  for (int x=0; x<num_organisms; x++)
  {
    population.add(new organism(num_shapes, num_caracteristics));
    figures[x] = createGraphics(max_width, max_height);
  }
  println("Complete!");
}


void draw() {
  //println("-----Generation: "+gen+"-----");

  //Draw MAP
  background(255);
  image(img,0,0);

  //println("Drawing things...");

  //DRAW ORGANISMS
  for (int f=0; f<num_organisms; f++) //For each organism
  {
    figures[f] = draw_curve(population.get(f));
    image(figures[f], (f%10)*max_width, ((f/10)+1)*max_height);
  }
  //println("Drawing is done!");

  //draw data
  fill(0);
  noStroke();
  textSize(18);
  text(description, 135, 20);
  text("Generation: "+gen, 135, 50);
  text("Acc: "+top_fit+"%", 135, 80);
  //text("Shapes: 150", 135, 80);

  //println("Calculating Fitness...");
  //calculate fitness
  for(int i=0; i<num_organisms; i++)
      population.get(i).set_fitness(calculateFitness(i));

  //println("Sorting...");
  //sort
  ArrayList<organism> old = population;
  population = sortList(old);
  top_fit = ((int) (population.get(0).get_fitness()*100))/100.00;
  //println("Best Score is: "+top_fit);

  if(population.get(0).get_fitness() > all_time_best.get_fitness())
    all_time_best = population.get(0);

  //get data for graphics
    //for history graph
  gen_array.append((float) gen);
  fit_array.append(top_fit);
  if(gen_array.size() > 500)
  {
    gen_array.remove(0);
    fit_array.remove(0);
  }
    //for top score
  score gen_top_score = new score(top_fit, gen);
  best_score.submit_score(gen_top_score);

  //for(int i=0; i<best_score.get_size(); i++)
    //println("#"+(i+1)+" score: "+best_score.get_score(i).get_fitness()+"   gen: "+best_score.get_score(i).get_generation());

  //draw graphics
  top1.setMinY(fit_array.min());
  top1.setMaxY(fit_array.max());
  top1.setMinX(gen_array.min());
  top1.setData(gen_array.array(), fit_array.array());
  textSize(16);
  fill(0);
  top1.draw(700, 0, 580, 180);

  draw_graphs("Best Score", best_score, 300, 0, 300, 0, 100);

  //println("Generating new organisms....");
  //create new generation
  ArrayList<organism> ancestor = population;
  population = childGenerator(ancestor);

if(gen==10000)
{
  println(img_name[img_index]+" 10k  --score:"+best_score.get_score(0).get_fitness()+"  --gen:"+best_score.get_score(0).get_generation()+"  --time:"+(millis()-start_time)/60000.00);
  PGraphics save = draw_curve(all_time_best);
  save.save("figures/8_"+img_name[img_index]/*+"_("+round(all_time_best.get_fitness()*100)/100.00)*/+".png");

  if(img_index < img_name.length-1)
  {
    img_index++;
    reset();
  }
  else
    exit();
}




  //reset things
  gen++;
  //println("Final Generation");
  saveFrame("frames/frame_######.png");
}

void reset()
{
  population = new ArrayList<organism>();
  //ArrayList<PGraphics> figures = new ArrayList<PGraphics>();
  best_score = new leaderboard(7);
  figures = new PGraphics[num_organisms];
  all_time_best = new organism(num_shapes, num_caracteristics);

  gen_array = new FloatList();
  fit_array = new FloatList();

  //State variables
  gen = 0;
  top_fit = 0;
  start_time = millis();

  img = loadImage(img_name[img_index]+".jpg");

  //First Generation Creation
  for (int x=0; x<num_organisms; x++)
  {
    population.add(new organism(num_shapes, num_caracteristics));
    figures[x] = createGraphics(max_width, max_height);
  }
}


ArrayList<organism> sortList(ArrayList<organism> old)
{
  ArrayList<organism> sorted = new ArrayList<organism>();
  for (int i = old.size()-1; i>=0; i--)
  {
    float max_score=-999;
    int index = -1;
    for (int j = old.size()-1; j>=0; j--)
    {
      if (old.get(j).get_fitness()>max_score)
      {
        max_score = old.get(j).get_fitness();
        index = j;
      }
    }
    sorted.add(old.get(index));
    old.remove(index);
  }
  return sorted;
}

float calculateFitness(int f)
{
  img.loadPixels();
  figures[f].loadPixels();
  loadPixels();
  int total = img.pixels.length;
  float fit = 0;
  for(int i=0; i<total; i++)
  {
    //int img_gray = (int) brightness(img.pixels[i]);
    //int fig_gray = (int) brightness(figures[f].pixels[i]);

    int img_red = (int) red(img.pixels[i]);
    int fig_red = (int) red(figures[f].pixels[i]);
    int img_green = (int) green(img.pixels[i]);
    int fig_green = (int) green(figures[f].pixels[i]);
    int img_blue = (int) blue(img.pixels[i]);
    int fig_blue = (int) blue(figures[f].pixels[i]);

    int diff = abs(img_red-fig_red)+abs(img_green-fig_green)+abs(img_blue-fig_blue);
    fit += diff;
  }
  updatePixels();
  float score = map(fit, 0, total*255*3, 100, 0);
  //println("Organism "+f+" score is :"+score);
  return score;
}

ArrayList<organism> childGenerator(ArrayList<organism> ancestor) //ancestor is last generation sorted
{
  ArrayList<organism> baby = new ArrayList<organism>(); //create new generation
  //baby.add(ancestor.get(0)); //save previoust best
  //baby.add(ancestor.get(1)); //save previoust best

  int totalPositionsRanks = 0; //example: 10 organisms -> 100+81+...+4+2+1
  float[] rankPoints = new float[num_organisms]; //example: 100/totalPositionsRanks | 81/totalPositionsRanks | ...
  for (int i=0; i<num_organisms; i++)
  {
    float aux = (float) Math.log(num_organisms/(i+0.01));
    //int aux = (num_organisms-i)*(num_organisms-i);
    rankPoints[i] = aux;
    totalPositionsRanks += aux;
  }

  //normalize
  for (int i=0; i<num_organisms; i++)
    rankPoints[i] = rankPoints[i]/totalPositionsRanks;
  //println(rankPoints); //debug_ change to be parent

  while (baby.size() < num_organisms)
  {
    baby.add(new organism(num_shapes, num_caracteristics)); //create new baby

    //choose parents
    float r1 = random(0, 1);
    int mom = 0;
    while (r1>=0)
    {
      r1 = r1-rankPoints[mom];
      mom++;
    }
    mom--;

    int dad;
    do{
      float r2 = random(0, 1);
      dad = 0;
      while (r2>=0)
      {
        r2 = r2-rankPoints[dad];
        dad++;
      }
      dad--;
    }while(mom == dad);

    //calculate genes
    for (int i=0; i<num_shapes*num_caracteristics; i++)
    {
      float r = random(0, 1);
      if(r>0.5)
        baby.get(baby.size()-1).set_weight(i, ancestor.get(mom).get_weight(i));
      else
        baby.get(baby.size()-1).set_weight(i, ancestor.get(dad).get_weight(i));
    }

    //calculate mutations: Not optimized, but works for now
    for (int i=0; i<num_shapes*num_caracteristics; i++)
    {
      float r = random(0, 1);
      if (r<mutation_rate)
        baby.get(baby.size()-1).set_weight(i, random(-1, 1));
    }
  }
  return baby;
}

void draw_graphs(String name, leaderboard board, int x1, int y1, int x_size, int min_score, int max_score)
{
  textSize(16);
  text(name, x1, y1+18-5);
  text("1st", x1, y1+40-5);
  text("2nd", x1, y1+60-5);
  text("3rd", x1, y1+80-5);

  int spacing = 35; //space between x1 and start of the bar in x axis
//works for <9, FIX LATER for more, add st nd rd ...
  for(int i=4; i<=board.get_size(); i++)
  {
    text(i+"th", x1, y1+20*(i+1)-5);
  }

  stroke(0);
  for(int i=0; i<board.get_size(); i++)
  {
    int color_map = (int) map(board.get_score(i).get_generation(), gen-500, gen, 0, 1020);
    fill(gradient.findColour(color_map));
    rect(x1+spacing, y1+20*(i+1), map(board.get_score(i).get_fitness(), min_score, max_score, 0, x_size-spacing), 18);
      //map(aux,0,100,518+(board.get_last_position(i)*20),518+(i*20)), ((board.get_score(i)-2000)/6), 18);
  }
  fill(0);
  for(int i=0; i<board.get_size(); i++)
  {
    text(board.get_score(i).get_fitness(), x1+spacing+map(board.get_score(i).get_fitness(), min_score, max_score, 0, x_size-spacing)+2, y1+20*(i+2)-5);
    text("("+board.get_score(i).get_generation()+")" , x1+spacing+map(board.get_score(i).get_fitness(), min_score, max_score, 0, x_size-spacing)-20-int_size(board.get_score(i).get_generation())*9, y1+20*(i+2)-5);
  }
}

int int_size(int num)
{
  if(num<10)
    return 1;
  if(num<100)
    return 2;
  if(num<1000)
    return 3;
  return 4;
}
