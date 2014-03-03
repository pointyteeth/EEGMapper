class Bars {

int bar_width = 100;
int bar_height = 20;
int bar_fillet = 7;
float space_between_bars = (displayHeight - bar_height*6.0)/ 7.0;

float[] hues = {41/360.0, 202/360.0, 164/360.0, 56/360.0, 27/360.0, 326/360.0, 100/360.0};
String[] labels = {"Excitement", "Stress", "Engagement", "Relaxation", "Interest", "Focus"};

void drawBars(float[] params) {
  stroke(0);
  //float[] params = {a, b, c, d, e};
  
  strokeWeight(1.5);
 
  int x = 20;
  float y = space_between_bars;
  
  for(int i=0; i<6; i++) {
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
  noStroke();
}

float delta = 0.01;

void controls(float[] params) {
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

float[] params = {0.5, 0.3, 0.8, 0.9, 0.2, 0.7};

void draw() {
  background(1.0);
  drawBars(params);
}

void keyPressed() {
  controls(params);
}

}
