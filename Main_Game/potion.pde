class Potion
{
  
  float potionX;
  float potionY;


Potion(String line)
{
  //use space as delim, store data in temp array
    String delims = "[ ]+";
    String[] temps = line.split(delims);
    
  
  potionX = Integer.parseInt(temps[0]) - 1150;
  potionY = Integer.parseInt(temps[1]) + 250;
  
}


}

