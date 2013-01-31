#include <AFMotor.h>

AF_DCMotor motor(2, MOTOR12_64KHZ); // create motor #2, 64KHz pwm

void setup() {
  Serial.begin(9600);           // set up Serial library at 9600 bps
  Serial.println("Motor test!");
  
  motor.setSpeed(150);     // set the speed to 200/255
}

void loop() {
  Serial.println("tick");
  
  motor.run(FORWARD);      // turn it on going forward
 // delay(1000);

 // Serial.println("tock");
 // motor.run(BACKWARD);     // the other way
 // delay(1000);
  
 // Serial.println("tack");
 // motor.run(RELEASE);      // stopped
 // delay(1000);
}

