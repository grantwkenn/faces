class triangleButton
{
  float p1x, p1y, p2x, p2y, p3x, p3y;
  float adjacent;
  color fillColor = 200;
  boolean visible = true;
  
  triangleButton(float x, float y, int size)
  { 
      adjacent = size* cos(PI/6.0);
      p1y = y;
      p1x = p2x = x;
      p2y = y + abs(size);
      p3x = x + adjacent;
      p3y = y + abs(size)/2;
  }
    
  void draw()
  {    
    visible = true;
    checkHover();
    strokeWeight(1);
    noStroke();
    fill(fillColor);
    triangle(p1x, p1y, p2x, p2y, p3x, p3y);
  }
  
  boolean checkHover() //check if mouse hovers within area of the triangle
  {
    if(!visible)
      return false;
    
    if(p3x > p1x) // right facing triangle
    {
      if(mouseX > p1x && mouseX < p3x && mouseY > p1y && mouseY < p2y)
      {
        if((mouseY-p1y > (mouseX-p1x)*((p2y-p1y)/2.0)/adjacent) 
            && (mouseY-p2y < (mouseX-p2x)*((p1y-p2y)/2.0)/adjacent))
        {
          fillColor = buttonPressedColor;
          return true;
        }
      }
      fillColor = buttonColor;
      return false;
    }
    else if(mouseX < p1x && mouseX > p3x && mouseY > p1y && mouseY < p2y)//left facing triangle
      {
        if((mouseY-p3y > (mouseX-p3x)*((p2y-p1y)/2.0)/adjacent) 
            && (mouseY-p2y < (mouseX-p2x)*((p1y-p2y)/2.0)/adjacent))
        {
          fillColor = buttonPressedColor;
          return true;
        }
      }
      fillColor = buttonColor;
      return false;
  }
  
  void hide() { visible = false; }
}
