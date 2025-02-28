#include <ESP32Servo.h>  // 安装 ESP32Servo 库

Servo servo1;  // 创建舵机对象1
Servo servo2;  // 创建舵机对象2

const int servoPin1 = 15; // 舵机1连接的GPIO
const int servoPin2 = 2;  // 舵机2连接的GPIO

void setup() {
    Serial.begin(115200);
    servo1.attach(servoPin1);  // 绑定舵机1
    servo2.attach(servoPin2);  // 绑定舵机2
    servo1.write(0);
    servo2.write(180);
    delay(1000);
}

void loop() {
    for (int angle = 0; angle <= 180; angle += 10) {
        int reversedAngle = 180 - angle;  // 反向旋转

        Serial.print("Servo1 angle: ");
        Serial.print(angle);
        Serial.print(" | Servo2 angle: ");
        Serial.println(reversedAngle);

        servo1.write(angle);
        servo2.write(reversedAngle);
        delay(500);
    }

    for (int angle = 180; angle >= 0; angle -= 10) {
        int reversedAngle = 180 - angle;  // 反向旋转

        Serial.print("Servo1 angle: ");
        Serial.print(angle);
        Serial.print(" | Servo2 angle: ");
        Serial.println(reversedAngle);

        servo1.write(angle);
        servo2.write(reversedAngle);
        delay(500);
    }
}
