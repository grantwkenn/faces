class Arrow
{
  int innerRadius, outerRadius;
  PShape arrow;
  boolean visible = false;
  int alpha = 0, fadeValue = 1, fadeMultiplier = 1;
  int minAlpha = -60, maxAlpha = 40;
  int arrowVertices = 25;
  int arrowWidth = 30;
  float arcLength = PI/4, minArcLength = 0.5*(PI/2), maxArcLength= 0.85*(PI/2);
  float startAngle = -(0.85)*PI/2, endAngle;
  
  Arrow()
  {
      innerRadius = 295; //knobDist
      outerRadius = 325;
  }
  
  PShape arrowShape()
{
  PShape arrow = createShape();
  arrow.beginShape();
  
  // SET FILL /  alpha
  if (visible)
    arrow.fill(255, alpha);
  else
    arrow.noFill();
  
  float x=0, y=0;


  
  //arrow.vertex(x,y); 

  
      for(float i=0; i<=arrowVertices; i++) // inner curve sweeps down!
  {
    x = innerRadius*cos(startAngle+((i/arrowVertices)*arcLength));
    y = innerRadius*sin(startAngle+(i/arrowVertices*arcLength));
    arrow.vertex(x,y);
  }
  //draw pointed arrow portion
  /*
  x += 20;
  arrow.vertex(x,y);
  x -= 35;
  y += 50;
  arrow.vertex(x,y);
  y -= 50;
  x -= 35;
  arrow.vertex(x,y);
  
  x = 130*cos(-PI/2); 
  y = 130*sin(-PI/2); */
  
  x = (innerRadius-20)*cos(startAngle+arcLength);
  y = (innerRadius-20)*sin(startAngle+arcLength);
  arrow.vertex(x,y);
  x = ((outerRadius+innerRadius)/2)*cos(startAngle+arcLength);
  y = ((outerRadius+innerRadius)/2)*sin(startAngle+arcLength);
  x = x - 50*sin(startAngle+minArcLength);
  y = y+ 50*cos(startAngle+minArcLength);

  arrow.vertex(x,y);
  x = (outerRadius+20)*cos(startAngle+arcLength);
  y = (outerRadius+20)*sin(startAngle+arcLength);
  arrow.vertex(x,y);
  
  for(float i=arrowVertices; i>=0; i--)  //outer curve sweeps up!
  {
    x = outerRadius*cos(startAngle+(i/arrowVertices*arcLength));
    y = outerRadius*sin(startAngle+(i/arrowVertices*arcLength));
    arrow.vertex(x,y);
  }
  
  arrow.endShape();
  return arrow;
}

void setVisible(boolean value)
{
  visible = value;
  alpha = minAlpha;
}

boolean isVisible()
{
  return visible;  
}

void update()
{
  alpha += (fadeValue*fadeMultiplier);
  if (alpha > maxAlpha || alpha < minAlpha)
    fadeValue = -1*fadeValue;
  
}

PShape drawArrow()
{
  return arrowShape();
}

  
}
