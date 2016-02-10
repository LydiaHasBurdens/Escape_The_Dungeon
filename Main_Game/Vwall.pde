class Vwall
{
  int x;
  int y;
  int w;
  int h;
  
  Vwall( String line )
  {
    //use space as delim, store data in temp array
    String delims = "[ ]+";
    String[] temps = line.split(delims);
    
    //add values to the Vwall structure
    x = Integer.parseInt(temps[0]);
    y = Integer.parseInt(temps[1]);
    w = Integer.parseInt(temps[2]);
    h = Integer.parseInt(temps[3]);
  }


}
