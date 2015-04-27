/* @pjs preload="butterflies_350x458.jpg"; */

PImage input;       // Source image

void setup() {
  size(800,800);
  input = loadImage("butterflies_350x458.jpg");
}

void draw() {  
  background(0,255,0);
  image(input,0,0); 
}
