boolean[] keys = new boolean[256];
World world;
Car car;

//TRY TO FIGURE OUT HOW TO WALK AROUND AND ONLY STORE ONE GIANT MESH

void setup()
{
  fullScreen(P3D);
  frameRate(300);
  shapeMode(CENTER);
  textAlign(CENTER);
  noCursor();
  noStroke();
  noiseSeed(42069);

  world = new World();
  car = new Car();
  car.updatePoints();
}

void draw()
{
  background(#1BC1BD);
  //lights();
  //ambientLight(200,50,50);
  
  car.updateCamera();
  world.render();
  car.render();
  car.updateControls();
  car.updatePoints();
  
  push();
  camera();
  ortho();
  hint(DISABLE_DEPTH_TEST);
  fill(0);
  text(frameRate, width/2,height* .01);
  hint(ENABLE_DEPTH_TEST);
  pop();
}
