import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class mapper extends PApplet {


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

Bars bars = new Bars();

public void setup() {
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

public void draw() {
  
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
  curveTightness(1.0f - relaxation);
  stroke(0);
  strokeWeight(0.5f);
  beginShape();
  for(int c = 0; c < numGradients; c++) {
    for(int p = 0; p < map(stress, 0, 1, 1, numPoints); p++) {
      curveVertex(curveCoords[c][p][0], curveCoords[c][p][1]);
    }
  }
  endShape();
  noStroke();
  
  //bars.draw();
}

public void drawGradient(int c, int x, int y, int radius) {
  fill(c, 1);
  for (int r = 0; r < 100; r++) {
    ellipse(x, y, map(r, 0, 100, 0, radius), map(r, 0, 100, 0, radius));
  }
}

public void keyPressed() {
  switch(key) {
    case 'a':
      if (interest - 0.1f > 0) {
        interest -= 0.1f;
      }
      println("Interest: " + interest);
      break;
    case 's':
      if (engagement - 0.1f > 0) {
        engagement -= 0.1f;
      }
      break;
    case 'd':
      if (stress - 0.1f > 0) {
        stress -= 0.1f;
      }
      break;
    case 'f':
      if (relaxation - 0.1f > 0) {
        relaxation -= 0.1f;
      }
      break;
    case 'g':
      if (excitement - 0.1f > 0) {
        excitement -= 0.1f;
      }
      break;
    case 'q':
      if (interest + 0.1f < 1) {
        interest += 0.1f;
      }
      break;
    case 'w':
      if (engagement + 0.1f < 1) {
        engagement += 0.1f;
      }
      break;
    case 'e':
      if (stress + 0.1f < 1) {
        stress += 0.1f;
      }
      break;
    case 'r':
      if (relaxation + 0.1f < 1) {
        relaxation += 0.1f;
      }
      break;
    case 't':
      if (excitement + 0.1f < 1) {
        excitement += 0.1f;
      }
      break;
  }
  println("Interest: " + interest + ", Engagement: " + engagement + ", Stress: " + stress + ", Relaxation: " + relaxation + ", Excitement: " + excitement);
}

class Bars {

int bar_width = 100;
int bar_height = 20;
int bar_fillet = 7;
float space_between_bars = (displayHeight - bar_height*6.0f)/ 7.0f;

float[] hues = {41/360.0f, 202/360.0f, 164/360.0f, 56/360.0f, 27/360.0f, 326/360.0f, 100/360.0f};
String[] labels = {"Excitement", "Stress", "Engagement", "Relaxation", "Interest", "Focus"};

public void drawBars(float[] params) {
  stroke(0);
  //float[] params = {a, b, c, d, e};
  
  strokeWeight(1.5f);
 
  int x = 20;
  float y = space_between_bars;
  
  for(int i=0; i<6; i++) {
    noFill();
    rect(x, y, bar_width, bar_height, bar_fillet);
    
    float v = params[i];
    if (v < 0.07f) {
       v = 0.07f; 
    }
    
    fill(hues[i], params[i]/1.5f + 0.5f/1.5f, (4-params[i])/4.0f);
    rect(x, y, bar_width*v, bar_height, bar_fillet);
    
    fill(0);
    text(labels[i], x, y-20);
    y += space_between_bars;
  }
  
  line(x + bar_width + x, 0, x+bar_width+x, displayHeight); 
  noStroke();
}

float delta = 0.01f;

public void controls(float[] params) {
    switch(key) {
       case 'q': params[0] += delta; break;
       case 'w': params[1] += delta; break;
       case 'e': params[2] += delta; break;
       case 'r': params[3] += delta; break;
       case 't': params[4] += delta; break;
       case 'y': params[5] += delta; break;
       
       case 'a': params[0] -= delta; break;
       case 's': params[1] -= delta; break;
       case 'd': params[2] -= delta; break;
       case 'f': params[3] -= delta; break;
       case 'g': params[4] -= delta; break;
       case 'h': params[5] -= delta; break;
    }
    
    for(int i=0; i<5; i+=1) {
       if (params[i] < 0) {
          params[i] = 0;;
       } else if(params[i] > 1) {
          params[i] = 1; 
       }
    }
}

float[] params = {0.5f, 0.3f, 0.8f, 0.9f, 0.2f, 0.7f};

public void draw() {
  background(1.0f);
  drawBars(params);
}

public void keyPressed() {
  controls(params);
}

}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--full-screen", "--bgcolor=#666666", "--stop-color=#cccccc", "mapper" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
