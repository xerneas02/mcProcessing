class Voxel
{
   /*
   The voxels are the block each one of them is compose by 6 vertexs.
   Each of this vertexs represent a face of the voxel and can be
   activate or desactivate to hode the face that the player can't see.
   Each blocks have an id which represent the type of block it is (grass, dirt, wood...)
   the id -1 represent a block od air.
   Each voxels have a booleant isTarget that tell if the block is targetting by the player.
   They also have a boolean's table showFace that tell which face of the voxel should be draw.
   */
   
   
   private float size;
   private int id;
   private PVector coBlock;
   private PVector coTexture;
   private boolean[] showFace = {true, true, true, true, true, true};
   private boolean isTarget = false;
   private float voxelHeight;
   private boolean ifLiquidIsLiquidOver = false;
   private boolean isLiquid = false;
   
   public void init(float size, float x, float y, float z, int id)
   {
       this.size = size;
       changeId(id);
       coBlock = new PVector(x, y, z);
   }
   
   public void show(boolean[] showFace)
   {
       this.showFace[0] = showFace[0];
       this.showFace[1] = showFace[1];
       this.showFace[2] = showFace[2];
       this.showFace[3] = showFace[3];
       this.showFace[4] = showFace[4];
       this.showFace[5] = showFace[5];
   }
   
   public void isItTarget(boolean istarget)
   {
     this.isTarget = istarget;
   }
   
   public boolean isItLiquid()
   {
      return isLiquid; 
   }
   
   public int getId(){return id;}
   
   public boolean[] getFace(){return showFace;}
   
   public void changeId(int id)
   {
     this.id = id;
     coTexture = new PVector(id*sizeTexture*6, 0);
     if(7 == id) 
     {
       voxelHeight = size-0.1;
       isLiquid = true;
     }
     else
     {
       isLiquid = false;
       voxelHeight = size;
     }
   }
    
   public void setIfLiquidIsLiquidOver(boolean ifLiquidIsLiquidOver)
   {
      this.ifLiquidIsLiquidOver = ifLiquidIsLiquidOver; 
   }
   
   public void display()
   {
     if(id != -1)
     {  
        float offset = ifLiquidIsLiquidOver ?  size : voxelHeight;
        if(this.isTarget) fill(color(100, 100, 100, 100)); //This line is here do dark the block when target by putting on him a Liquid gray
        if (showFace[0])
        {          
          beginShape();          
          texture(img);
          vertex(coBlock.x, coBlock.y+offset, coBlock.z, coTexture.x, coTexture.y);  
          vertex(coBlock.x+size, coBlock.y+offset, coBlock.z, coTexture.x, coTexture.y+sizeTexture);
          vertex(coBlock.x+size, coBlock.y+offset, coBlock.z+size, coTexture.x+sizeTexture, coTexture.y+sizeTexture);
          vertex(coBlock.x, coBlock.y+offset, coBlock.z+size, coTexture.x+sizeTexture, coTexture.y);
          endShape();
        }
        if (showFace[1])
        {
          
          beginShape();
          texture(img);
          vertex(coBlock.x, coBlock.y, coBlock.z, coTexture.x+sizeTexture, coTexture.y+sizeTexture);  
          vertex(coBlock.x+size, coBlock.y, coBlock.z, coTexture.x+sizeTexture*2, coTexture.y+sizeTexture);
          vertex(coBlock.x+size, coBlock.y+offset, coBlock.z, coTexture.x+sizeTexture*2, coTexture.y);
          vertex(coBlock.x, coBlock.y+offset, coBlock.z, coTexture.x+sizeTexture, coTexture.y);
          endShape();
        }
        
        if (showFace[2])
        {
          beginShape();
          texture(img);
          vertex(coBlock.x, coBlock.y, coBlock.z, coTexture.x+sizeTexture*2, coTexture.y+sizeTexture);  
          vertex(coBlock.x, coBlock.y+offset, coBlock.z, coTexture.x+sizeTexture*2, coTexture.y);
          vertex(coBlock.x, coBlock.y+offset, coBlock.z+size, coTexture.x+sizeTexture*3, coTexture.y);
          vertex(coBlock.x, coBlock.y, coBlock.z+size, coTexture.x+sizeTexture*3, coTexture.y+sizeTexture);
          endShape();
        }
        
        if (showFace[3])
        {
          beginShape();
          texture(img);
          vertex(coBlock.x+size, coBlock.y, coBlock.z, coTexture.x+sizeTexture*3, coTexture.y+sizeTexture);  
          vertex(coBlock.x+size, coBlock.y+offset, coBlock.z, coTexture.x+sizeTexture*3, coTexture.y);
          vertex(coBlock.x+size, coBlock.y+offset, coBlock.z+size, coTexture.x+sizeTexture*4, coTexture.y);
          vertex(coBlock.x+size, coBlock.y, coBlock.z+size, coTexture.x+sizeTexture*4, coTexture.y+sizeTexture);
          endShape();
        }
        
        if (showFace[4])
        {
          
          beginShape();
          texture(img);
          vertex(coBlock.x, coBlock.y, coBlock.z+size, coTexture.x+sizeTexture*4, coTexture.y+sizeTexture);  
          vertex(coBlock.x+size, coBlock.y, coBlock.z+size, coTexture.x+sizeTexture*5, coTexture.y+sizeTexture);
          vertex(coBlock.x+size, coBlock.y+offset, coBlock.z+size, coTexture.x+sizeTexture*5, coTexture.y);
          vertex(coBlock.x, coBlock.y+offset, coBlock.z+size, coTexture.x+sizeTexture*4, coTexture.y);
          endShape();
        }
        if (showFace[5])
        {
          
          beginShape();
          texture(img);
          vertex(coBlock.x, coBlock.y, coBlock.z, coTexture.x+sizeTexture*5, coTexture.y);  
          vertex(coBlock.x+size, coBlock.y, coBlock.z, coTexture.x+sizeTexture*6, coTexture.y);
          vertex(coBlock.x+size, coBlock.y, coBlock.z+size, coTexture.x+sizeTexture*6, coTexture.y+sizeTexture);
          vertex(coBlock.x, coBlock.y, coBlock.z+size, coTexture.x+sizeTexture*5, coTexture.y+sizeTexture);
          endShape();
        }
        if(this.isTarget) fill(color(255, 255, 255, 255));
     }
     isTarget = false; //here we reset the boolean isTarget so that we do not let all the block that has been targeted dark
   }
   
   public void destroy()
   {
     /*
     This code destroy a voxel by, if the voxel is destructable or if the player is in spectator, changing his id to -1 
     and show the face of the block around it.
     */
     if(id != 4 || player.spectator)
     {
       int CX = int(coBlock.x/sizeChunckXZ);
       int CZ = int(coBlock.z/sizeChunckXZ);
       int x = int(coBlock.x%sizeChunckXZ);
       int y = int(coBlock.y);
       int z = int(coBlock.z%sizeChunckXZ);
       if(coBlock.y < sizeChunckY-1 && 7 == C[CX][CZ].map[x][y+1][z].getId())
       {
          changeId(7);
          refresh();
          if(y > 0)C[CX][CZ].map[x][y-1][z].setIfLiquidIsLiquidOver(7 == C[CX][CZ].map[x][y-1][z].getId());
       }
       else
       {
          changeId(-1);
       }
        if(coBlock.y > 0 && C[CX][CZ].map[x][y-1][z].getId() != -1)
        {
           boolean[] face = C[CX][CZ].map[x][y-1][z].getFace();
           face[0] = id != C[CX][CZ].map[x][y-1][z].getId();
           C[CX][CZ].map[x][y-1][z].show(face);
        }
        
        if(coBlock.z%sizeChunckXZ < sizeChunckXZ-1 && C[CX][CZ].map[x][y][z+1].getId() != -1)
        {
           boolean[] face = C[CX][CZ].map[x][y][z+1].getFace();
           face[1] = id != C[CX][CZ].map[x][y][z+1].getId();
           C[CX][CZ].map[x][y][z+1].show(face);
        }
        else if (coBlock.z%sizeChunckXZ >= sizeChunckXZ-1 && CZ < nbrChunck-1  && C[CX][CZ+1].map[x][y][0].getId() != -1)
        {
           boolean[] face = C[CX][CZ+1].map[x][y][0].getFace();
           face[1] = id != C[CX][CZ+1].map[x][y][0].getId();
           C[CX][CZ+1].map[x][y][0].show(face);
        }
              
        if(coBlock.x%sizeChunckXZ < sizeChunckXZ-1 && C[CX][CZ].map[x+1][y][z].getId() != -1)
        {
           boolean[] face = C[CX][CZ].map[x+1][y][z].getFace();
           face[2] = id != C[CX][CZ].map[x+1][y][z].getId();
           C[CX][CZ].map[x+1][y][z].show(face);
        }
        else if (coBlock.x%sizeChunckXZ >= sizeChunckXZ-1 && CX < nbrChunck-1 && C[CX+1][CZ].map[0][y][z].getId() != -1)
        {
           boolean[] face = C[CX+1][CZ].map[0][y][z].getFace();
           face[2] = id != C[CX+1][CZ].map[0][y][z].getId();
           C[CX+1][CZ].map[0][y][z].show(face);
        }
        
        if(coBlock.x%sizeChunckXZ > 0 && C[CX][CZ].map[x-1][y][z].getId() != -1)
        {
           boolean[] face = C[CX][CZ].map[x-1][y][z].getFace();
           face[3] = id != C[CX][CZ].map[x-1][y][z].getId();
           C[CX][CZ].map[x-1][y][z].show(face);
        }
        else if (coBlock.x%sizeChunckXZ <= 0 && CX > 0 && C[CX-1][CZ].map[sizeChunckXZ-1][y][z].getId() != -1)
        {
           boolean[] face = C[CX-1][CZ].map[sizeChunckXZ-1][y][z].getFace();
           face[3] = id != C[CX-1][CZ].map[sizeChunckXZ-1][y][z].getId();
           C[CX-1][CZ].map[sizeChunckXZ-1][y][z].show(face);
        }
        
        if(coBlock.z%sizeChunckXZ > 0 && C[CX][CZ].map[x][y][z-1].getId() != -1)
        {
           boolean[] face = C[CX][CZ].map[x][y][z-1].getFace();
           face[4] = id != C[CX][CZ].map[x][y][z-1].getId();
           C[CX][CZ].map[x][y][z-1].show(face);
        }
        else if (coBlock.z%sizeChunckXZ <= 0 && CX > 0 && C[CX][CZ-1].map[x][y][sizeChunckXZ-1].getId() != -1)
        {
           boolean[] face = C[CX][CZ-1].map[x][y][sizeChunckXZ-1].getFace();
           face[4] = id != C[CX][CZ-1].map[x][y][sizeChunckXZ-1].getId();
           C[CX][CZ-1].map[x][y][sizeChunckXZ-1].show(face);
        }
        
        if(coBlock.y < sizeChunckY-1 && C[CX][CZ].map[x][y+1][z].getId() != -1)
        {
           boolean[] face = C[CX][CZ].map[x][y+1][z].getFace();
           face[5] = id != C[CX][CZ].map[x][y+1][z].getId();
           C[CX][CZ].map[x][y+1][z].show(face);
        }
     }
   }
   
   public void refresh()
   {
     /*
     Refresh is called when the voxel is place to look which face of the voxel should and shouldn't be shown
     and hide the face of the block around it.
     */
     
    if(-1 == id) return;
    
    int CX = int(coBlock.x/sizeChunckXZ);
    int CZ = int(coBlock.z/sizeChunckXZ);
    int x = int(coBlock.x%sizeChunckXZ);
    int y = int(coBlock.y);
    int z = int(coBlock.z%sizeChunckXZ);
    showFace[0] = true;
    showFace[1] = true;
    showFace[2] = true;
    showFace[3] = true;
    showFace[4] = true;
    showFace[5] = true;
    ifLiquidIsLiquidOver = false;
    
    if(coBlock.y > 0 && C[CX][CZ].map[x][y-1][z].getId() != -1)
    {
      if((!isLiquid  && !C[CX][CZ].map[x][y-1][z].isItLiquid()) || C[CX][CZ].map[x][y-1][z].getId() == id)
      {
         boolean[] face = C[CX][CZ].map[x][y-1][z].getFace();
         face[0] = false;
         C[CX][CZ].map[x][y-1][z].show(face);
      }
      showFace[5] = isLiquid || !C[CX][CZ].map[x][y-1][z].isItLiquid() ? false : true;
    }
    
    else if(0 == coBlock.y) showFace[5] = false;
    
    if(coBlock.z%sizeChunckXZ < sizeChunckXZ-1 && C[CX][CZ].map[x][y][z+1].getId() != -1)
    {
      if((!isLiquid) || C[CX][CZ].map[x][y][z+1].getId() == id)
      {
         boolean[] face = C[CX][CZ].map[x][y][z+1].getFace();
         face[1] = false;
         C[CX][CZ].map[x][y][z+1].show(face);
      }
      showFace[4] = isLiquid || !C[CX][CZ].map[x][y][z+1].isItLiquid() ? false : true;
    }    
    else if (coBlock.z%sizeChunckXZ >= sizeChunckXZ-1 && CZ < nbrChunck-1  && C[CX][CZ+1].map[x][y][0].getId() != -1)
    {
       if((!isLiquid) || C[CX][CZ+1].map[x][y][0].getId() == id)
       {
         boolean[] face = C[CX][CZ+1].map[x][y][0].getFace();
         face[1] = false;
         C[CX][CZ+1].map[x][y][0].show(face);
       }
       showFace[4] = isLiquid || !C[CX][CZ+1].map[x][y][0].isItLiquid() ? false : true;
    }
          
    if(coBlock.x%sizeChunckXZ < sizeChunckXZ-1 && C[CX][CZ].map[x+1][y][z].getId() != -1)
    {
       if((!isLiquid) || C[CX][CZ].map[x+1][y][z].getId() == id)
       {
         boolean[] face = C[CX][CZ].map[x+1][y][z].getFace();
         face[2] = false;
         C[CX][CZ].map[x+1][y][z].show(face);
       }
       showFace[3] = isLiquid || !C[CX][CZ].map[x+1][y][z].isItLiquid() ? false : true;
    }
    else if (coBlock.x%sizeChunckXZ >= sizeChunckXZ-1 && CX < nbrChunck-1 && C[CX+1][CZ].map[0][y][z].getId() != -1)
    {
      if((!isLiquid) || C[CX+1][CZ].map[0][y][z].getId() == id)
      {
         boolean[] face = C[CX+1][CZ].map[0][y][z].getFace();
         face[2] = false;
         C[CX+1][CZ].map[0][y][z].show(face);
      }
      
      showFace[3] = isLiquid || !C[CX+1][CZ].map[0][y][z].isItLiquid() ? false : true;
    }
    
    if(coBlock.x%sizeChunckXZ > 0 && C[CX][CZ].map[x-1][y][z].getId() != -1)
    {
      if((!isLiquid) || C[CX][CZ].map[x-1][y][z].getId() == id)
      {
         boolean[] face = C[CX][CZ].map[x-1][y][z].getFace();
         face[3] = false;
         C[CX][CZ].map[x-1][y][z].show(face);
      }
      showFace[2] = isLiquid || !C[CX][CZ].map[x-1][y][z].isItLiquid() ? false : true;
    }
    else if (coBlock.x%sizeChunckXZ <= 0 && CX > 0 && C[CX-1][CZ].map[sizeChunckXZ-1][y][z].getId() != -1)
    {
      if((!isLiquid) || C[CX-1][CZ].map[sizeChunckXZ-1][y][z].getId() == id)
      {
         boolean[] face = C[CX-1][CZ].map[sizeChunckXZ-1][y][z].getFace();
         face[3] = false;
         C[CX-1][CZ].map[sizeChunckXZ-1][y][z].show(face);
      }
      showFace[2] = isLiquid || !C[CX-1][CZ].map[sizeChunckXZ-1][y][z].isItLiquid() ? false : true;
    }
    
    if(coBlock.z%sizeChunckXZ > 0 && C[CX][CZ].map[x][y][z-1].getId() != -1)
    {
      if((!isLiquid) || C[CX][CZ].map[x][y][z-1].getId() == id)
      {
         boolean[] face = C[CX][CZ].map[x][y][z-1].getFace();
         face[4] = false;
         C[CX][CZ].map[x][y][z-1].show(face);
      }
      showFace[1] = isLiquid || !C[CX][CZ].map[x][y][z-1].isItLiquid() ? false : true;
    }
    else if (coBlock.z%sizeChunckXZ <= 0 && CX > 0 && C[CX][CZ-1].map[x][y][sizeChunckXZ-1].getId() != -1)
    {
      if((!isLiquid) || C[CX][CZ-1].map[x][y][sizeChunckXZ-1].getId() == id)
      {
         boolean[] face = C[CX][CZ-1].map[x][y][sizeChunckXZ-1].getFace();
         face[4] = false;
        C[CX][CZ-1].map[x][y][sizeChunckXZ-1].show(face);
      }
      showFace[1] = isLiquid || !C[CX][CZ-1].map[x][y][sizeChunckXZ-1].isItLiquid() ? false : true;
    }
    
    if(coBlock.y < sizeChunckY-1 && C[CX][CZ].map[x][y+1][z].getId() != -1)
    {
      if((!isLiquid) || C[CX][CZ].map[x][y+1][z].getId() == id)
      {
         boolean[] face = C[CX][CZ].map[x][y+1][z].getFace();
         face[5] = false;
         C[CX][CZ].map[x][y+1][z].show(face);
         showFace[0] = isLiquid || !C[CX][CZ].map[x][y+1][z].isItLiquid() ? false : true;       
      }
      if(7 == id && 7 == C[CX][CZ].map[x][y+1][z].getId()) ifLiquidIsLiquidOver = true;
    }             
   }
}
