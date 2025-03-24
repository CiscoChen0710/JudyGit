#define motor1_1 3
#define motor1_2 4
#define motor2_1 5
#define motor2_2 6

#define trig 13
#define echo 12

long duration;
long cm = 10000;

void setup() {
  pinMode(motor1_1, OUTPUT);
  pinMode(motor1_2, OUTPUT);
  pinMode(motor2_1, OUTPUT);
  pinMode(motor2_2, OUTPUT);

  pinMode(trig, OUTPUT);
  pinMode(echo, INPUT);

  randomSeed(analogRead(A0)); 
  delay(3000);
}

void loop() {
  forward();
  delay(100);
  ultra();

  if (cm < 10) {
    stoprun();
    delay(1000);

    backward();
    delay(1000);

    randomTurn();
  }
}

void forward() {
  digitalWrite(motor1_1, HIGH);
  digitalWrite(motor1_2, LOW);
  digitalWrite(motor2_1, HIGH);
  digitalWrite(motor2_2, LOW);
}

void backward() {
  digitalWrite(motor1_1, LOW);
  digitalWrite(motor1_2, HIGH);
  digitalWrite(motor2_1, LOW);
  digitalWrite(motor2_2, HIGH);
}

void right() {
  digitalWrite(motor1_1, LOW);
  digitalWrite(motor1_2, HIGH);
  digitalWrite(motor2_1, HIGH);
  digitalWrite(motor2_2, LOW);
}

void left() {
  digitalWrite(motor1_1, HIGH);
  digitalWrite(motor1_2, LOW);
  digitalWrite(motor2_1, LOW);
  digitalWrite(motor2_2, HIGH);
}

void stoprun() {
  digitalWrite(motor1_1, LOW);
  digitalWrite(motor1_2, LOW);
  digitalWrite(motor2_1, LOW);
  digitalWrite(motor2_2, LOW);
}

void ultra() {
  digitalWrite(trig, LOW);
  delayMicroseconds(2);

  digitalWrite(trig, HIGH);
  delayMicroseconds(10);

  digitalWrite(trig, LOW);

  duration = pulseIn(echo, HIGH);

  cm = duration / 29 / 2;
}

void randomTurn() {
  int dir = random(0, 2); 

  if (dir == 0) {
    left();
  } else {       
    right();
  }

  delay(1000);
  forward();
}