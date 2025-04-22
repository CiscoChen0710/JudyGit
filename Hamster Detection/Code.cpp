#include <LiquidCrystal.h>

LiquidCrystal lcd(10, 11, 8, 12, 13, 2);

const int trigPin = 7;    
const int echoPin = 6;   
const int lightSensorPin = A0; 

const int redPin = 3;     
const int greenPin = 4;   
const int bluePin = 5;     

const int buzzerPin = 9;   

long duration;
int distance;
int lightLevel;
bool hamsterRunning = false;
bool hamsterEating = false;

void setup() {
    Serial.begin(9600);  
    lcd.begin(16, 2);   
    lcd.print("Hamster DJ Ready!");

    pinMode(trigPin, OUTPUT);
    pinMode(echoPin, INPUT);
    pinMode(lightSensorPin, INPUT);

    pinMode(redPin, OUTPUT);
    pinMode(greenPin, OUTPUT);
    pinMode(bluePin, OUTPUT);
    pinMode(buzzerPin, OUTPUT);
}

void loop() {
    digitalWrite(trigPin, LOW);
    delayMicroseconds(2);
    digitalWrite(trigPin, HIGH);
    delayMicroseconds(10);
    digitalWrite(trigPin, LOW);
    duration = pulseIn(echoPin, HIGH);
    distance = duration * 0.034 / 2;  

    lightLevel = analogRead(lightSensorPin);

    hamsterRunning = (distance < 10);  
    hamsterEating = (lightLevel < 400); 
    if (hamsterRunning) {
        playRunningEffect();
    } else if (hamsterEating) {
        playEatingEffect();
    } else {
        playIdleEffect();
    }

    delay(500);
}

void playRunningEffect() {
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("Hamster Running!");
    lcd.setCursor(0, 1);
    lcd.print("DJ Mode: ON");

    tone(buzzerPin, 1000, 200);

    for (int i = 0; i < 3; i++) {
        digitalWrite(redPin, HIGH);
        digitalWrite(greenPin, LOW);
        digitalWrite(bluePin, LOW);
        delay(200);
        digitalWrite(redPin, LOW);
        digitalWrite(greenPin, HIGH);
        digitalWrite(bluePin, LOW);
        delay(200);
    }
}

void playEatingEffect() {
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("Hamster Eating...");
    lcd.setCursor(0, 1);
    lcd.print("Enjoy your food!");

    digitalWrite(redPin, LOW);
    digitalWrite(greenPin, HIGH);
    digitalWrite(bluePin, LOW);
    tone(buzzerPin, 600, 100);
}

void playIdleEffect() {
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("Hamster Resting");
    lcd.setCursor(0, 1);
    lcd.print("Zzz...");

    digitalWrite(redPin, LOW);
    digitalWrite(greenPin, LOW);
    digitalWrite(bluePin, HIGH);
    noTone(buzzerPin);
}
