class Car
{
  PVector pos, pointing;
  float camDist, carDist, speed, FOV, rotX, rotZ, theta, l, w;
  PShape car;
  PVector[] points;

  Car()
  {
    pos = new PVector(0, 0, 0);
    pointing = new PVector(1, 0);
    l = 220;
    w = 100;
    camDist = 300;
    carDist = sqrt((l/2*l/2) + (w/2*w/2));
    theta = asin(w/2/carDist);
    points = new PVector[4];

    car = loadShape("car.obj");
    car.scale(60);
    car.rotateX(PI);
    car.rotateY(-HALF_PI);
    car.translate(90,60,0);
  }

  void updateCamera()
  {    
    perspective(PI/FOV, float(width)/height, .01, width * 4);
    camera(pos.x - (pointing.x * camDist), pos.y - camDist/2, pos.z + (pointing.y * camDist), pos.x, pos.y, pos.z, 0, 1, 0);
    //camera(pos.x - cos(frameCount * .01) * camDist, pos.y - camDist/2, pos.z + sin(frameCount * .01) * camDist, pos.x,pos.y,pos.z, 0,1,0);
  }

  void render()
  {
    push();
    translate(pos.x, pos.y, pos.z);
    rotateY(pointing.heading());
    rotateZ(rotZ);
    rotateX(rotX);
    shape(car);
    pop();
  }

  void updateControls()
  {
    //drive
    if (keyDown('W'))
    {
      if (speed < 15)
        speed += .10;
    }

    //slow
    else if (keyDown('S'))
      speed -= .5;
    else
      speed -= .25;
    if (speed < 0)
      speed = 0;
    if (keyDown('A'))
      pointing.rotate(PI/150);
    if (keyDown('D'))
      pointing.rotate(-PI/150);

    pos.x += pointing.x * speed;
    pos.z -= pointing.y * speed;
    pos.y -= rotZ * speed;
    FOV = map(speed, 0, 50, 2.5, 2);
  }


  void updatePoints()
  {
    float point = -pointing.heading();
    points[0] = new PVector(pos.x + cos(point + theta) * carDist, 0, pos.z + sin(point + theta) * carDist);
    points[1] = new PVector(pos.x + cos(point - theta) * carDist, 0, pos.z + sin(point - theta) * carDist);
    points[2] = new PVector(pos.x + cos(point - theta + PI) * carDist, 0, pos.z + sin(point - theta + PI) * carDist);
    points[3] = new PVector(pos.x + cos(point + theta + PI) * carDist, 0, pos.z + sin(point + theta + PI) * carDist);

    float total = 0;
    for (int i = 0; i < 4; i++)
    {
      points[i].y = map(noise(((world.noiseScl * (world.terrainSize/2)) + ((points[i].x/world.scl) * world.noiseScl)), ((world.noiseScl * (world.terrainSize/2)) + ((points[i].z/world.scl) * world.noiseScl))), 0, 1, -400, 400);
      total += points[i].y;
    }

    pos.y = (total / 4) - 10;

    float frontAverage = (points[0].y + points[1].y)/2;
    float backAverage = (points[2].y + points[3].y)/2;
    float zMiddle = (frontAverage + backAverage)/2;
    rotZ = asin((frontAverage - zMiddle)/(l/2));

    float leftAverage = (points[1].y + points[3].y)/2;
    float rightAverage = (points[0].y + points[2].y)/2;
    float xMiddle = (leftAverage + rightAverage)/2;
    rotX = asin((leftAverage  - xMiddle)/(w/2));
  }
}
