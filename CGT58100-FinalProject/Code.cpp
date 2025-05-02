#define motor1_1 3
#define motor1_2 4
#define motor2_1 5
#define motor2_2 6

#define ENA 9
#define ENB 10

int speedPWM = 120;

void setup() {
  pinMode(motor1_1, OUTPUT);
  pinMode(motor1_2, OUTPUT);
  pinMode(motor2_1, OUTPUT);
  pinMode(motor2_2, OUTPUT);
  
  pinMode(ENA, OUTPUT);
  pinMode(ENB, OUTPUT);
}

void loop() {
  analogWrite(ENA, speedPWM); 
  analogWrite(ENB, speedPWM); 
  
  digitalWrite(motor1_1, HIGH);
  digitalWrite(motor1_2, LOW);
  digitalWrite(motor2_1, HIGH);
  digitalWrite(motor2_2, LOW);
}