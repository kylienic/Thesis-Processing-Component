/* @pjs preload="butterflies_350x458.jpg"; */

PImage input;       // Source image
PImage output;  // Destination image
//PImage output;  // Destination image
int gutter_size = 300;
int frame_size = 20;
int startcont = 2; 
float gbrightness=0.00;
int gcontrast=1; 

void setup() {
  //size(700+(2*frame_size)+gutter_size, 400+(2*frame_size)+gutter_size); 
  // 700+(2*20)+300, 400+2*20+300 = 1040, 740
  //size(1040, 740);
  size(1040, 400);
  //size(800,400); 
  input = loadImage("butterflies_350x458.jpg");
  // Create an empty image with same dimensions as source
  output = createImage(input.width, input.height, RGB);
  textSize(12); 
}

void draw() {  
  background(255);
  fill(0); 
 
  //image(input,0,0);
 
  //2. call output function with values calculated by other functions
  processFunction(input, output, gcontrast, gbrightness);
 
  //3. DISPLAY IMAGE 
  input.updatePixels();
  output.updatePixels();
  image(input,0+frame_size,0+frame_size-2);// frame_size-2 b/c it just looked better
  text("original", 0+frame_size+458-20, 0+frame_size-2+350+15);
  image(output,input.width+2*frame_size,0+frame_size-2); // frame_size-2 b/c it just looked better
  text("processed", 0+2*frame_size+2*458-10, 0+frame_size-2+350+15);
}

void changeBrightness(float tbrightness){
  // have to force brightness to be an integer in order for algorithm to work
 gbrightness=(tbrightness/50)*50; 
 println(gbrightness);
}

void changeContrast(int tcontrast){
  gcontrast=(int)tcontrast/50; 
  println(gcontrast);
}

void processFunction(PImage input2, PImage output2, int gcont, float gbright){
  
//we assume the images are of equal dimension 
   //so test this here and if it's not true just return with a warning
   if(input2.width !=output2.width || input2.height != output2.height)
   {
     println("error: image dimensions must agree");
     return;
   }
   
  //loop through source pixels 
  for (int x = 0; x < input2.width; x++) {
    for (int y = 0; y < input2.height; y++ ) {
      // calculate pixel location
      int loc = x + y*input2.width;
      //BRIGHTNESS
      //float bright = 255 * ( 2*mouseY / (float)width - 1); // change so range from black to white
      color inColor = input2.pixels[loc];
      
      //int r = (int) red(input2.pixels[loc]);
      //int g = (int) green(input2.pixels[loc]);
      //int b = (int) blue(input2.pixels[loc]);
      
        //here the much faster version (uses bit-shifting) courtesy of dr.mo: http://forum.processing.org/one/topic/increase-contrast-of-an-image.html
       int r = (inColor >> 16) & 0xFF; //like calling the function red(), but faster
       int g = (inColor >> 8) & 0xFF;
       int b = inColor & 0xFF;      
      
      // brightness is linear arithmetic
      // contrast is multiplication, but normalize brightness we first subtract 128, multiply, then add back in. 
      // default brightness: 0
      // default contrast: 1
      r = (int)(((r-128)*gcont +128) + gbright); //floating point aritmetic so convert back to int with a cast (i.e. '(int)');
      g = (int)(((g-128)*gcont +128) + gbright);
      b = (int)(((b-128)*gcont +128) + gbright);
      
      //r = (int)(r + 50*gcont); //floating point aritmetic so convert back to int with a cast (i.e. '(int)');
      //g = (int)(g + 50*gcont);
      //b = (int)(b + 50*gcont);
            
      // restricts values to between 0 and 255
      r = r < 0 ? 0 : r > 255 ? 255 : r;
      g = g < 0 ? 0 : g > 255 ? 255 : g;
      b = b < 0 ? 0 : b > 255 ? 255 : b;
      
      //output.pixels[loc] = color(r,g,b);
      output.pixels[loc]= 0xff000000 | (r << 16) | (g << 8) | b; //this does the same but faster; again, courtesy of dr.mo
    }
  }
 }
 


