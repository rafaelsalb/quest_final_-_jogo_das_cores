int pinVRx = 0;
int pinVRy = 1;
int pinA = 7;
int pinB = 4;

void setup() {
  // put your setup code here, to run once:
  pinMode(pinVRx, INPUT_PULLUP);
  pinMode(pinVRy, INPUT_PULLUP);
  pinMode(pinA, INPUT);
  pinMode(pinB, INPUT);
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  int VRx = analogRead(pinVRx);
  int VRy = analogRead(pinVRy);
  int a = digitalRead(pinA);
  int b = digitalRead(pinB);

  if (a)
  {
    Serial.print(0);
  }
  if (b)
  {
    Serial.print(1);    
  }
  if (VRx > 100 && VRx < 924) {
    Serial.print(3);
  }
  if (VRx <= 100) {
    Serial.print(4);
  }
  if (VRx >= 924) {
    Serial.print(5);
  }
  if (VRy <= 100) {
    Serial.print(6);
  }
  if (VRy >= 924) {
    Serial.print(7);
  }
  if (VRy > 100 && VRy < 924) {
    Serial.print(9);
  }  
  

  // if (vrx > 100 && vrx < 924) {
  //   Serial.print(3);
  // }
  // if (vrx <= 100) {
  //   Serial.print(4);
  // }
  // if (vrx >= 924) {
  //   Serial.print(5);
  // }
  Serial.println();
  delay(20);
}
