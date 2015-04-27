int tWidth = 800;
int tHeight = 600;
int tRed = 255;

void setup(){
colorMode(RGB);
size(tWidth,tHeight);
background(0);
smooth();
}

void draw(){
fill(tRed,0,0,15);
rect(0, 0, tWidth,tHeight);
fill(255);
ellipse(mouseX, mouseY, 25,25);
}

void changeBGColor(int tValue){
tRed = tValue;
}
