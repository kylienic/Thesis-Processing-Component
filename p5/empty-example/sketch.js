var input;       // Source image
var output;  // Destination image
var gutter_size = 300;
var frame_size = 20;
var startcont = 2; 
var brightSlider, contSlider; 


function preload(){
input = loadImage("butterflies_350x458.jpg");
}

function setup() {
  // put setup code here
  createCanvas(1040, 400);
  background(255);
  fill(0);
  output = createImage(input.width, input.height, RGB);
  image(input,20,18);// frame_size-2 b/c it just looked better
  brightSlider = createSlider(-255, 255, 0);
  brightSlider.position(600, 500);
  contSlider = createSlider(0, 100, 50);
  contSlider.position(300, 500);
}

function draw() {
//get slider values
  var slideBright = brightSlider.value();
  var slideCont = contSlider.value()/50; 

  processFunction(input, output, slideCont, slideBright);

  //image(input, 0,0);
  image(input,20,18);// frame_size-2 b/c it just looked better
  text("original", 458, 0+18+350+15);
  image(output,483+2*20,18); // frame_size-2 b/c it just looked better
  text("processed", 0+2*20+2*458-10, 0+20-2+350+15);
  //input.updatePixels();
  output.updatePixels();
  }

function processFunction(input2, output2, cont, bright2) 
  { 
   //we assume the images are of equal dimension 
   //so test this here and if it's not true just return with a warning
   if(input2.width !=output2.width || input2.height != output2.height)
   {
     println("error: image dimensions must agree");
     return;
   }
   
  //loop through source pixels 
  for (var x = 0; x < input2.width; x++) {
    for (var y = 0; y < input2.height; y++ ) {
      // calculate pixel location
      var loc = x + y*input2.width;
      //BRIGHTNESS
      //float bright = 255 * ( 2*mouseY / (float)width - 1); // change so range from black to white
      //var inColor = color(input2.pixels[loc]);
      //var inColor = color(input2.pixels[loc]);
      
      var r = red(input2.pixels[loc]);
      var g = green(input2.pixels[loc]);
      var b = blue(input2.pixels[loc]);

       //here the much faster version (uses bit-shifting) courtesy of dr.mo: http://forum.processing.org/one/topic/increase-contrast-of-an-image.html
       //var r = (inColor >> 16) & 0xFF; //like calling the function red(), but faster
       //var g = (inColor >> 8) & 0xFF;
       //var b = inColor & 0xFF;     
      
      // brightness is linear arithmetic
      // contrast is multiplication, but normalize brightness we first subtract 128, multiply, then add back in. 
      // default brightness: 0
      // default contrast: 1
      r = (int)((r-128)*cont +128 + bright2); //floating point aritmetic so convert back to int with a cast (i.e. '(int)');
      g = (int)((g-128)*cont +128 + bright2);
      b = (int)((b-128)*cont +128 + bright2);
      
      /*
      // experiment with not adding back in 128 --> IAIP just subtract 100 don't add back in
      r = (int)((r-100)*cont + bright2); //floating point aritmetic so convert back to int with a cast (i.e. '(int)');
      g = (int)((g-100)*cont + bright2);
      b = (int)((b-100)*cont + bright2);*/
      
      r = r < 0 ? 0 : r > 255 ? 255 : r;
      g = g < 0 ? 0 : g > 255 ? 255 : g;
      b = b < 0 ? 0 : b > 255 ? 255 : b;
      
      //output.pixels[loc] = color(r,g,b);
      output.pixels[loc]= 0xff000000 | (r << 16) | (g << 8) | b; //this does the same but faster; again, courtesy of dr.mo
    }
  }
 }

