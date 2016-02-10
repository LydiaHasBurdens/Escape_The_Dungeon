class Enemy
{
  int health;
  int armour;
  int attack;
  
  float EnemyX;
  float EnemyY;


Enemy(String line)
{
  
  //use space as delim, store data in temp array
  String delims = "[ ]+";
  String[] temps = line.split(delims);
  
  health = 100;
  armour = parseInt(random(10, 60));
  attack = parseInt(random(10, 30));
  
  EnemyX = Integer.parseInt(temps[0]) - 1150;
  EnemyY = Integer.parseInt(temps[1]) + 250;
  
}



}
