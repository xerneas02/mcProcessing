//////////////////////////////////////////////////////////////////////////
//This code is made by Mathis Roubille with the help of Thomas Tamagnaud//
//////////////////////////////////////////////////////////////////////////



//import com.jogamp.newt.opengl.GLWindow;

//GLWindow r;

Player player = new Player();

final float TIME_DAY_MIN = 1;
PVector directionChunckToDraw = new PVector();
PVector directionChunckToDrawPerp = new PVector();

//The size of a chunck in block
public int sizeChunckXZ = 8;
public int sizeChunckY = 126;

//The number of block in the game and the id of the current block in hand
int nbrBlock = 9;
int blockInHand = 0;

//The coordinate of the block 
PVector target = new PVector();

//The texture's image
public PImage img;

//The size of the zone load around the player in chunck
int renderDistance = 3;

//The number of chunck of side of the map, the size of the map is nbrChunck*nbrChunck
int nbrChunck = 256;
public Chunck[][] C = new Chunck[nbrChunck][nbrChunck];

//The size of the texture in the image in pixel
public int sizeTexture = 16;

//The size of a block
public int sizeBlock = 1;

boolean isFeetInWater = false;
boolean isHeadInWater = false;

//Tree constant height of the tree, width of the tree and the recurrence of the tree (approximatly one tree every 'recurenceTree' block)
public int minWidthTree = 1;
public int maxWidthTree = 2;
public int maxHeightTree = 7;
public int minimumHeightTree = 4;
public int distLeaveFromTree = 2;
public float recurenceTree = 1000;

//Distance in which you can reach the block
int lookDist = 4;


//The minimum and maximum height of the ground
int minGroundLevel = 20;
int maxGroundLevel = 50;
int seaLevel = 30;

//Speed of the player in survival
float normalSpeed = 0.2;
float speed = normalSpeed;

//Variable to know the time the player is in jump or falling  (in frame)
int jumpTime = 0;
int fallTime = 0;

//2 constants that manage the jump height. jumpHeight is the height of th jump and the maxJumpTime is the constant use in the code it's conversion of the height of the jump in time (number of frame)
float jumpHeight = 1.1;
int maxJumpTime = int(9 * jumpHeight);

//The color of the sky in RGB
int cielColor = color(79, 181, 255);

//The size of the icon that show the block in hand
int sizeImageItem = 64;
int offsetImageItem = 8;

//The random genration of the seed
int seed = (int)(random(0, 1000000000));
float time = 0;


void setup() 
{  
  fullScreen(P3D);
  img = loadImage("block.png");
  
  //seed = 42; //To set a seed and get the same world every time  
  
  //Lock the cursor in the window and hide it
  //r = (GLWindow)surface.getNative();
  //r.confinePointer(true);
  //r.setPointerVisible(false);
  
  
  randomSeed(seed);
  noiseSeed(seed);
  noiseDetail(8, 0.6);
  ((PGraphicsOpenGL)g).textureSampling(3);
  colorMode(RGB, 255, 255, 255);
  //surface.setResizable(true);

  //Init the player value
  player.pos = new PVector((nbrChunck*sizeChunckXZ)/2,maxGroundLevel,(nbrChunck*sizeChunckXZ)/2);
  player.pastPos = new PVector((nbrChunck*sizeChunckXZ)/2,maxGroundLevel,(nbrChunck*sizeChunckXZ)/2);
  player.speed = new PVector(0,0,0);
  player.direction = new PVector(1,0,0);
  player.chunck = new PVector(int(player.pos.x/sizeChunckXZ), int(player.pos.z/sizeChunckXZ));
  
  
  //Init the geration of the chunck around the player
  for(int i = 0; i < C.length; i++)
  {
    for(int j = 0; j < C[i].length; j++)
    {                 
      if(abs(i-player.chunck.x) <= int((renderDistance+2)/2) && abs(j-player.chunck.y) <=  int((renderDistance+2)/2))
      {
        C[i][j] = new Chunck(); 
        C[i][j].generate(i, j);
        C[i][j].isGenerate = true;
      }
    }
  }
  
  for(int i = 0; i < C.length; i++)
  {
    for(int j = 0; j < C[i].length; j++)
    {
       if(abs(i-player.chunck.x) <= int((renderDistance)/2) && abs(j-player.chunck.y) <=  int((renderDistance)/2))
       {
         C[i][j].voisin[0] = i > 0 ? C[i-1][j] : null;
         C[i][j].voisin[1] = i < C.length-1 ? C[i+1][j] : null;
         C[i][j].voisin[2] = j > 0 ? C[i][j-1] : null;
         C[i][j].voisin[3] = j < C[i].length-1 ? C[i][j+1] : null;
         C[i][j].initShowFace();
         C[i][j].isFaceShow = true;
       }    
    }
  } 
  
  frameRate(50);
}



void draw()
{
  noStroke();
  //r.warpPointer(width/2,height/2);
  //time += 1/(frameRate*TIME_DAY_MIN*60);
  //time = time%1;
  
  
  if(player.spectator)speed = 0.4;
  else speed = 0.2;
  
  
  background(cielColor);
  
  drawCamera();
  
  /*
  float lX = cos(time * TWO_PI);
  float lY = sin(time * TWO_PI);
  
  color bottom = color(255, 255, 255);
  color top = color(255, 0, 0); 
  
  float distTransitionColor = 1.5;
  
  PVector colorTransi = new PVector((red(top)-red(bottom)), (green(top)-green(bottom)), (blue(top)-blue(bottom)));
  color lightColor = color(colorTransi.x*distTransitionColor*lY+red(bottom), colorTransi.y*distTransitionColor*lY+green(bottom), colorTransi.z*distTransitionColor*lY+blue(bottom));
  lights();
  pointLight(red(lightColor), green(lightColor), blue(lightColor), lX, lY, 0);
  specular(255, 0, 255);
  shininess(1/10.0);*/
  lights();
  
  player.chunck = new PVector(int(player.pos.x/sizeChunckXZ), int(player.pos.z/sizeChunckXZ));
  
  targetBlockLook();
  
  //Generate the new chunck load by the player with 1 more than the renderDistance of the playerso that the visible chunck know the block in te chunck around them
  for(int i = int(player.chunck.x-int((renderDistance+2)/2)); i <= int(player.chunck.x+int((renderDistance+2)/2)); i++)
  {
    for(int j = int(player.chunck.y-int((renderDistance+2)/2)); j <= int(player.chunck.y+int((renderDistance+2)/2)); j++)
    {
      if(i >= 0 && i < C.length && j >= 0 && j < C[i].length)
      {
         
        if(C[i][j] == null || !C[i][j].isGenerate)
        {
           C[i][j] = new Chunck();
           C[i][j].generate(i, j);
           C[i][j].isGenerate = true;
        }      
      }
    }
  }
  
  //Tell the chunck his neighbor chunck and hide the face of the block that shouldn't be visible then draw the chunck    
  for(int i = int(player.chunck.x-int((renderDistance)/2)); i <= int(player.chunck.x+int((renderDistance)/2)); i++)
  {
    for(int j = int(player.chunck.y-int((renderDistance)/2)); j <= int(player.chunck.y+int((renderDistance)/2)); j++)
    {
      if(i >= 0 && i < C.length && j >= 0 && j < C[i].length)
      {
        if(!C[i][j].isFaceShow)
        {
          C[i][j].voisin[0] = i > 0 ? C[i-1][j] : null;
          C[i][j].voisin[1] = i < C.length-1 ? C[i+1][j] : null;
          C[i][j].voisin[2] = j > 0 ? C[i][j-1] : null;
          C[i][j].voisin[3] = j < C[i].length-1 ? C[i][j+1] : null;
          C[i][j].initShowFace();
          C[i][j].isFaceShow = true;
        }
        C[i][j].drawn = false;
      }
    }
  }
  
  for(int i = int(player.chunck.x-1); i <= int(player.chunck.x+1); i++)
  {
    for(int j = int(player.chunck.y-1); j <= int(player.chunck.y+1); j++)
    {
      C[i][j].draw();
      C[i][j].drawn = true;
    }
  }
  int precision = 256+16;
  PVector V = new PVector(player.chunck.x, player.chunck.y);

  PVector directionC = new PVector(directionChunckToDraw.x/precision, directionChunckToDraw.y/precision);
  
  for(int i = 0 ; i <= int((renderDistance/2)+1)*precision ; i++, V.add(directionC))
  {
    PVector VX = new PVector(V.x, V.y);
    PVector VZ = new PVector(V.x, V.y);
    for(int j = 0 ; j <= int((renderDistance/2)+1) ; j++, VX.add(directionChunckToDrawPerp))
    {
      if(abs(player.chunck.x - round(VX.x)) <= renderDistance/2 && abs(player.chunck.y - round(VX.y)) <= renderDistance/2 && !C[round(VX.x)][round(VX.y)].drawn)
      {
        C[round(VX.x)][round(VX.y)].draw();
        C[round(VX.x)][round(VX.y)].drawn = true;
      }    
    }
    
    for(int j = 0 ; j <= int((renderDistance/2)+1) ; j++, VZ.add(directionChunckToDrawPerp.mult(-1)))
    {
      if(abs(player.chunck.x - round(VZ.x)) <= renderDistance/2 && abs(player.chunck.y - round(VZ.y)) <= renderDistance/2 && !C[round(VZ.x)][round(VZ.y)].drawn)
      {
        C[round(VZ.x)][round(VZ.y)].draw();
        C[round(VZ.x)][round(VZ.y)].drawn = true;
      }    
    }
  }
  
  //That draw the 2d information like the coordinate or the block in hand
  draw2DInfo();
  
  
  
}

void targetBlockLook()
{
   /*
   That Function search the block the player is targetting then tell the block that he is the target block
   and place the coordinate of the block in target.
   If there is no target block the coordinate are (-1, -1, -1).
   */
   
   int precision = 256+16;
   PVector V = new PVector(player.pos.x, player.pos.y, player.pos.z);
   PVector lookDivide = new PVector(player.look.x/precision, player.look.y/precision, player.look.z/precision);
   for(int i = 0 ; i < (lookDist*precision)+1 ; i++, V.add(lookDivide))
   {    
       if((int)(V.x/sizeChunckXZ) >= 0 && (int)(V.x/sizeChunckXZ) < nbrChunck && (int)(V.y) >= 0 && (int)(V.y) < sizeChunckY && (int)(V.z/sizeChunckXZ) >= 0 && (int)(V.z/sizeChunckXZ) < nbrChunck && C[(int)(V.x/sizeChunckXZ)][(int)(V.z/sizeChunckXZ)].map[(int)(V.x%sizeChunckXZ)][(int)(V.y)][(int)(V.z%sizeChunckXZ)].getId() != -1 && !C[(int)(V.x/sizeChunckXZ)][(int)(V.z/sizeChunckXZ)].map[(int)(V.x%sizeChunckXZ)][(int)(V.y)][(int)(V.z%sizeChunckXZ)].isItLiquid())      
       {
           C[(int)(V.x/sizeChunckXZ)][(int)(V.z/sizeChunckXZ)].map[(int)(V.x%sizeChunckXZ)][(int)(V.y)][(int)(V.z%sizeChunckXZ)].isItTarget(true);
           target.x = V.x;
           target.y = V.y;
           target.z = V.z;
           return;
        }
   }
   target.x = -1;
   target.y = -1;
   target.z = -1;
}

void drawCamera()
{ 
  /*
  This function : 
    -place the camera/player at the right coordinate by adding the vector speed of the player at his current position.
    -change the angle of the camera in function of the mouse. 
    -search if the player should fall or if he went into a block to replace it at the right position.
    -calculate the vector of the player's look to find the block he his looking at.  
  */
  float sensibiliteSouri = 1.25;
  
  player.angleCamXZ = ((float(mouseX)/width) *TWO_PI*sensibiliteSouri);
  player.angleCamY = (((mouseY-height/2.0)/height*PI));
  
  if(player.angleCamY <= -1.57)player.angleCamY = -1.56;
  
  directionChunckToDraw.x = cos((player.angleCamXZ+PI));
  directionChunckToDraw.y = cos(PI/2-player.angleCamXZ);
  directionChunckToDrawPerp.x = cos((player.angleCamXZ+PI/2));
  directionChunckToDrawPerp.y = cos(PI-player.angleCamXZ);
  
  player.look.x = round(10, cos(player.angleCamY)*(cos(player.angleCamXZ+PI)*sizeBlock));
  player.look.y = round(10, cos(PI/2+player.angleCamY)*sizeBlock);
  player.look.z = round(10, cos(player.angleCamY)*(cos(PI/2-player.angleCamXZ)*sizeBlock));
  
  float d = 1;
  float cosAngleY = cos(player.angleCamY);  
  player.direction = new PVector(-cos(player.angleCamXZ)*d*cosAngleY, -sin(player.angleCamY)*d, sin(player.angleCamXZ)*d*cosAngleY);
  
  if(player.speed.magSq() != 0)
  {
    PVector tmp = new PVector(player.speed.x, player.speed.z, player.speed.y).rotate(-player.angleCamXZ+PI/2);
    tmp = new PVector(tmp.x, tmp.z, tmp.y);
    player.pos.add(tmp);
  }
  
  if(!player.spectator)
  {
    if(isBlockInHitBox())
    {
       if(player.pos.x == player.pastPos.x && player.pos.z == player.pastPos.z)
       {
         player.pos.y = int(player.pos.y-player.sizeHitbox.y+0.01) + player.sizeHitbox.y+1 -0.01;
         player.speed.y = 0;   
       }
       player.pos.x = player.pastPos.x;
       player.pos.z = player.pastPos.z;
       
    }
     
    isBlockInHitBoxYUp();
    isBlockInHitBoxYDown();
    
    if(isFeetInWater)
    {
      speed = normalSpeed/2;
      if(abs(player.speed.x) == normalSpeed)
      {
         player.speed.x /= 2; 
      }
      if(abs(player.speed.z) == normalSpeed)
      {
         player.speed.z /= 2; 
      }
    }
    else
    {
      speed = normalSpeed;
      if(abs(player.speed.x) == normalSpeed/2)
      {
         player.speed.x *= 2; 
      }
      if(abs(player.speed.z) == normalSpeed/2)
      {
         player.speed.z *= 2; 
      }
    }
    if(player.speed.y > 0) jumpTime++;
    else if(player.speed.y < 0)
    {
      jumpTime = maxJumpTime;
      if(fallTime <= maxJumpTime*4) fallTime++; 
    }
    else if(player.speed.y == 0.0) 
    {
      jumpTime = 0;
      fallTime = 0;
    }
    if(jumpTime == maxJumpTime && isFeetInWater)
    {
      jumpTime = maxJumpTime-1; 
    }
    if(player.speed.y < 0 && player.pos.y + player.speed.y >= 0 && player.pos.y + player.speed.y < sizeChunckY && C[int((player.pos.x+player.speed.x)/sizeChunckXZ)][int(player.pos.z+player.speed.z)/sizeChunckXZ].map[int((player.pos.x+player.speed.x)%sizeChunckXZ)][int((player.pos.y-player.sizeHitbox.y)+player.speed.y)][int((player.pos.z+player.speed.z)%sizeChunckXZ)].getId() != -1 && !C[int((player.pos.x+player.speed.x)/sizeChunckXZ)][int(player.pos.z+player.speed.z)/sizeChunckXZ].map[int((player.pos.x+player.speed.x)%sizeChunckXZ)][int((player.pos.y-player.sizeHitbox.y)+player.speed.y)][int((player.pos.z+player.speed.z)%sizeChunckXZ)].isItLiquid())
    {
       player.pos.y = int(player.pos.y-player.sizeHitbox.y+0.01) + player.sizeHitbox.y -0.01;
       player.speed.y = (int(player.pos.y-player.sizeHitbox.y+0.01) + player.sizeHitbox.y -0.01) - player.pos.y; 
    }
  }
  
  
  player.pastPos.x = player.pos.x;
  player.pastPos.z = player.pos.z;
  player.pastPos.y = player.pos.y;
  
  resetMatrix();
  
  camera(player.pos.x, player.pos.y, player.pos.z, player.pos.x+player.direction.x, player.pos.y+player.direction.y, player.pos.z+player.direction.z, 0, -0.1, 0);
  perspective(PI/2, float(width)/float(height), 0.01, 100);
  //scale(1./10);//height);
}

boolean isBlockInHitBox()
{
  //This function test if the player run into a block on the x and z coordinate.
  for(float i = player.pos.x-(player.sizeHitbox.x/2); i <= player.pos.x+(player.sizeHitbox.x/2); i += 0.1)
  {
    for(float j = player.pos.y-player.sizeHitbox.y+0.1; j <= player.pos.y; j+=0.1)
    {
      for(float k = player.pos.z-(player.sizeHitbox.z/2); k <= player.pos.z+(player.sizeHitbox.z/2); k += 0.1)
      {
        if(i >= 0 && j >= 0 && k >= 0 && i < nbrChunck*sizeChunckXZ && j < sizeChunckY && k < nbrChunck*sizeChunckXZ)
        {
           if(C[int(i/sizeChunckXZ)][int(k/sizeChunckXZ)].map[int(i%sizeChunckXZ)][int(j)][int(k%sizeChunckXZ)].getId() != -1 && !C[int(i/sizeChunckXZ)][int(k/sizeChunckXZ)].map[int(i%sizeChunckXZ)][int(j)][int(k%sizeChunckXZ)].isItLiquid()) return true;
        }
      }
    }
  }
  return false;
}

boolean isBlockInHitBoxYUp()
{
  //This function test if the player run into a block at the top of his hitbox
  for(float i = player.pos.x-(player.sizeHitbox.x/2); i <= player.pos.x+(player.sizeHitbox.x/2); i += 0.1)
  {
    
    for(float j = player.pos.y-0.2; j <= player.pos.y+0.3; j+=0.1)
    {
      for(float k = player.pos.z-(player.sizeHitbox.z/2); k <= player.pos.z+(player.sizeHitbox.z/2); k += 0.1)
      {
        
        if(i >= 0 && j >= 0 && k >= 0 && i < nbrChunck*sizeChunckXZ && j < sizeChunckY && k < nbrChunck*sizeChunckXZ)
        {
           if(C[int(i/sizeChunckXZ)][int(k/sizeChunckXZ)].map[int(i%sizeChunckXZ)][int(j)][int(k%sizeChunckXZ)].getId() != -1 && !C[int(i/sizeChunckXZ)][int(k/sizeChunckXZ)].map[int(i%sizeChunckXZ)][int(j)][int(k%sizeChunckXZ)].isItLiquid())
           {
             jumpTime = maxJumpTime; return true;
           }
           else if (C[int(i/sizeChunckXZ)][int(k/sizeChunckXZ)].map[int(i%sizeChunckXZ)][int(j)][int(k%sizeChunckXZ)].isItLiquid())
           {
              isHeadInWater = true; 
           }
           else
           {
              isHeadInWater = false; 
           }
        }
      }
    }
  }
  return false;
}

boolean isBlockInHitBoxYDown()
{
  //This function test if the player run into a block at the bottom of his hitbox and sif he should fall or not
  for(float i = player.pos.x-(player.sizeHitbox.x/2); i <= player.pos.x+(player.sizeHitbox.x/2); i += 0.1)
  {
    for(float k = player.pos.z-(player.sizeHitbox.z/2); k <= player.pos.z+(player.sizeHitbox.z/2); k += 0.1)
    {
      if(i >= 0 && player.pos.y-player.sizeHitbox.y > 0 && k >= 0 && i < nbrChunck*sizeChunckXZ && player.pos.y-player.sizeHitbox.y < sizeChunckY && k < nbrChunck*sizeChunckXZ)
      {
         if(player.speed.y <= 0  && C[int(i/sizeChunckXZ)][int(k/sizeChunckXZ)].map[int(i%sizeChunckXZ)][int(player.pos.y-player.sizeHitbox.y)][int(k%sizeChunckXZ)].getId() != -1 && !C[int(i/sizeChunckXZ)][int(k/sizeChunckXZ)].map[int(i%sizeChunckXZ)][int(player.pos.y-player.sizeHitbox.y)][int(k%sizeChunckXZ)].isItLiquid())
         {
           //player.pos.y = (int)(player.pos.y)+player.sizeHitbox.y;
           
           player.speed.y = 0; 
           jumpTime = 0;
           return true;
         }
         else if(C[int(i/sizeChunckXZ)][int(k/sizeChunckXZ)].map[int(i%sizeChunckXZ)][int(player.pos.y-player.sizeHitbox.y)][int(k%sizeChunckXZ)].isItLiquid())
         {
            isFeetInWater = true;
         }
         else
         {
            isFeetInWater = false;
         }
      }      
    }
  }
  if(player.speed.y <= 0 || jumpTime >= maxJumpTime)
  {
    player.speed.y = -speed * (fallTime+1)/maxJumpTime;
    if(player.speed.y == -speed*3) player.speed.y = -speed*3;
  }
  return false;
}


void camera2D()
{
  //This allow to draw 2D object in front of the camera
  resetMatrix();
  float d = 0.001;
  translate(width/-2,height/-2,-d);
  perspective(2*atan(height/2.0/d), float(width)/float(height), 0.0001, 1);
}

void draw2DInfo()
{
  //This function draw all the 2D information the coordiate the block in the hand the mouse and the square at center of the screen
  camera2D();
  if(isHeadInWater)
  {
    fill(77, 194, 255, 100);
    rect(0, 0, width, height);
  }
  fill(255);
  float mSize = 4;
  rect(mouseX-mSize/2,mouseY-mSize/2,mSize,mSize);
  rect((width/2)+1,(height/2)+1,2,2);
  textAlign(LEFT, TOP);
  textSize(24);
  int base = 50;
  text("Fps: "+nf(frameRate, 0, 1), 0, base+0, 0);
  text("x: "+nf(player.pos.x, 0, 1), 0, base+30, 0);
  text("y: "+nf(player.pos.y, 0, 1), 0, base+60, 0);
  text("z: "+nf(player.pos.z, 0, 1), 0, base+90, 0);
  text("chunckX: "+ player.chunck.x, 0, base+120, 0);
  text("chunckZ: "+ player.chunck.y, 0, base+150, 0);
  text("time: "+ time*20, 0, base+180, 0);
  beginShape();          
  texture(img);
  vertex(width-(sizeImageItem+offsetImageItem), height-(sizeImageItem+offsetImageItem), blockInHand*sizeTexture*6, 0);  
  vertex(width-(sizeImageItem+offsetImageItem), height-offsetImageItem, blockInHand*sizeTexture*6, sizeTexture);
  vertex(width-offsetImageItem, height-offsetImageItem, blockInHand*sizeTexture*6+sizeTexture, sizeTexture);
  vertex(width-offsetImageItem, height-(sizeImageItem+offsetImageItem), blockInHand*sizeTexture*6+sizeTexture, 0);
  endShape();
  
}

float round(int n, float x)
{
  //This funtion just do a round of a float at n digits after the coma
  int tenPower = 1;
  for(int i = 0; i < n ; i++){tenPower*=10;}
  
  x = (int)(x*tenPower);
  return x/tenPower;
}

void keyPressed(){
  switch(key){
     case ' ' : 
     {
       player.speed.y =  player.spectator ? speed : speed * (maxJumpTime - jumpTime)/maxJumpTime ;  
       isFeetInWater = false;
       isHeadInWater = false;
       break;       
     }
     case 'd' : player.speed.x =  speed;  break;
     case 'q' : player.speed.x = -speed;  break;
     case 's' : player.speed.z = -speed;  break;
     case 'z' : player.speed.z =  speed;  break;
     case 'm' : player.spectator = !player.spectator; break;
  }
  switch (keyCode) {
    // Fleches : LEFT, RIGHT, UP, DOWN
    case LEFT  : player.speed.x = -speed; break;
    case RIGHT : player.speed.x =  speed; break;
    case UP    : player.speed.z =  speed; break;
    case DOWN  : player.speed.z = -speed; break;
    case SHIFT : player.speed.y = -speed; break;
  }
}

void keyReleased()
{
  switch(key){
     case ' ' : player.speed.y = 0;  break;
     case 'd' : player.speed.x = 0;  break;
     case 'q' : player.speed.x = 0;  break;
     case 's' : player.speed.z = 0;  break;
     case 'z' : player.speed.z = 0;  break;
  }
  switch (keyCode) {
    // Fleches : LEFT, RIGHT, UP, DOWN
    case LEFT  : player.speed.x = 0; break;
    case RIGHT : player.speed.x = 0; break;
    case UP    : player.speed.z = 0; break;
    case DOWN  : player.speed.z = 0; break;
    case SHIFT : player.speed.y = 0; break;
  }
}

void mousePressed()
{
  switch(mouseButton)
  {
    case LEFT:
    {
       if (target.x != -1)
       {
            C[int(target.x/sizeChunckXZ)][int(target.z/sizeChunckXZ)].map[int(target.x%sizeChunckXZ)][int(target.y)][int(target.z%sizeChunckXZ)].destroy();
       }
       break;
    }
    case RIGHT:
    {
       if(target.x != -1 && target.y+1 < sizeChunckY)
       {
         C[int(target.x/sizeChunckXZ)][int(target.z/sizeChunckXZ)].map[int(target.x%sizeChunckXZ)][int(target.y)+1][int(target.z%sizeChunckXZ)].changeId(blockInHand);
         C[int(target.x/sizeChunckXZ)][int(target.z/sizeChunckXZ)].map[int(target.x%sizeChunckXZ)][int(target.y)+1][int(target.z%sizeChunckXZ)].refresh();
       }
    }
  } 
}

void mouseWheel(MouseEvent event) {
   if(event.getCount() > 0)blockInHand++;
   else blockInHand--;
   if (blockInHand < 0) blockInHand = nbrBlock -1;
   blockInHand = blockInHand%nbrBlock;
}
