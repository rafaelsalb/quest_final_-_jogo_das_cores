int pinA = 22;
int pinB = 21;
int pinStart = 23;
int pinVRx = 27;
int pinVRy = 26;
int pinSW = 25;
int pinLDR = 33;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  pinMode(pinA, INPUT_PULLUP);
  pinMode(pinB, INPUT_PULLUP);
  pinMode(pinStart, INPUT_PULLUP);
  pinMode(pinVRx, INPUT_PULLUP);
  pinMode(pinVRy, INPUT_PULLUP);
  pinMode(pinSW, INPUT_PULLUP);
  pinMode(pinLDR, INPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  int a = digitalRead(pinA);
  int b = digitalRead(pinB);
  int start = digitalRead(pinStart);
  int VRx = analogRead(pinVRx);
  int VRy = analogRead(pinVRy);
  int SW = digitalRead(pinSW);
  int LDR = analogRead(pinLDR);

//  Serial.print("A: ");
//  Serial.print(a);
//  Serial.print(" ");
//  Serial.print("B: ");
//  Serial.print(b);
//  Serial.print(" ");
//  Serial.print("START: ");
//  Serial.print(start);
//  Serial.print(" ");
//  Serial.print("VRx: ");
//  Serial.print(VRx);
//  Serial.print(" ");
//  Serial.print("VRy: ");
//  Serial.print(VRy);
//  Serial.print(" ");
//  Serial.print("SW: ");
//  Serial.print(SW);
//  Serial.print(" ");
//  Serial.println();
//  delay(100);

  if (a) {
    Serial.print(0);
  }
  if (b) {
    Serial.print(1);
  }
  if (start) {
    Serial.print(2);
  }
  if (VRx > 100 && VRx < 3996) {
    Serial.print(3);
  }
  if (VRx <= 100) {
    Serial.print(4);
  }
  if (VRx >= 3996) {
    Serial.print(5);
  }
  if (VRy <= 100) {
    Serial.print(6);
  }
  if (VRy >= 3996) {
    Serial.print(7);
  }  
  if (LDR <= 2048) {
    Serial.print(8);
  }
  if (VRy > 100 && VRy < 3996) {
    Serial.print(9);
  }
  Serial.println();
  delay(10);
}
