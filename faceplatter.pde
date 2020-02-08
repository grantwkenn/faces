class FacePlate
{
  PImage currentFace;
  PImage[] faces; 
  float angle = 0.00;
  float angularVelocity = 0.0;
  float angularAcceleration = 0.0;
  float knobX, knobY;
  int faceIndex;
  
  int centerX, centerY;
  
  boolean hover = false;
  boolean dragging = false;
  boolean retracting = false;
  boolean idle = true;
  
  
  FacePlate(PImage[] faces, int x, int y, int faceIndex)
  {
    this.faces = faces;
    this.faceIndex = faceIndex;
    centerX = x; centerY = y;
  }
  
  void update()
  {
    currentFace = faces[faceIndex]; //needed?
    
      //draw the knob
      knobX = centerX + knobDist*cos(angle-PI/2);
      knobY = centerY + knobDist*sin(angle-PI/2);
      checkKnobHover();
      fill(knobColor);
      ellipse(knobX, knobY, knobRadius, knobRadius);
    
    // wheel accelerates back to origin
      if (angle > 0)
      {
        angularAcceleration = -0.001;
      }
      else if(angle < 0)
        angularAcceleration = 0.001;
        
      if(this.dragging)
        spinFace();
      else if (!idle)
      {
        //friction slows the wheel down
        if(abs(angle) < 0.5)
          angularVelocity = 0.92*angularVelocity;
      
        if(abs(angularVelocity) < 0.004 && abs(angle) < 0.004)
        {
          angularVelocity = 0.00;
          angle = 0.00;
          this.idle = true;
        }
          
        
        //update angle according to acceleration & velocity
        angularVelocity += angularAcceleration;
        angle += angularVelocity;
      }
  }
  
  void draw()
  {
    pushMatrix();
    translate(centerX, centerY);
    rotate(angle);
    image(currentFace, -250, -250, 500, 500);
    popMatrix();
  }
  
boolean checkKnobHover() //check the mouse hovers the rotation knob
{
  if(sqrt(sq(mouseX-knobX)+ sq(mouseY-knobY)) < knobRadius)
  {
     knobColor = buttonPressedColor;
     return true;
  }
  else
  {
    knobColor = buttonColor;
    return false;
  }
}


void toggleDragging(boolean value)
{
  dragging = value;
}


void spinFace() //wheel follows user input
{
  idle = false;
  
  prevButton.hide();
  nextButton.hide();
  
  float mouseAngle;
  float opposite, adjacent;
  opposite = mouseY-centerY;
  adjacent = mouseX-centerX;
  
  //calculate angle according to mouse position  
  if(adjacent != 0.0) // dont divide by zero
    mouseAngle = atan(opposite/adjacent);
  
  else if (opposite > 0)
  {       
    mouseAngle = PI/2;
  }
  else
    mouseAngle = -PI/2;
  
  if(opposite < 0)
  {
    if(adjacent < 0) mouseAngle -= PI; //Q3
  }
  else
  {
     if(adjacent < 0) mouseAngle -= PI; //Q2
  } 
  //adjust the origin
  angle = mouseAngle + PI/2;
}

boolean checkIdle()
{
  return idle;
}

void updateFaceIndex(int index)
{
  faceIndex = index;
}

void arrest()
{
  angularVelocity = 0.00;
  angularAcceleration = 0.00;
  //angle = 0.00;
}

}
