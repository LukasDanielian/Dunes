//Key down
void keyPressed()
{
  if (keyCode >= 0 && keyCode < 256)
    keys[keyCode] = true;
}

//Key up
void keyReleased() 
{
  if (keyCode >= 0 && keyCode < 256)
    keys[keyCode] = false;
}

//Grabs key
boolean keyDown(int key) 
{
  return keys[key];
}
