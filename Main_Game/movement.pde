void keyPressed()
{
  if(move == true)
  {    
      if(key == 'w' || key == 'W')
      {
        myHero.HeroY -= 5;
        eyeY -= 5;
        heroFace = heroBack;
      }
      
      if(key == 's' || key == 'S')
      {
        myHero.HeroY += 5;
        eyeY += 5;
        heroFace = heroFront;
      }
      
      if(key == 'a' || key == 'A')
      {
        myHero.HeroX -= 5;
        eyeX -= 5;
        heroFace = heroLeft;
      }
      
      if(key == 'd' || key == 'D')
      {
        myHero.HeroX += 5;
        eyeX += 5;
        heroFace = heroRight;
      }
  }
  
  if( move == false )
  {
    if( key == ENTER )
    {
      fightCount++;
      
    }
    else if( key == '1' )
    {
      menuCount++;
      myHero.lives = 5;
      timeBuffer = millis()+7000;
      timeLimit = 600000;
    }
    else if( key == '2' )
    {
      menuCount++;
      myHero.lives = 3;
      timeBuffer = millis()+7000;
      timeLimit = 360000;
    }
    else if( key == '3' )
    {
      menuCount++;
      myHero.lives = 1;
      timeBuffer = millis()+7000;
      timeLimit = 240000;
    }
    
  }
  
  if( key == 'i' || key == 'I' )
  {
   if( controls == true )
   {
     controls = false;
   }
   else
   {
     controls = true;
   }
    
  }
  
}


void mousePressed()
{
  if( fightCount == 2 && mouseX > 270 && mouseX < 450 && mouseY > 335 && mouseY < 350 )
  {
    fightMove = 1;
  }
  else if( fightCount == 2 && mouseX > 270 && mouseX < 450 && mouseY > 360 && mouseY < 385)
  {
    fightMove = 2;
  }
}
