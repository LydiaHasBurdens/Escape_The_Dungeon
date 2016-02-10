class Sword
{
  
  float swordX;
  float swordY;


Sword(String line)
{
  //use space as delim, store data in temp array
    String delims = "[ ]+";
    String[] temps = line.split(delims);
    
  swordX = Integer.parseInt(temps[0]) - 1150;
  swordY = Integer.parseInt(temps[1]) + 250;
  
}



}
