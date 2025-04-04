#include <ESP32Servo.h>  // 安装 ESP32Servo 库

Servo servo1;  // 创建舵机对象1
Servo servo2;  // 创建舵机对象2

const int servoPin1 = 15; // 舵机1连接的GPIO
const int servoPin2 = 2;  // 舵机2连接的GPIO

void setup() {
    Serial.begin(115200);
    servo1.attach(servoPin1);  // 绑定舵机1
    servo2.attach(servoPin2);  // 绑定舵机2
    initializeServos(); // 初始化舵机位置
}

void loop() {
    openBook(); // 打开书
    delay(1000); // 等待1秒
    closeBook(); // 关闭书
    delay(1000); // 等待1秒
}

// 初始化舵机位置
void initializeServos() {
    servo1.write(0);
    servo2.write(180);
    delay(1000);
}

// 打开书
void openBook() {
    Serial.println("Opening the book...");
    moveServos(0, 180, 10, 500); // 从0°到180°，每次增加10°，延时500ms
    Serial.println("Book is open!");
}

// 关闭书
void closeBook() {
    Serial.println("Closing the book...");
    moveServos(180, 0, -10, 500); // 从180°到0°，每次减少10°，延时500ms
    Serial.println("Book is closed!");
}

// 控制舵机运动
void moveServos(int startAngle, int endAngle, int step, int delayTime) {
    if (step > 0) {
        // 正向旋转
        for (int angle = startAngle; angle <= endAngle; angle += step) {
            int reversedAngle = 180 - angle;  // 反向旋转
            setServoAngles(angle, reversedAngle);
            delay(delayTime);
        }
    } else {
        // 反向旋转
        for (int angle = startAngle; angle >= endAngle; angle += step) {
            int reversedAngle = 180 - angle;  // 反向旋转
            setServoAngles(angle, reversedAngle);
            delay(delayTime);
        }
    }
}

// 设置舵机角度
void setServoAngles(int angle1, int angle2) {
    Serial.print("Servo1 angle: ");
    Serial.print(angle1);
    Serial.print(" | Servo2 angle: ");
    Serial.println(angle2);

    servo1.write(angle1);
    servo2.write(angle2);
}