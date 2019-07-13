class leaderboard {

  int max_size;
  ArrayList<score> list;

  leaderboard(int s)
  {
    list = new ArrayList<score>();
    max_size = s;

    for(int i=0; i<max_size; i++)
      list.add(new score(0,0));
  }

  score get_score(int index)
  {
    return list.get(index);
  }

  int get_size()
  {
    return list.size();
  }

  void submit_score(score submission)
  {
    if(list.size() == 0) //fixed: when list is empty just add first score
      list.add(submission);

    for(int i=0; i<list.size() ; i++)
    {
      if(submission.get_fitness() > list.get(i).get_fitness()) // new holder
      {
        //drop down all positions starting at i
        for(int position=max_size-1; position>i; position--)
        {
            list.set(position, list.get(position-1)); //put 5th in 6th positions, etc.
        }

        //add submission to currect position in the list
        list.set(i, submission);

        //if this happens do not check the remaining positions
        break;
      }
    }
  }
}
