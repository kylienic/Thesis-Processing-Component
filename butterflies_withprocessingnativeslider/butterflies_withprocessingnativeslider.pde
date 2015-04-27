/* @pjs preload="butterflies_350x458.jpg"; */

PImage input;       // Source image
PImage output;  // Destination image
//PImage output;  // Destination image
int gutter_size = 300;
int frame_size = 20;
int startcont = 2; 
float gbrightness=0;
float gcontrast=1; 
HSlider Hslider;
int sliderxpos = 10;
int sliderypos =500;
int sliderwidth = 250;
int sliderheight = 16;

void setup() {
  //size(700+(2*frame_size)+gutter_size, 400+(2*frame_size)+gutter_size); 
  // 700+(2*20)+300, 400+2*20+300 = 1040, 740
  //size(1040, 740);
  size(1040, 600);
  //size(800,400); 
  input = loadImage("butterflies_350x458.jpg");
  // Create an empty image with same dimensions as source
  output = createImage(input.width, input.height, RGB);
  
  // The Sliders (or sliders) and buttons array initialization
  Hslider = new HSlider(sliderxpos, sliderypos, sliderwidth, sliderheight); // x, y, width, height
  
  // Set initial slider values
  Hslider.setValue(0); 
  
}

void draw() {  
  background(255);
  fill(0); 
 
   // write the slider value
  text("Brightness:"+Hslider.getValue(), sliderxpos+sliderwidth+4, sliderypos+13);
  
  //update and display slider
  Hslider.update();
  Hslider.display();
 
  //image(input,0,0);
  gcontrast = Hslider.getValue();
  gbrightness = 0; 
 
  //2. call output function with values calculated by other functions
  processFunction(input, output, gcontrast, gbrightness);
 
  //3. DISPLAY IMAGE 
  input.updatePixels();
  output.updatePixels();
  image(input,0+frame_size,0+frame_size-2);// frame_size-2 b/c it just looked better
  fill(0);
  text("original", 0+frame_size+458-20, 0+frame_size-2+350+15);
  image(output,input.width+2*frame_size,0+frame_size-2); // frame_size-2 b/c it just looked better
  text("processed", 0+2*frame_size+2*458-10, 0+frame_size-2+350+15);
}

void processFunction(PImage input2, PImage output2, float gcont, float gbright){
  
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
            
      // restricts values to between 0 and 255
      r = r < 0 ? 0 : r > 255 ? 255 : r;
      g = g < 0 ? 0 : g > 255 ? 255 : g;
      b = b < 0 ? 0 : b > 255 ? 255 : b;
      
      //output.pixels[loc] = color(r,g,b);
      output.pixels[loc]= 0xff000000 | (r << 16) | (g << 8) | b; //this does the same but faster; again, courtesy of dr.mo
    }
  }
 }
 
 /**  Slider and Button classes
 
 Based on http://forum.processing.org/topic/vertical-scrollbar#25080000001583409
 By "raron"
 
 Made JS-safe by renaming "over()" function, which can't be the same as boolean variable "over"
 
 Built on Topics/GUI/Scrollbar example in processing 1.2.1 (and 1.5.1).
 
 */
 class ColorScheme {

  color bar_outline = color(0, 0, 0);
  color slider_fill  = color(100, 100, 100);
  color bar_hover = color(100, 200, 200);
  color bar_background = color(0, 150, 200);
  color slider_press = color(255, 255, 255);
}
/* global colorscheme, change colors above */
/* to change instance colors, subclass and overwrite */
ColorScheme global_cs = new ColorScheme();

class VSlider
{
  int barWidth, barHeight; // width and height of bar. NOTE: barWidth also used as slider button height.
  int Xpos, Ypos;          // upper-left position of bar
  float Spos, newSpos;     // y (upper) position of slider
  int SposMin, SposMax;    // max and min values of slider
  boolean over;            // True if hovering over the Slider
  boolean locked;          // True if a mouse button is pressed while on the Slider
  int roundRad = 5;             // radius of rounded rectangle for thumb

  ColorScheme cs = global_cs;
  color barOutlineCol  = cs.bar_outline;
  color barFillCol     = cs.bar_background;
  color sliderFillCol  = cs.slider_fill;
  color barHoverCol    = cs.bar_hover;
  color sliderPressCol = cs.slider_press;


  VSlider (int X_start, int Y_start, int bar_width, int bar_height) {
    barWidth = bar_width;
    barHeight = bar_height;

    Xpos = X_start;
    Ypos = Y_start;
    Spos = Ypos + barHeight/2 - barWidth/2; // center it initially
    newSpos = Spos;
    SposMin = Ypos;
    SposMax = Ypos + barHeight - barWidth;
  }

  void update() {
    over = overit();
    if (mousePressed && over) locked = true; 
    else locked = false;

    if (locked) {
      newSpos = constrain(mouseY-barWidth/2, SposMin, SposMax);
    }
    Spos = newSpos;
  }

  // Return true if mouse is over thumb of slider
  boolean overit() {
    if (mouseX > Xpos && mouseX < Xpos+barWidth &&
      mouseY > Ypos && mouseY < Ypos+barHeight) {
      return true;
    } 
    else {
      return false;
    }
  }


  void display() {
    stroke(barOutlineCol);
    fill(barFillCol);
    rect(Xpos, Ypos, barWidth, barHeight);
    if (over) {
      fill(barHoverCol);
    }
    if (locked) {
      fill(sliderPressCol);
    }
    if (!over && !locked) {
      fill (sliderFillCol);
    }
    if (abs(Spos-newSpos)>0.1) fill (sliderPressCol);
    rect(Xpos, Spos, barWidth, barWidth,roundRad);
  }

  float getValue() {
    // Convert slider position Spos to a value between 0 and 1
    return (Spos-Ypos) / (barHeight-barWidth);
  }

  // set the value of this slider
  void setValue(float value) {
    // convert a value (0 to 1) to slider position Spos
    if (value<0) value=0.0;
    if (value>100) value=100.0;
    Spos = Ypos + ((barHeight-barWidth)*value);
    newSpos = Spos;
  }
}


class HSlider extends VSlider {
  HSlider(int X_start, int Y_start, int bar_width, int bar_height) {
    super(X_start, Y_start, bar_width, bar_height);
    SposMin = Xpos;
    SposMax = Xpos - barHeight + barWidth;
  }

  // call this to interactively update slider in display()
  void update() {
    over = overit();
    if (mousePressed && over) locked = true; 
    else locked = false;

    if (locked) {
      //newSpos = constrain(mouseX- int(barHeight/2), SposMin, SposMax);
      //newSpos = mouseX - int(barHeight/2);
      newSpos = constrain(mouseX - int(barHeight/2), SposMin, SposMax);
    }
    Spos = newSpos;
  }

  // Call this to draw the slider in display() routine
  void display() {
    stroke(barOutlineCol);
    fill(barFillCol);
    // Draw the slider bar
    rect(Xpos, Ypos, barWidth, barHeight);
    if (over) {
      fill(barHoverCol);
    }
    if (locked) {
      fill(sliderPressCol);
    }
    if (!over && !locked) {
      fill (sliderFillCol);
    }
    // Draw the thumb
    if (abs(Spos-newSpos)>0.1) fill (sliderPressCol);
    rect(Spos, Ypos, barHeight, barHeight,roundRad);
  }

  float getValue() {
    // Convert slider position Spos to a value between 0 and 1
    return (Spos-Xpos) / (barWidth - barHeight);
  }

  // set the value of this slider
  void setValue(float value) {
    // convert a value (0 to 1) to slider position Spos
    //if (value<0) value=0.0;
    //if (value>1) value=1.0;
    if (value<0) value=0.0;
    if (value>100) value=100.0;
    // this ^ did nothing to alter the range. 
    Spos = Xpos + ((barWidth-barHeight)*value);
    newSpos = Spos;
  }
}

 


