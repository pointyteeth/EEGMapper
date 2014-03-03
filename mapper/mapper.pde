
int screenHeight;
int screenWidth;

float interest = 1; // opacity
float engagement = 1; // size
float stress = 1; // complexity
float relaxation = 1; // curvyness
float excitement = 1; // speed

int hue = 25;

int numGradients = 12;
int[][] gradientParams = new int[numGradients][3]; // a set of gradients with x positions, y positions, and radii

int numPoints = 10;
int[][][] curveCoords = new int[numGradients][numPoints][2]; // a set of points, numPoints per gradient, through which to draw a curve

// BARS CODE 

//Bars bars = new Bars();

int bar_width = 100;
int bar_height = 20;
int bar_fillet = 7;
float space_between_bars = 20;

float[] hues = {41/360.0, 202/360.0, 164/360.0, 56/360.0, 27/360.0, 326/360.0, 100/360.0};
String[] labels = {"Excitement", "Stress", "Engagement", "Relaxation", "Interest", "Focus"};

void drawBars(float[] params) {
     colorMode(HSB, 1.0);

  //float[] params = {a, b, c, d, e};
  rectMode(CORNER);
  ellipseMode(CORNER);
  strokeWeight(1.5);
 
  int x = 20;
  float y = space_between_bars;
  
  for(int i=0; i<5; i++) {
    noFill();
    rect(x, y, bar_width, bar_height, bar_fillet);
    
    float v = params[i];
    if (v < 0.07) {
       v = 0.07; 
    }
    
    fill(hues[i], params[i]/1.5 + 0.5/1.5, (4-params[i])/4.0);
    rect(x, y, bar_width*v, bar_height, bar_fillet);
    
    fill(0);
    text(labels[i], x, y-20);
    y += space_between_bars;
  }
  
  line(x + bar_width + x, 0, x+bar_width+x, displayHeight); 
  
  colorMode(HSB, 100);
  rectMode(CENTER);
  ellipseMode(CENTER);
  strokeWeight(1.0);
}

//

void setup() {
  // set up window
  frameRate(60);
  screenWidth = displayWidth;
  screenHeight = displayHeight;
  // set up graphics
  size(screenWidth, screenHeight);
  colorMode(HSB, 100);
  noStroke();
  ellipseMode(CENTER);
  rectMode(CENTER);
  space_between_bars = (displayHeight - bar_height*6.0)/ 7.0;

  for(int c = 0; c < numGradients; c++) {
    
    // generate initial gradients
    gradientParams[c][0] = (int) random(screenWidth);
    gradientParams[c][1] = (int) random(screenWidth);
    gradientParams[c][2] = (int) random(screenHeight);
    
    // generate initial curve
    for(int p = 0; p < numPoints; p++) {
      curveCoords[c][p][0] = gradientParams[c][0] + ((int) random(map(engagement, 0, 1, 0, gradientParams[c][2])));
      curveCoords[c][p][1] = gradientParams[c][1] + ((int) random(map(engagement, 0, 1, 0, gradientParams[c][2])));
    }
    
  }
}

void draw() {
  fill(100);
  rect(screenWidth/2, screenHeight/2, screenWidth, screenHeight);

  // modify gradients
  if(random(1) < excitement) {
    int changed = (int) random(numGradients);
    gradientParams[changed][0] = (int) random(screenWidth);
    gradientParams[changed][1] = (int) random(screenWidth);
    gradientParams[changed][2] = (int) random(screenHeight);
    
    for(int p = 0; p < numPoints; p++) {
      curveCoords[changed][p][0] = gradientParams[changed][0] + ((int) random(map(engagement, 0, 1, 0, gradientParams[changed][2])));
      curveCoords[changed][p][1] = gradientParams[changed][1] + ((int) random(map(engagement, 0, 1, 0, gradientParams[changed][2])));
    }
  }

  // draw gradients
  for(int c = 0; c < numGradients; c++) {
    drawGradient(color((int) random(hue, hue + 20), map(interest, 0, 1, 0, 100), 100), gradientParams[c][0], gradientParams[c][1], gradientParams[c][2]);
    /*stroke(0);
    ellipse(gradientParams[c][0], gradientParams[c][1], gradientParams[c][2], gradientParams[c][2]);
    noStroke();*/
  }

  // draw curve
  curveTightness(1.0 - relaxation);
  stroke(0);
  strokeWeight(0.5);
  beginShape();
  for(int c = 0; c < numGradients; c++) {
    for(int p = 0; p < map(stress, 0, 1, 1, numPoints); p++) {
      curveVertex(curveCoords[c][p][0], curveCoords[c][p][1]);
      curveVertex(gradientParams[c][0], gradientParams[c][1]);
    }
  }
  endShape();
  noStroke();
  
  float[] params = {excitement, stress, engagement, relaxation, interest};
  drawBars(params);
  //bars.draw();
}

void drawGradient(color c, int x, int y, int radius) {
  fill(c, 1);
  for (int r = 0; r < 100; r++) {
    ellipse(x, y, map(r, 0, 100, 0, radius), map(r, 0, 100, 0, radius));
  }
}

void keyPressed() {
  switch(key) {
    case 'a':
      if (interest - 0.1 > 0) {
        interest -= 0.1;
      }
      println("Interest: " + interest);
      break;
    case 's':
      if (engagement - 0.1 > 0) {
        engagement -= 0.1;
      }
      break;
    case 'd':
      if (stress - 0.1 > 0) {
        stress -= 0.1;
      }
      break;
    case 'f':
      if (relaxation - 0.1 > 0) {
        relaxation -= 0.1;
      }
      break;
    case 'g':
      if (excitement - 0.1 > 0) {
        excitement -= 0.1;
      }
      break;
    case 'q':
      if (interest + 0.1 < 1) {
        interest += 0.1;
      }
      break;
    case 'w':
      if (engagement + 0.1 < 1) {
        engagement += 0.1;
      }
      break;
    case 'e':
      if (stress + 0.1 < 1) {
        stress += 0.1;
      }
      break;
    case 'r':
      if (relaxation + 0.1 < 1) {
        relaxation += 0.1;
      }
      break;
    case 't':
      if (excitement + 0.1 < 1) {
        excitement += 0.1;
      }
      break;
  }
  println("Interest: " + interest + ", Engagement: " + engagement + ", Stress: " + stress + ", Relaxation: " + relaxation + ", Excitement: " + excitement);
}

