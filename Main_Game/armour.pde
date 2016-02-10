class Armour
{
  
  float armourX;
  float armourY;


Armour(String line)
{
  //use space as delim, store data in temp array
    String delims = "[ ]+";
    String[] temps = line.split(delims);
    
    //add values to the Vwall structure
    armourX = Integer.parseInt(temps[0]) - 1150;
    armourY = Integer.parseInt(temps[1]) + 250;
}

}
