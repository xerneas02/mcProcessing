class Chunck
{
   /* 
   Each chunck is 3D area in wich there are a set number of voxel. 
   A chunck has its map which is a 3D table of voxels.
   It know the chunck who are around it if they exist.
   And has 2 boolean that tell if its generate and if its load.
   */ 
   public Voxel[][][] map = new Voxel[sizeChunckXZ][sizeChunckY][sizeChunckXZ];
   public Chunck[] voisin = new Chunck[4];
   public boolean isGenerate = false;
   public boolean isFaceShow = false;
   public boolean drawn = false;
   private int x;
   private int z;
   
   public void generate(int x, int z)
   {
      /*
      This function init all the voxel in the chunck and give them there id.
      To do so I used perlin noise to have random terain that look organic
      
      */
      this.x = x;
      this.z = z;
      float xoff = 0.0;
      int blockGroundLevel;
      float increment = 0.02;
      int id;
      
      for(int i = 0; i < map.length; i++) 
      {
        xoff = increment*(i+x*sizeChunckXZ);
        float yoff = 0.0;
        for(int k = 0; k < map[i][0].length; k++)
        {
          yoff = increment*(k+z*sizeChunckXZ);
          for(int j = 0; j < map[i].length; j++)
          {
             blockGroundLevel = minGroundLevel-1 + int(noise(xoff, yoff)*(maxGroundLevel-minGroundLevel));
             id = 1 + int(j < blockGroundLevel-1) + int(j < blockGroundLevel - 4) + int(j == 0);
             if(j >= blockGroundLevel)
             {
               id = -1;
               if(seaLevel >= j) id = 7;
             }
             if(blockGroundLevel <= seaLevel+1 && (1 == id || 2 == id)) id = 8;
             map[i][j][k] = new Voxel();
             map[i][j][k].init(sizeBlock, sizeBlock*i+x*sizeChunckXZ, sizeBlock*j, sizeBlock*k+z*sizeChunckXZ, id);
          }
        }
     }
   }
   
   public void generateATree(int xTree, int zTree)
   {
      /*
      This function place a tree at the coordinate x and z.
      This tree has a random height and width.
      */
      int widthTree = (int)random(minWidthTree, maxWidthTree+1);
      for(int i = 0; i < sizeChunckY ; i++)
      {
         if (map[xTree][i][zTree].id == -1 || map[xTree][i][zTree].id == 6 || map[xTree][i][zTree].id == 5)
         { 
           if(i > 0 && !map[xTree][i-1][zTree].isItLiquid())
           {
                int heightTree = (int) random(minimumHeightTree, maxHeightTree+1);
                for(int j = i ; j < heightTree+i; j++)
                {
                  for(int k = 0 ; k < widthTree; k++)
                  {
                    for(int m = 0 ; m < widthTree; m++)
                    {
                       C[(xTree+k+(x*sizeChunckXZ))/sizeChunckXZ][(zTree+m+(z*sizeChunckXZ))/sizeChunckXZ].map[(xTree+k)%8][j][(zTree+m)%8].init(sizeBlock, sizeBlock*(xTree+k)+x*sizeChunckXZ, sizeBlock*j, sizeBlock*(zTree+m)+z*sizeChunckXZ, 5);
                       C[(xTree+k+(x*sizeChunckXZ))/sizeChunckXZ][(zTree+m+(z*sizeChunckXZ))/sizeChunckXZ].map[(xTree+k)%8][j][(zTree+m)%8].refresh();
                    }
                  }
                }
                for(int j = i+heightTree-3 ; j < i+heightTree+1 ; j++)
                {
                  for(int k = xTree-distLeaveFromTree ; k <= xTree+distLeaveFromTree+widthTree/2 ; k++)
                  {
                    for(int m = zTree-distLeaveFromTree ; m <= zTree+distLeaveFromTree+widthTree/2 ; m++)
                    {
                        if((((k != xTree-distLeaveFromTree || m != zTree-distLeaveFromTree)  && (k != xTree+distLeaveFromTree+widthTree/2 || m != zTree-distLeaveFromTree) && (k != xTree+distLeaveFromTree+widthTree/2 || m != zTree+distLeaveFromTree+widthTree/2) && (k != xTree-distLeaveFromTree || m != zTree+distLeaveFromTree+widthTree/2) && (k != xTree-distLeaveFromTree || j < heightTree+i) && (m != zTree-distLeaveFromTree || j < heightTree+i) && (k != xTree+distLeaveFromTree+widthTree/2 || j < heightTree+i) && (m != zTree+distLeaveFromTree+widthTree/2 || j < heightTree+i) && (k != xTree-distLeaveFromTree || j < heightTree+i-1 || m <= zTree+widthTree/2 && m >= zTree) && (k != xTree+distLeaveFromTree+widthTree/2 || j < heightTree+i-1 || m <= zTree+widthTree/2 && m >= zTree) && (m != zTree-distLeaveFromTree || j < heightTree+i-1 || k <= xTree+widthTree/2 && k >= xTree) && (m != zTree+distLeaveFromTree+widthTree/2 || j < heightTree+i-1 || k <= xTree+widthTree/2 && k >= xTree) && (k != xTree-1 || j < heightTree+i || m <= zTree+widthTree/2 && m >= zTree) && (k != xTree+widthTree || j < heightTree+i || m <= zTree+widthTree/2 && m >= zTree) && (m != zTree-1 || j < heightTree+i || k <= xTree+widthTree/2 && k >= xTree) && (m != zTree+widthTree || j < heightTree+i || k <= xTree+widthTree/2 && k >= xTree))) && C[(k+(x*sizeChunckXZ))/sizeChunckXZ][(m+(z*sizeChunckXZ))/sizeChunckXZ].map[k >= 0 ? k%sizeChunckXZ : 8+k][j][m >= 0 ? m%sizeChunckXZ : 8+m].getId() == -1) // 
                        {
                          C[(k+(x*sizeChunckXZ))/sizeChunckXZ][(m+(z*sizeChunckXZ))/sizeChunckXZ].map[k >= 0 ? k%sizeChunckXZ : 8+k][j][m >= 0 ? m%sizeChunckXZ : 8+m].init(sizeBlock, sizeBlock*k+x*sizeChunckXZ, sizeBlock*j, sizeBlock*m+z*sizeChunckXZ, 6);
                          C[(k+(x*sizeChunckXZ))/sizeChunckXZ][(m+(z*sizeChunckXZ))/sizeChunckXZ].map[k >= 0 ? k%sizeChunckXZ : 8+k][j][m >= 0 ? m%sizeChunckXZ : 8+m].refresh(); 
                        }
                    }
                  }
                }
           }
           return; 
         }
      }
   }
   
   public void generateStructure()
   {
     /*
     This function is here to add the structure like the tree
     in the world.
     */
     for(int i = 0 ; i < map.length; i++)
     {
        for(int k = 0 ; k < map[i][0].length; k++)
        {
          int tree = (int)random(0, recurenceTree);
          
          if(1 == tree) 
          {
            generateATree(i, k);
          }       
        }
     }     
   }
   
   public void draw()
   {
      for(int i =0; i < map.length; i++) 
      {
        for(int j = 0 ; j < map[i].length ; j++) 
        {
           for(int k = 0; k < map[i][j].length ; k++) 
           {
             map[i][j][k].display();
           }
        }
      } 
   }
   
  public void initShowFace()
  {
    for(int i = 0; i < map.length; i++) 
    {
      for(int j = 0; j < map[i].length; j++)
      {
        for(int k = 0; k < map[i][j].length; k++)
        {
          whichFace(i, j, k);
        }
      }
    }
    generateStructure();
  }
  
  void whichFace(int i, int j, int k)
  {
    /*
    This Function look for each block if he has neighbor to hide its face that aren't visible.    
    */
    boolean[] showFace = {true, true, true, true, true, true};
    if((i == 0 && voisin[0] == null) || (i == 0 && voisin[0].map[sizeChunckXZ-1][j][k].getId() != -1 && (!voisin[0].map[sizeChunckXZ-1][j][k].isItLiquid() || voisin[0].map[sizeChunckXZ-1][j][k].getId() == map[i][j][k].getId())) || (i > 0 && map[i-1][j][k].getId() != -1 && (!map[i-1][j][k].isItLiquid() || map[i-1][j][k].getId() == map[i][j][k].getId()))) showFace[2] = false;
    if((i == map.length-1 && voisin[1] == null) || (i == map.length-1 && voisin[1].map[0][j][k].getId() != -1  && (!voisin[1].map[0][j][k].isItLiquid() || voisin[1].map[0][j][k].getId() == map[i][j][k].getId())) || (i < map.length-1 && map[i+1][j][k].getId() != -1 && (!map[i+1][j][k].isItLiquid() || map[i+1][j][k].getId() == map[i][j][k].getId()))) showFace[3] = false;
    
    if((k == 0 && voisin[2] == null) || (k == 0 && voisin[2].map[i][j][sizeChunckXZ-1].getId() != -1 && (!voisin[2].map[i][j][sizeChunckXZ-1].isItLiquid() || voisin[2].map[i][j][sizeChunckXZ-1].getId() == map[i][j][k].getId())) || (k > 0 && map[i][j][k-1].getId() != -1 && (!map[i][j][k-1].isItLiquid() || map[i][j][k-1].getId() == map[i][j][k].getId()))) showFace[1] = false;
    if((k == map.length-1 && voisin[3] == null) || (k == map.length-1 && voisin[3].map[i][j][0].getId() != -1 && (!voisin[3].map[i][j][0].isItLiquid() || voisin[3].map[i][j][0].getId() == map[i][j][k].getId())) || (k < map.length-1 && map[i][j][k+1].getId() != -1 && (!map[i][j][k+1].isItLiquid() || map[i][j][k+1].getId() == map[i][j][k].getId()))) showFace[4] = false;
    
    if(j == 0 || map[i][j-1][k].getId() != -1 && (!map[i][j-1][k].isItLiquid() || map[i][j-1][k].getId() == map[i][j][k].getId())) showFace[5] = false;
    if(j < map[i].length-1 && map[i][j+1][k].getId() != -1 && ((!map[i][j+1][k].isItLiquid() && !map[i][j][k].isItLiquid()) || map[i][j+1][k].getId() == map[i][j][k].getId())) showFace[0] = false;
    map[i][j][k].show(showFace);
    
    if(j < sizeChunckY-1 && map[i][j][k].isItLiquid() &&  map[i][j+1][k].getId() == map[i][j][k].getId()) map[i][j][k].setIfLiquidIsLiquidOver(true);
  }
  
  void clear()
  {
    voisin = null;
    for(int i = 0; i < map.length; i++) 
      {
        for(int k = 0; k < map[i][0].length; k++)
        {
          for(int j = 0; j < map[i].length; j++)
          {
            map[i][j][k] = null;
          }
        }
      }
     map = null;    
  }
}
