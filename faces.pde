// Upside Down Faces
// Grant Kennedy
// September 22, 2019

PImage face, circle;
PImage[] faces;

int faceIndex = 0;
int centerX, centerY;
int knobRadius = 75;

float angle = 0.0;
float angularVelocity = 0.0;
float angularAcceleration = 0.0;
float knobX, knobY;
float knobDist = 310;

boolean hover = false;
boolean dragging = false;
boolean retracting = false;

color buttonColor = 80, buttonPressedColor = 180, knobColor;

triangleButton nextButton, prevButton;


void setup()
{
  size(1920, 1080);
  background(30);
  centerX = width/2;
  centerY = height/2;
  knobX = centerX;
  knobY = centerY - knobDist;
  faces = new PImage[4];
  
  // load jpegs from data folder into array
  //exceptions not handled
  faces[0] = loadImage("ed.jpg");
  faces[1] = loadImage("hermione.jpg");
  faces[2] = loadImage("cage.jpg");  
  faces[3] = loadImage("tulsi.jpg");
  circle = loadImage("circle.jpg");

  //mask images into circles
  faces[0].mask(circle);
  faces[1].mask(circle);  
  faces[2].mask(circle);
  faces[3].mask(circle);
  face = faces[faceIndex];
  
  nextButton = new triangleButton(centerX + 350, height*(3/4.0), 75); 
  prevButton = new triangleButton(centerX-350, height*(3/4.0), -75);
}


void draw()
{ 
  background(30);
  face = faces[faceIndex];
  
  //draw the image at the current angle
  pushMatrix();
  translate(centerX, centerY);
  rotate(angle);
  image(face, -250, -250, face.width/2, face.height/2);
  popMatrix();  
  
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
    
  if(dragging)
    rotate();
  else
  {
    //friction slows the wheel down
    if(abs(angle) < 0.5)
      angularVelocity = 0.92*angularVelocity;
  
    if(abs(angularVelocity) < 0.004 && abs(angle) < 0.004)
      stop();
    
    //update angle according to acceleration & velocity
    angularVelocity += angularAcceleration;
    angle += angularVelocity;
  }
  
  //hide buttons when wheel is moving
  if(angle == 0.00)
  {
    nextButton.draw();
    prevButton.draw();    
  }
}


void rotate() //wheel follows user input
{
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

void mousePressed()
{
  if (checkKnobHover())
  {
    dragging = true;
    stop();
  }
  if(nextButton.checkHover())
  {
    faceIndex = (faceIndex + 1) % 4;
  }
  else if(prevButton.checkHover())
  {
    faceIndex--;
    if(faceIndex < 0)
      faceIndex = 3;
  }

}

void mouseReleased()
{
  dragging = false;
}

void stop() //stop the wheel at origin
{
  angularVelocity = 0.00;
  angularAcceleration = 0.00;
  angle = 0.00;
}

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
  
  boolean checkHover() //check mouse hovers within area of the triangle
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
