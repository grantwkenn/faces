// Upside Down Faces
// Grant Kennedy
// September 22, 2019

PImage face_mod, face_unmod, circle;
PImage[] modified_faces, unmodified_faces;

int numFaces = 7;

int faceIndex = 0;
int centerX, centerY;
int XLeft, XRight;
int knobRadius = 75;

int faderCounter=0;
float xfade, yfade;

Arrow hintArrow;

float angle = 0.0;
float angularVelocity = 0.0;
float angularAcceleration = 0.0;
float knobX, knobY;
int knobDist = 310;

boolean hover = false;
boolean dragging = false;
boolean retracting = false;

boolean programIdle = true;
int timeIdle;

color buttonColor = 80, buttonPressedColor = 180, knobColor;
color bgColor = 15;

triangleButton nextButton, prevButton;

color indicatorShade = 0;

FacePlate modified, unmodified;


void setup()
{
  size(1920, 1080);
  background(bgColor);
  centerX = width/2;
  centerY = height/2;
  XLeft = width/4;
  XRight = 3*width/4;
  knobX = centerX;
  knobY = centerY - knobDist;
  modified_faces = new PImage[numFaces];
  unmodified_faces = new PImage[numFaces];
  
  // load jpegs from data folder into array
  //exceptions not handled
  modified_faces[0] = loadImage("modified/aoc_mod.png");
  modified_faces[1] = loadImage("modified/pelosi_mod.jpg"); 
  modified_faces[2] = loadImage("modified/harris_mod.png");  
  modified_faces[3] = loadImage("modified/ed_mod.png");
  modified_faces[4] = loadImage("modified/warren_mod.png");
  modified_faces[5] = loadImage("modified/menendez_mod.png");
  modified_faces[6] = loadImage("modified/rubio_mod.png");
  
  unmodified_faces[0] = loadImage("unmodified/aoc_unmod.png");
  unmodified_faces[1] = loadImage("unmodified/pelosi_unmod.jpg"); 
  unmodified_faces[2] = loadImage("unmodified/harris_unmod.png");  
  unmodified_faces[3] = loadImage("unmodified/ed_unmod.png");
  unmodified_faces[4] = loadImage("unmodified/warren_unmod.png");
  unmodified_faces[5] = loadImage("unmodified/menendez_unmod.png");
  unmodified_faces[6] = loadImage("unmodified/rubio_unmod.png");
  circle = loadImage("circle.jpg");

  //mask images into circles
  for(int i=0; i<numFaces; i++)
  {
    modified_faces[i].mask(circle);
    unmodified_faces[i].mask(circle);
  }

  face_mod = modified_faces[faceIndex];
  
  nextButton = new triangleButton(width*0.85, height*(0.85), 75); 
  prevButton = new triangleButton(width*0.15, height*(0.85), -75);
  
  hintArrow = new Arrow();
  
  unmodified = new FacePlate(unmodified_faces, XRight, centerY, faceIndex);
  modified = new FacePlate(modified_faces, XLeft, centerY, faceIndex);
  
  timeIdle = millis();
}


void draw()
{ 
  background(bgColor);
  
  unmodified.update();
  unmodified.draw();
  modified.update();
  modified.draw();
  

  
  
  if(programIdle)
  {
    nextButton.draw();
    prevButton.draw();
    
    if (millis()-timeIdle > 3000 && (!hintArrow.isVisible())) //after 3 secs program idle
    {
      hintArrow.setVisible(true);
    }
    
    if(hintArrow.isVisible())
    {
      hintArrow.update();
      shape(hintArrow.drawArrow(), XLeft, centerY);
    }
      
  }
  else if (hintArrow.isVisible())
     hintArrow.setVisible(false);
     
  if(!programIdle && unmodified.checkIdle() && modified.checkIdle())
  {
    programIdle = true;
    timeIdle = millis();
    nextButton.draw();
    prevButton.draw();
  }
    
}


void mousePressed()
{
  if (unmodified.checkKnobHover())
  {
    unmodified.toggleDragging(true);
    programIdle = false;
    unmodified.arrest();
  }
  if (modified.checkKnobHover())
  {
    modified.toggleDragging(true);
    programIdle = false;
    modified.arrest();
  }
  if(nextButton.checkHover())
  {
    faceIndex = (faceIndex + 1) % numFaces;
    updateFaceIndex(faceIndex); 
    //timeIdle = millis();
    programIdle = false;
  }
  else if(prevButton.checkHover())
  {
    faceIndex--;
    if(faceIndex < 0)
      faceIndex = numFaces-1;
    updateFaceIndex(faceIndex); 
    programIdle = false;
  }

}

void mouseReleased()
{
  unmodified.toggleDragging(false);
  modified.toggleDragging(false);
}



void updateFaceIndex(int index)
{
  modified.updateFaceIndex(index);
  unmodified.updateFaceIndex(index);
}
