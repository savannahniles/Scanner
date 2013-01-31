//Processing libraries
import hypermedia.video.*;
import java.awt.*;
import processing.opengl.*;
//Arduino libraries
import processing.serial.*;
import cc.arduino.*;

//Blob detection declarations
OpenCV opencv;
boolean find=true;
int threshold = 86;
//arduino declarations
Arduino arduino;
int ledPin = 10;

//window
int w = 320*2;
int h = 240*2;
//ellipse depth reference in room
float disWallX = 3; //distance to the wall on the imaginary x-axis
float disWallY = 6; //distance to the wall ont he imaginary y-axis

//to write data to text file
PrintWriter output;

//needed for labeling text file
int sec = second();
String secStr = Integer.toString(sec); 
int minu = minute();
String minuStr = Integer.toString(minu); 
int hr = hour(); 
String hrStr = Integer.toString(hr); 
int dy = day();
String dyStr = Integer.toString(dy); 
int mnth = month();
String mnthStr = Integer.toString(mnth); 

////////////////////////////////////////////////////////////
void setup() {

  size (w, h, OPENGL);
  background(255);

  //blob detection-- grabbing camera
  opencv = new OpenCV( this );
  opencv.capture(w, h, 0);  //zero = webcam

  //Arduino control
  arduino = new Arduino(this, Arduino.list()[0], 57600);
  arduino.pinMode(ledPin, Arduino.OUTPUT);

  //Output XYZ point data to sketch file
  output = createWriter("place" + mnthStr + "-" + dyStr + "-" + hrStr + "-" 
    + minuStr + "-" + secStr + ".txt");
}

////////////////////////////////////////////////////////////

void draw() {

  //background (255, 70);
  opencv.read();  //read camera
  opencv.threshold(threshold);  //set threshhold
  Blob[] blobs = opencv.blobs( 100, w*h/3, 20, true ); //array of blob objects

  //increment x arbitraily-- fix with Arduino
  // x++;
  //x = width/5000 to fit in screen
  //should be moving.072 degrees per miliscecond

  //for every blob...
  for ( int i=0; i<blobs.length; i++ ) {
    float area = blobs[i].area; //area for each blob
    float circumference = blobs[i].length; //circumerence for each blob
    Point centroid = blobs[i].centroid; //center point for each blob
    Point[] points = blobs[i].points; //perimeter points for each blob

    stroke(0);
    if ( points.length>0 ) {
      for ( int j=0; j<points.length; j++) {
        if (points[j].x < centroid.x) {
          float x = sqrt(disWallX*disWallX + points[j].x*points[j].x/disWallY/disWallY);
          println (x);

          point( x, points[j].y, -points[j].x);
          output.println(x + "," + points[j].y + "," + -points[j].x); // Write the coordinate to the file
        }
      }
    }
  }
  //Arduino control
  for (int a = 0; a<1; a++) {
    arduino.digitalWrite(ledPin, Arduino.HIGH);
    delay(5000);
    arduino.digitalWrite(ledPin, Arduino.LOW);
    output.flush(); // Writes the remaining data to the file
    output.close(); // Finishes the file
    exit();
  }
}


//---------------------------------------------------------------
//---------------------------------------------------------------
//---------------------------------------------------------------
void keyPressed() {
  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
  exit(); // Stops the program
}
//---------------------------------------------------------------

public void stop() {
  opencv.stop();
  super.stop();
}

