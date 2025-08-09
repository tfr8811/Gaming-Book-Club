float[][] field;
int rez = 4;
int cols, rows;
float xOff = 0;
float yOff = 100;
float zOff = 1000;
float increment = 0.05;
float speed = 0.03;
String chosenGame = "";
String[] markdownLines;
float r = 0;
float g = 0;
float b = 0;
void setup() {
  fullScreen();
  //size(1440, 720);
  cols = 1 + width / rez;
  rows = 1 + height / rez;
  field = new float[cols][rows];
  markdownLines = loadStrings("../README.md");
}
void draw() {
  background(0);
  marchingSquares();
  stroke(190);
  strokeWeight(8);
  noFill();
  rect(width/8-8, height/8-8, 6*width/8+16, 6*height/8+16);
  stroke(255);
  fill(r,g,b);
  rect(width/8, height/8, 6*width/8, 6*height/8);
  stroke(190);
  strokeWeight(8);
  noFill();
  rect(width/8+8, height/8+8, 6*width/8-16, 6*height/8-16);
  fill(255);
  textSize(64);
  text("THE CHOSEN GAME IS...", width/5, height/3);

  text(chosenGame, width/5, 2*height/3);
}
void mouseReleased() {
  chosenGame = getChosenGame();
}
String getChosenGame() {
  r = random(0, 127);
  g = random(0, 127);
  b = random(0, 127);
  // the lines at the beginning that don't have games
  int junkLines = 2;
  return markdownLines[floor(random(markdownLines.length-junkLines))+junkLines];
}

void marchingSquares(){
    zOff += speed;
  xOff = 0;
  for (int i = 0; i < cols; i++) {
    xOff += increment;
    yOff = 100;
    for (int j = 0; j < rows; j++) {
      yOff += increment;
      field[i][j] = noise(xOff, yOff, zOff);
    }
  }
  
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      fill(round(field[i][j]) * 255);
      noStroke();
      rect(i*rez, j*rez, rez, rez);
    }
  }
  xOff = 0;
  for (int i = 0; i < cols-1; i++) {
    xOff += increment;
    yOff = 100;
    for (int j = 0; j < rows-1; j++) {
      yOff += increment;
      float x = i * rez;
      float y = j * rez;
      PVector a = new PVector(x + rez * 0.5, y            );
      PVector b = new PVector(x + rez      , y + rez * 0.5);
      PVector c = new PVector(x + rez * 0.5, y + rez      );
      PVector d = new PVector(x            , y + rez * 0.5);
      int state = getState(round(field[i][j]),round(field[i+1][j]),round(field[i+1][j+1]),round(field[i][j+1]));
      stroke(map(noise(xOff), 0, 1, 0, 255), 
             map(noise(yOff), 0, 1, 0, 255),
             map(noise(zOff), 0, 1, 0, 255));
      strokeWeight(8);
      switch(state) {
        case 1:
          line(c, d);
          break;
        case 2:
          line(b, c);
          break;
        case 3:
          line(b, d);
          break;
        case 4:
          line(a, b);
          break;
        case 5:
          line(a, d);
          line(b, c);
          break;
        case 6:
          line(a, c);
          break;
        case 7:
          line(a, d);
          break;
        case 8:
          line(a, d);
          break;
        case 9:
          line(a, c);
          break;
        case 10:
          line(a, b);
          line(c, d);
          break;
        case 11:
          line(a, b);
          break;
        case 12:
          line(b, d);
          break;
        case 13:
          line(b, c);
          break;
        case 14:
          line(c, d);
          break;
      }
    }
  }
}
void line(PVector v1, PVector v2) {
  line(v1.x, v1.y, v2.x, v2.y);
}

int getState(int a, int b, int c, int d) {
  return a * 8 + b * 4 + c * 2 + d * 1;
}
