/* @pjs preload="butterflies.jpg"; */

PImage myFace;

// Size of each cell in the grid, ratio of window size to video size
//int pixelWidth = 1;
int pixelWidth = 1;
// Number of columns and rows in our system
int cols, rows;
int time = millis();
int state = 0;
int kCounter =0;
//smallest clickable pixel is 100/8=125 pixels pixel width = 8. 
//color[] pixelColors = new int[11312];

void setup(){
  size(1000,724);
  //size(534, 800); 
  //myFace = loadImage("butterflies.jpg"); 
  //myFace = loadImage("myface-bigger.png");
  myFace = loadImage("butterflies.jpg"); 
  frameRate(0.75);
    image(myFace, 0, 0);
}

void draw(){
  background(0);
    
    myFace.loadPixels();
    displayPixels();

  /*
  image(myFace, 0, 0);
  myFace.loadPixels();
  displayPixels();
  */
  //if(time % 5000 == 0) 
    //displayPixels();
  
}

void displayPixels(){
  kCounter=0; 
  cols = int(width/pixelWidth);
  rows = int(height/pixelWidth);
  
 
  //image(myFace, 0, 0); 
  //myFace.resize(0, 1000);

// Begin loop for columns
  for (int i = 0; i < cols; i++) {
    // Begin loop for rows
    //kCounter++;
    for (int j = 0; j < rows; j++) {
      
      // Where are we, pixel-wise?
      int x = i*pixelWidth;
      int y = j*pixelWidth;
      int loc = x+y*myFace.width;
      int numX = int(myFace.width/ pixelWidth);
      int numY = int(myFace.height / pixelWidth);
      int numPixels = numX * numY; 
      // Looking up the appropriate color in the pixel array
      color c = myFace.pixels[loc];
      fill(c);
     // int r= (int) red(myFace.pixels[x+y*myFace.width]);
      //int g= (int) blue(myFace.pixels[x+y*myFace.width]);
      //int b= (int) green(myFace.pixels[x+y*myFace.width]);
       int r = (c >> 16) & 0xFF; //like calling the function red(), but faster
       int g = (c >> 8) & 0xFF;
       int b = c & 0xFF; 
      //println(r + ", " + g + ", " + b);
      //text(r + ", " + g + ", " + b, x, y);
      noStroke();
      // this draws the pixel. I wonder if I could re-write this code with the pixel as an object? I probably could. 
      // OR i could make an array of pixels? I need to be able to access each & its location in order to do hover effects. 
      rect(x,y,pixelWidth,pixelWidth);
      if(pixelWidth >= 8){
       
        //pixelColors[kCounter]=c;  
       
      }
      //kCounter++;
    }
  }
}

// returns 1 or -1 depending on direction
void keyPressed() {
  
  /*if(keyCode==UP){
   pixelWidth=100;
   displayPixels(); 
  }
  */
//println(delta);
if(keyCode==UP){
  if(pixelWidth >=1){
    if(pixelWidth < 10)
      pixelWidth = pixelWidth+1; 
    else if(pixelWidth < 120)
      pixelWidth = pixelWidth + 10;
    else if(pixelWidth < 200)
      pixelWidth = pixelWidth + 20;
    else 
      pixelWidth = 200;
  }
 else 
  pixelWidth =1;
}
else if(keyCode==DOWN){
  if (pixelWidth >= 1){
    if(pixelWidth < 10)
      pixelWidth = pixelWidth-1; 
    else if(pixelWidth < 120)
      pixelWidth = pixelWidth - 10;
    else if(pixelWidth < 200)
      pixelWidth = pixelWidth - 20;
     else if(pixelWidth >= 200)
      pixelWidth = 200;
  }
  else
    pixelWidth=0; 
}
displayPixels();
println(pixelWidth);
}

void mouseClicked(){
  // if user clicks on a pixel
  // user can click once pixelWidth = 30
  int loc = int((mouseX+mouseY)/pixelWidth);
  fill(pixelColors[loc]); 
  ellipse(200,200,200,200);
    //display pixel information for this pixel 
}
