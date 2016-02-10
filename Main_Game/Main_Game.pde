/*
  Object Oriented Programming year 2 semester 1 assignment 2
  Video Game assignment
  
  Author: Amber Murray (C14741365)
  
  Overview:
  Design and code a game in processing using what I've learnt so far.
  game needs to:
  -look good, 
  -have multiple modes/screens,
  -have functionality
  -progression/powerups
  -have classes
  -load from text files
  
  My Game:
  I've designed a 2D maze-based dungeon escape game.
  Based on the difficulty you choose you have a varied amount of lives and time to escape.
  All sprites were designed and drawn by me.
  The map/maze was textured by me.
  The main character must find his way out of the dungeon, fighting enemies as he goes.
  There are also pickups to increase attack, armour and health scattered throughout the dungeon.
  Text files provide the co-ordinates for the collision walls, enemies and pickups based on the original map layout I designed.
  I added a soundtrack during gameplay, and a clock sound to tell the player they have 20 seconds left to find the exit
  The fight sequences are turn based. 
  The attacks are determined by taking the attack points of the player/enemy and subracting a percentage based on the armour rating of defendent
  Also attack points depends on the attack you choose and whether or not you hit or miss
  Added screens for the main menu, game over and ending scenarios
  
  CONTROLS:
  -WSAD buttons for movement
  -LEFT CLICK and ENTER for fight scenes
  -numbers to select difficulty
*/

//import minim library to enable sound players
import ddf.minim.*;

//declare the sound players
Minim minim;
AudioPlayer Theme;
AudioPlayer clock;

//array lists for the classes that need multiple instances based on text files(variable amount)
ArrayList<Vwall> vwall = new ArrayList<Vwall>();
ArrayList<Armour> armour = new ArrayList<Armour>();
ArrayList<Enemy> enemy = new ArrayList<Enemy>();
ArrayList<Potion> potion = new ArrayList<Potion>();
ArrayList<Sword> sword = new ArrayList<Sword>();

//declare the image variables for sprites, map and scenario screen
PImage map;
PImage heroFront;
PImage heroBack;
PImage heroLeft;
PImage heroRight;
PImage Enemy1;
PImage potion1;
PImage myArmour;
PImage sword1;
PImage heroFace;
PImage ending;
PImage MainMenu;
PImage control;
PImage GameOver;

//instance of the hero class(main character)
Hero myHero;

//declare the other variables
int menuCount;//for advancing the menu screen
Float mapX, mapY;//co-ords for the map image
float eyeX;//camera variables to maove screen
float eyeY;
int fightCount;//for advancing through fight sequence
int fightMove;//for determining which attack move player chooses
int fightHit;//for determining whether attack hits or not
int damage;//for fight sequence
boolean move;//to restrict player movement to off menu/fightscreen
boolean controls; //to check whether to display controls
String[] lines;//for reading in text file strings
int timeLimit;//variables for the timer
int timeBuffer;
int timeLeft;
int mins;
int secs;

void setup()
{
  size(700, 700, P3D);
  noStroke();
  background(125);
  
  //initialise the audio files and start playong the theme track
  minim = new Minim(this);
  Theme = minim.loadFile("dungeonSoundtrack.mp3");
  clock = minim.loadFile("clock.mp3");
  
  Theme.play();
  
  //initilise the other variables
  menuCount = 0;
  map = loadImage("Dungeon.jpg");
  Enemy1 = loadImage("enemy.png");
  heroFront = loadImage("front.png");
  heroBack = loadImage("back.png");
  heroLeft = loadImage("left.png");
  heroRight = loadImage("right.png");
  heroFace = heroFront;
  potion1 = loadImage("potion.png");
  myArmour = loadImage("armour.png");
  sword1 = loadImage("sword.png");
  ending = loadImage("ending.jpg");
  MainMenu = loadImage("mainMenu.jpg");
  control = loadImage("Controls.jpg");
  GameOver = loadImage("GameOver.jpg");
  myHero = new Hero();
  mapX = -1150.0;
  mapY = 250.0;
  eyeX = width/2;
  eyeY = height/2;
  fightCount = 1;
  fightMove = 2;
  
  move = true;
  controls = false;
  
  //load the variables into the arraylists using these functions
  loadArmour();
  loadEnemy();
  loadPotion();
  loadSword();


}//END SETUP



void draw()
{
  //shows the menu until a difficulty has been chosen
  if(menuCount < 1)
  {
    move = false;//stops movement on this screen
    beginShape(QUAD);
    textureMode(IMAGE);
    texture(MainMenu);//image size is 700 x 700
    vertex((myHero.HeroX)-width/2, (myHero.HeroY)-height/2, 0, 0);
    vertex((myHero.HeroX)+width/2, (myHero.HeroY)-height/2, 700, 0);
    vertex((myHero.HeroX)+width/2, (myHero.HeroY)+height/2, 700, 700);
    vertex((myHero.HeroX)-width/2, (myHero.HeroY)+height/2, 0, 700);
    endShape();
    
  }
  else
  {
      //brings up the map and sprites
      move = true;//enables movement again
      background(200);
      camera(eyeX, eyeY, (height/2.0) / tan(PI*60.0 / 360.0), eyeX, eyeY, 0, 0, 1, 0);
      loadMap(mapX, mapY); 
      loadWalls();//loads the invsible collision walls around the map
      
      //enables each collison wall to detect collision with hero
      for( int i = 0; i < vwall.size()-1; i++ )
      {
         WallCollision(vwall.get(i));
      }
      
      //displays the hero character in the appropriate orientation 
      myHero.DisplayHero(heroFace);
      //displays the current stats in the HUD
      myHero.DisplayStats();
      
        
        //detects when the hero has died
        if( myHero.health < 1 )
        {
          //returns map/hero and camera to start position
          mapX = -1150.0;
          mapY = 250.0;
          eyeX = width/2;
          eyeY = height/2;
          myHero.HeroX = width/2;
          myHero.HeroY = height/2;
          //deducts 1 life and returns health to 100%
          myHero.lives -= 1;
          myHero.health = 100;
          //restores movement
          move = true;
        }

          //each for loop displays each sprite from the arraylists and detects collision with hero
         for( int i = 0; i < armour.size()-1; i++ )
        {
           DisplayArmour(armour.get(i));
           Armourcollision(armour.get(i));
        }
        for( int i = 0; i < enemy.size()-1; i++ )
        {
           DisplayEnemy(enemy.get(i));
           Enemycollision(enemy.get(i));
        }
        for( int i = 0; i < potion.size()-1; i++ )
        {
           DisplayPotion(potion.get(i));
           Potioncollision(potion.get(i));
        }
        for( int i = 0; i < sword.size()-1; i++ )
        {
           DisplaySword(sword.get(i));
           Swordcollision(sword.get(i));
        }
      
      //using the millis() function and a 7 second time buffer and the timeLeft variable that is set depending on difficulty,
      //the timer is calculated and displayed in the HUD
      //the 7 second buffer is to accomodate the 7 seconds extra it takes to load from the main menu to the game start
      timeLeft = parseInt(timeLimit - millis() + timeBuffer);
      mins = parseInt(timeLeft / 60000);
      secs = parseInt((timeLeft % 60000)*0.001);
      text("Time Left : " + mins + ":" + secs, myHero.HeroX + 150, myHero.HeroY - 300);
      
      //When the time left is 20 seconds it stops the theme and plays a clock sound to alert the player
      if( timeLeft < 21000 )
      {
        Theme.pause();
        clock.play();
      }
      
      //detects collision of hero to exit door and displays ending screen
      if( dist(myHero.HeroX, myHero.HeroY, 520, 360) < 30  )
      {
        move = false;//disables movement
        
        beginShape(QUAD);
        textureMode(IMAGE);
        texture(ending);//image size is 700 x 700
        vertex((myHero.HeroX)-width/2, (myHero.HeroY)-height/2, 0, 0);
        vertex((myHero.HeroX)+width/2, (myHero.HeroY)-height/2, 700, 0);
        vertex((myHero.HeroX)+width/2, (myHero.HeroY)+height/2, 700, 700);
        vertex((myHero.HeroX)-width/2, (myHero.HeroY)+height/2, 0, 700);
        endShape();
        
        minim.stop();
      }
      
      //checks if player has run out of lives or time, displays the game over screen
      if( myHero.lives < 1 || timeLeft < 1  )
      {
        move = false;//disables movement
        fightCount = 1;//resets fight sequence
        
        beginShape(QUAD);
        textureMode(IMAGE);
        texture(GameOver);//image size is 700 x 700
        vertex((myHero.HeroX)-width/2, (myHero.HeroY)-height/2, 0, 0);
        vertex((myHero.HeroX)+width/2, (myHero.HeroY)-height/2, 700, 0);
        vertex((myHero.HeroX)+width/2, (myHero.HeroY)+height/2, 700, 700);
        vertex((myHero.HeroX)-width/2, (myHero.HeroY)+height/2, 0, 700);
        endShape();
        
        minim.stop();
      }
  }
  
  if( controls == true )
  {
     beginShape(QUAD);
    textureMode(IMAGE);
    texture(control);//image size is 700 x 700
    vertex((myHero.HeroX)-width/2, (myHero.HeroY)-height/2, 0, 0);
    vertex((myHero.HeroX)+width/2, (myHero.HeroY)-height/2, 700, 0);
    vertex((myHero.HeroX)+width/2, (myHero.HeroY)+height/2, 700, 700);
    vertex((myHero.HeroX)-width/2, (myHero.HeroY)+height/2, 0, 700);
    endShape();
  }
  
  //loops the theme
   if ( Theme.position() > Theme.length()-61 )
  {
    Theme.rewind();
    Theme.play();
  }
}//END DRAW


//-------------------------------------FUNCTIONS---------------------

//loads the map image as a textured shape
void loadMap(float mapX, float mapY)
{
  beginShape(QUAD);
  textureMode(IMAGE);
  texture(map);//image size is 3500 x 2621
  vertex(mapX, mapY, 0, 0);
  vertex(mapX+3500, mapY, 3500, 0);
  vertex(mapX+3500, mapY+2621, 3500, 2621);
  vertex(mapX, mapY+2621, 0, 2621);
  endShape();
}

//reads the wall co-ordinates, height and width from a .txt file and places the values in the arraylist
void loadWalls()
{
  lines = loadStrings("Vertical_Walls.txt");
  
  for( int i = 0; i < lines.length; i++ )
  {
    Vwall Vwall_temp = new Vwall(lines[i]);
    vwall.add(Vwall_temp);
  }
}//END LOADWALLS

//similar to the walls, co-ords are read from .txt file and applied to the armour, enemies, potion and sword  array lists
void loadArmour()
{
  lines = loadStrings("armour.txt");
  
  for( int i = 0; i < lines.length; i++ )
  {
    Armour armour_temp = new Armour(lines[i]);
    armour.add(armour_temp);
  }
}

void loadEnemy()
{
  lines = loadStrings("enemies.txt");
  
  for( int i = 0; i < lines.length; i++ )
  {
    Enemy enemy_temp = new Enemy(lines[i]);
    enemy.add(enemy_temp);
  }
}

void loadPotion()
{
  lines = loadStrings("potions.txt");
  
  for( int i = 0; i < lines.length; i++ )
  {
    Potion potion_temp = new Potion(lines[i]);
    potion.add(potion_temp);
  }
}

void loadSword()
{
  lines = loadStrings("swords.txt");
  
  for( int i = 0; i < lines.length; i++ )
  {
    Sword sword_temp = new Sword(lines[i]);
    sword.add(sword_temp);
  }
}

//collision with armour pick-up
void Armourcollision(Armour armour)
{
  if( dist(myHero.HeroX, myHero.HeroY, armour.armourX, armour.armourY) < 30 )
  {
    //armour gives hero 10 more armour points
    myHero.armour += 10;
    armour.armourX -= 3600;//moves the armour pickup off the map
  }
}
  //collision with enemy
void Enemycollision(Enemy enemy)
{
  if( dist(myHero.HeroX, myHero.HeroY, enemy.EnemyX, enemy.EnemyY) < 50 )
  {
    fight(myHero, enemy);//initialises the fight sequence function
  }
}
  
  //collision with health potion
  void Potioncollision(Potion potion)
{
  if( dist(myHero.HeroX, myHero.HeroY, potion.potionX, potion.potionY) < 30 )
  {
    myHero.health = 100;//restores gero health to 100%
    potion.potionX -=3600;//moves pickup off map
  }
}

 void Swordcollision(Sword sword)
{
  if( dist(myHero.HeroX, myHero.HeroY, sword.swordX, sword.swordY) < 30 )
  {
    myHero.attack += 20;//gives hero 20 more attack points
    sword.swordX -=3600;//moves pickup off map 
  }
}
 
 

//collision with vertical walls, moves hero back 6 in the direction it came from, it moves at a rate of 5 so cant pass that point
void WallCollision(Vwall vwall)
{
  
  //left side( checks of the distance of the point at wallX and heroY is less than 18.5 from hero AND hero is between top and bottom of this wall )
  if( dist( myHero.HeroX, myHero.HeroY, vwall.x-1150, myHero.HeroY ) < 18.5 && myHero.HeroY < (vwall.y+250 + vwall.h) && myHero.HeroY > vwall.y+250 )
  {
    myHero.HeroX -= 6;
    eyeX -= 6;
  }
  
  //right side( checks of the distance of the point at wallX + wall width and heroY is less than 18.5 from hero AND hero is between top and bottom of this wall )
  else if( (dist( myHero.HeroX, myHero.HeroY, vwall.x-1150 + 70, myHero.HeroY ) < 18.5) && myHero.HeroY < (vwall.y+250 + vwall.h) && myHero.HeroY > vwall.y+250 )
  {
    myHero.HeroX += 6;
    eyeX += 6;
  }
  
  //top side( checks of the distance of the point at heroX and wallY is less than 18.5 from hero AND hero is between left and right of wall )
  else if( (dist( myHero.HeroX, myHero.HeroY, myHero.HeroX, vwall.y+250 ) < 18.5) && myHero.HeroX < (vwall.x-1150 + vwall.w) && myHero.HeroX > vwall.x-1150 )
  {
    myHero.HeroY-= 6;
    eyeY -= 6;
  }
  
  //bottom side( checks of the distance of the point at heroX and wallY + wall height is less than 18.5 from hero AND hero is between left and right of wall )
  else if( (dist( myHero.HeroX, myHero.HeroY, myHero.HeroX, vwall.y+250 + vwall.h ) < 18.5) && myHero.HeroX < (vwall.x-1150 + vwall.w) && myHero.HeroX > vwall.x-1150 )
  {
    myHero.HeroY += 6;
    eyeY += 6;
  }
}//END WALL COLLISION 

//fight sequence
void fight( Hero myHero, Enemy enemy )
{
  
  move = false;//disables movement while fight sequence is on
  
  
  //draws the 'arena', enemy facing hero fight text box in the middle
  fill(255);
  rect( myHero.HeroX - width/2, myHero.HeroY - height/2, width, height, 2 );
  beginShape(QUAD);
  textureMode(IMAGE);
  texture(Enemy1);//image size is 30 x 45
  vertex(myHero.HeroX + 150, myHero.HeroY - 340, 0, 0);
  vertex(myHero.HeroX + 350, myHero.HeroY - 340, 30, 0);
  vertex(myHero.HeroX + 350, myHero.HeroY, 30, 45);
  vertex(myHero.HeroX + 150, myHero.HeroY, 0, 45);
  endShape();
  beginShape(QUAD);
  textureMode(IMAGE);
  texture(heroFront);//image size is 30 x 45
  vertex(myHero.HeroX - 350, myHero.HeroY, 0, 0);
  vertex(myHero.HeroX - 150, myHero.HeroY, 30, 0);
  vertex(myHero.HeroX - 150, myHero.HeroY + 340, 30, 45);
  vertex(myHero.HeroX - 350, myHero.HeroY + 340, 0, 45);
  endShape();
  
  //health and armour stat bars for hero
  fill(125);
  rect(myHero.HeroX + 95, myHero.HeroY + 145, 210, 15);
  rect(myHero.HeroX + 95, myHero.HeroY + 160, 105, 15);
  fill(255, 0, 0);
  rect(myHero.HeroX + 100, myHero.HeroY + 150, 2*myHero.health, 5);
  fill(0,255,255);
  rect(myHero.HeroX + 100, myHero.HeroY + 165, myHero.armour, 5);
  
  //health and armour stat bars for enemy
  fill(125);
  rect(myHero.HeroX - 300, myHero.HeroY - 270, 210, 15);
  rect(myHero.HeroX - 300, myHero.HeroY - 255, 105, 15);
  fill(255, 0, 0);
  rect(myHero.HeroX - 295 , myHero.HeroY - 265, 2*enemy.health, 5);
  fill(0,255,255);
  rect(myHero.HeroX - 295, myHero.HeroY - 250, enemy.armour, 5);
 
  //text boxs
  fill(137, 10, 90);
  rect(myHero.HeroX -90, myHero.HeroY - 50, 200, 120 );
  fill(237, 110, 190);
  rect(myHero.HeroX -100, myHero.HeroY - 60, 200, 120 );
  
    //fightcount is used to determine whether the player has moved onto the next move by pressing ENTER
    
    //first box: announces its a fight sequence
    if(fightCount == 1)
    {
      fill(0);
      textSize(50);
      text("FIGHT!!", myHero.HeroX-80, myHero.HeroY+15);
      textSize(10);
      text("ENTER", myHero.HeroX + 30, myHero.HeroY + 55);
    }
    else if(fightCount == 2)//second box: player turn
    {
      textSize(30);
      fill(0);
      text("YOUR TURN", myHero.HeroX-80, myHero.HeroY-30);
      textSize(20);
      //draw the highlight box to show selection, default is fightMove =1
      if( fightMove == 1 )
      {
        fill(0, 255, 255);
        rect(myHero.HeroX - 80, myHero.HeroY - 20, 180, 25);
      }
      else if( fightMove == 2 )
      {
        fill(0, 255, 255);
        rect(myHero.HeroX - 80, myHero.HeroY + 10, 180, 25);
      }
      fill(0);
      text("* 2-Handed attack", myHero.HeroX-80, myHero.HeroY);
      text("* 1-Handed attack", myHero.HeroX-80, myHero.HeroY + 30);
      textSize(10);
      text("ENTER", myHero.HeroX + 30, myHero.HeroY + 55);
    }
    else if(fightCount == 3)//third box: dtermines how much health enemy loses
    {
      fightHit = parseInt(random(1, 10));
      if( fightMove == 1 && fightHit > 0 && fightHit < 8 )
      {
        //hit
        damage = parseInt((myHero.attack - (enemy.armour*0.1)));
        enemy.health -= damage;
        fill(0);
        fightCount++;
      }
      else if( fightMove == 1 && fightHit > 7 && fightHit < 11)
      {
        //miss
        damage = 0;
        enemy.health -= damage;
        fill(0);
        fightCount++;
      }
      else if( fightMove == 2 )
      {
        damage = parseInt((myHero.attack - (enemy.armour*0.1)) * 0.5);
        enemy.health -= damage;
        fill(0);
        fightCount++;
      }
          
    }
    else if(fightCount == 4)//fourth box: communicates the amount of damage enemy took
    {
      if( damage > 0 )
      {
        fill(0);
        text("Enemy took " +  damage + " damage", myHero.HeroX-80, myHero.HeroY+15 );
      }    
      else
      {
        fill(0);
        text("you missed ", myHero.HeroX-80, myHero.HeroY+15 );
      }
    }
    else if(fightCount == 5)//fifth box: if enemy isnt dead its enemy turn
    {
      if(enemy.health < 1)
      {
        move = true;//enable movement
        enemy.EnemyX -= 4000;//remove enemy sprite from map
        fightCount = 1;//resets fight counter for next fight
      }
      else 
      {
        textSize(25);
        fill(0);
        text("ENEMY'S TURN", myHero.HeroX-80, myHero.HeroY+15);
        textSize(10);
        text("ENTER", myHero.HeroX + 30, myHero.HeroY + 55);
      }
    }
    else if(fightCount == 6)//sixth box: determines damage taken by hero
    {
      damage = parseInt((enemy.attack - (myHero.armour * 0.01)) - random(0,15));
      myHero.health -= damage;
      fill(0);
      fightCount ++;
    }
    else if(fightCount == 7)//seventh box: communicates amount of damage taken  by hero
    {
      fill(0);
      text("You took " + damage + " damage", myHero.HeroX-80, myHero.HeroY+15 );
    }
    else if(fightCount ==8 && myHero.health > 0 && enemy.health > 0 )//if both enemy and hero are still standing by this stage, reset fightcount to 2 and loop from there
    {
        fightCount = 2;
    }
}
    
    //functions to display the sprites using them as a texture for a shape, and placing them using the .txt files read earlier
    void DisplayArmour(Armour armour)
{
  beginShape(QUAD);
  textureMode(IMAGE);
  texture(myArmour);//image size is 30 x 45
  vertex((armour.armourX)-17.5, (armour.armourY)-20, 0, 0);
  vertex((armour.armourX)+17.5, (armour.armourY)-20, 30, 0);
  vertex((armour.armourX)+17.5, (armour.armourY)+20, 30, 45);
  vertex((armour.armourX)-17.5, (armour.armourY)+20, 0, 45);
  endShape();
}

void DisplayEnemy(Enemy enemy)
{
  beginShape(QUAD);
  textureMode(IMAGE);
  texture(Enemy1);//image size is 30 x 45
  vertex((enemy.EnemyX)-17.5, (enemy.EnemyY)-20, 0, 0);
  vertex((enemy.EnemyX)+17.5, (enemy.EnemyY)-20, 30, 0);
  vertex((enemy.EnemyX)+17.5, (enemy.EnemyY)+20, 30, 45);
  vertex((enemy.EnemyX)-17.5, (enemy.EnemyY)+20, 0, 45);
  endShape();
}

void DisplayPotion(Potion potion)
{
  beginShape(QUAD);
  textureMode(IMAGE);
  texture(potion1);//image size is 30 x 45
  vertex((potion.potionX)-17.5, (potion.potionY)-20, 0, 0);
  vertex((potion.potionX)+17.5, (potion.potionY)-20, 30, 0);
  vertex((potion.potionX)+17.5, (potion.potionY)+20, 30, 45);
  vertex((potion.potionX)-17.5, (potion.potionY)+20, 0, 45);
  endShape();
}
    
    
void DisplaySword(Sword sword)
{
  beginShape(QUAD);
  textureMode(IMAGE);
  texture(sword1);//image size is 30 x 45
  vertex((sword.swordX)-17.5, (sword.swordY)-20, 0, 0);
  vertex((sword.swordX)+17.5, (sword.swordY)-20, 30, 0);
  vertex((sword.swordX)+17.5, (sword.swordY)+20, 30, 45);
  vertex((sword.swordX)-17.5, (sword.swordY)+20, 0, 45);
  endShape();
}
   
  
