class World
{
  HashMap<String, Chunk> chunks;
  float noiseScl = .015;
  int size = 1920;
  int scl = 30;
  int terrainSize = (size/scl) + 1;
  int renderDist = 1;

  public World()
  {
    chunks = new HashMap<String, Chunk>();

    for (int i = -renderDist; i <= renderDist; i++)
    {
      for (int j = -renderDist; j <= renderDist; j++)
      {
        chunks.put(cordString(i, j), new Chunk(i, j));
      }
    }
  }

  //renders 9 chunks including current and all adjecent chunks
  void render()
  {
    for (String cord : chunks.keySet())
      chunks.get(cord).render();
  }

  //formats into string for hash map
  String cordString(int x, int z)
  {
    return x + "x" + z;
  }

  class Chunk
  {
    int x, z;
    float noiseX, noiseZ;
    float[][] terrain;

    Chunk(int x, int z)
    {
      
      terrain = new float[terrainSize][terrainSize];
      noiseX = x * (noiseScl * (terrainSize-1));
      noiseZ = z * (noiseScl * (terrainSize-1));
      this.x = x * size;
      this.z = z * size;

      //Sets terrain for chunk
      for (int row = 0; row < terrainSize; row++)
      {
        noiseX = x * (noiseScl * (terrainSize-1));
        for (int col = 0; col < terrainSize; col++)
        {
          terrain[row][col] = map(noise(noiseX, noiseZ), 0, 1, -400, 400);
          noiseX += noiseScl;
        }
        noiseZ += noiseScl;
      }
    }

    //Draws everything in chunk
    void render()
    {
      //Render ground terrain
      shapeMode(NORMAL);
      push();
      translate(x - size/2, 0, z - size/2);
      for (int row = 0; row < terrainSize-1; row++)
      {
        beginShape(TRIANGLE_STRIP);
        for (int col = 0; col < terrainSize; col++)
        {
          fill(map(terrain[row][col], -200, 200, 255, 50));
          noStroke();
          vertex(col*scl, terrain[row][col], row*scl);
          vertex(col*scl, terrain[row+1][col], (row+1)*scl);
        }
        endShape();
      }
      pop();
      shapeMode(CENTER);
    }
  }
}
