PGraphics draw_circle(organism org) //1 250 shapes with max/10
{
  PGraphics figure = createGraphics(max_width, max_height);
  figure.beginDraw();
  figure.background(0);
  figure.noStroke();

  for(int s=0; s<num_shapes; s++)
  {
      int x = (int) (org.get_caracteristic(s,0)*max_width);
      int y = (int) (org.get_caracteristic(s,1)*max_height);
      //println(r_ratio);
      int r = (int) (org.get_caracteristic(s,2)*max_width/10);
      int c1 = (int) (org.get_caracteristic(s,3)*255);
      int c2 = (int) (org.get_caracteristic(s,4)*255);
      int c3 = (int) (org.get_caracteristic(s,5)*255);
      //figure.translate(x, y);
      //rotate(population.get(g).get_angle()-PI/2);
      //int c = 0;
      figure.fill(c1,c2,c3, 255);
      figure.ellipse(x,y,r,r);
  }

  figure.endDraw();
  return figure;
}

PGraphics draw_line(organism org)
{
  PGraphics figure = createGraphics(max_width, max_height);
  figure.beginDraw();
  figure.background(255);
  figure.noStroke();

  for(int s=0; s<num_shapes; s++)
  {
    int x1 = (int) (org.get_caracteristic(s,0)*max_width);
    int y1 = (int) (org.get_caracteristic(s,1)*max_height);
    int x2 = (int) (org.get_caracteristic(s,2)*max_width);
    int y2 = (int) (org.get_caracteristic(s,3)*max_height);
    int r = (int) (org.get_caracteristic(s,4)*255);
    int g = (int) (org.get_caracteristic(s,5)*255);
    int b = (int) (org.get_caracteristic(s,6)*255);
    //int c=0;
    figure.stroke(r,g,b);
    figure.line(x1,y1,x2,y2);
  }

  figure.endDraw();
  return figure;
}

PGraphics draw_triangle(organism org)
{
  PGraphics figure = createGraphics(max_width, max_height);
  figure.beginDraw();
  figure.background(255);
  figure.noStroke();

  int maxDist = max_width/3;

  for(int s=0; s<num_shapes; s++)
  {
    int x1 = (int) (org.get_caracteristic(s,0)*max_width);
    int y1 = (int) (org.get_caracteristic(s,1)*max_height);

    float angle1 = (float) (org.get_caracteristic(s,2)*Math.PI);
    float angle2 = (float) (org.get_caracteristic(s,3)*Math.PI);

    float dist1 = org.get_caracteristic(s,4)*maxDist;
    float dist2 = org.get_caracteristic(s,5)*maxDist;

    int x2 = (int) (x1+dist1*Math.cos(angle1));
    int y2 = (int) (y1+dist1*Math.sin(angle1));
    int x3 = (int) (x1+dist2*Math.cos(angle2));
    int y3 = (int) (y1+dist2*Math.sin(angle2));

    int r = (int) (org.get_caracteristic(s,6)*255);
    int g = (int) (org.get_caracteristic(s,7)*255);
    int b = (int) (org.get_caracteristic(s,8)*255);
    //int c=0;
    figure.fill(r,g,b,255);
    figure.triangle(x1,y1,x2,y2,x3,y3);
  }

  figure.endDraw();
  return figure;
}

PGraphics draw_curve(organism org)
{ //play with no fill and no stroke
  PGraphics figure = createGraphics(max_width, max_height);
  figure.beginDraw();
  figure.background(255);
  //figure.noStroke();
  figure.noFill();

  for(int s=0; s<num_shapes; s++)
  {
    int x1 = (int) (org.get_caracteristic(s,0)*max_width);
    int y1 = (int) (org.get_caracteristic(s,1)*max_height);
    int x2 = (int) (org.get_caracteristic(s,2)*max_width);
    int y2 = (int) (org.get_caracteristic(s,3)*max_height);
    int x3 = (int) (org.get_caracteristic(s,4)*max_width);
    int y3 = (int) (org.get_caracteristic(s,5)*max_height);
    int x4 = (int) (org.get_caracteristic(s,6)*max_width);
    int y4 = (int) (org.get_caracteristic(s,7)*max_height);
    int r = (int) (org.get_caracteristic(s,8)*255);
    int g = (int) (org.get_caracteristic(s,9)*255);
    int b = (int) (org.get_caracteristic(s,10)*255);
    //int c=0;
    //figure.fill(r,g,b,255);
    figure.stroke(r,g,b,255);
    figure.strokeWeight(2);
    figure.curve(x1, y1, x2, y2, x3, y3, x4, y4);
  }

  figure.endDraw();
  return figure;
}
