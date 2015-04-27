/* @pjs preload="butterflies_350x458.jpg"; */

PImage input;       // Source image
PImage output;  // Destination image
//PImage output;  // Destination image
int gutter_size = 300;
int frame_size = 20;
int startcont = 2; 

void setup() {
  //size(700+(2*frame_size)+gutter_size, 400+(2*frame_size)+gutter_size); 
  // 700+(2*20)+300, 400+2*20+300 = 1040, 740
  size(1040, 740);
  //size(800,400); 
  input = loadImage("butterflies_350x458.jpg");
  // Create an empty image with same dimensions as source
  output = createImage(input.width, input.height, RGB);
}

void draw() {  
  background(255);
  fill(0); 
  //image(input,0,0); 
  input.updatePixels();
}


