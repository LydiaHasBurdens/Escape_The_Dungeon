class Hero
{
  int lives;
  int health;
  int armour;
  int attack;
  
  float HeroX;
  float HeroY;


Hero()
{
  lives = 3;
  health = 100;
  armour = 10;
  attack = 20;
  
  HeroX = width/2;
  HeroY = height/2;
}

void DisplayHero( PImage heroFace )
{
  beginShape(QUAD);
  textureMode(IMAGE);
  texture(heroFace);//image size is 30 x 45
  vertex(HeroX-17.5, HeroY-20, 0, 0);
  vertex(HeroX+17.5, HeroY-20, 30, 0);
  vertex(HeroX+17.5, HeroY+20, 30, 45);
  vertex(HeroX-17.5, HeroY+20, 0, 45);
  endShape();
}

void DisplayStats()
{
  textSize(15);
  fill(255);
  text("Health : " + health + "%", HeroX - 330, HeroY - 330);
  fill(75);
  rect(eyeX - 300, eyeY - 325, 110, 25);
  fill(255, 0, 0);
  rect(eyeX - 295, eyeY - 320, myHero.health, 15);
  fill(255);
  text("Armour : " + armour + "%", HeroX - 150, HeroY - 330);
  text("Attack : " + attack, HeroX - 20, HeroY - 330);
  text("Lives : " + lives, HeroX + 250, HeroY - 330);
    
}


}
