#ifndef SERVO_CONTROLLER_H
#define SERVO_CONTROLLER_H

#include "config.h"

// 初始化舵机
void setupServos() {
    servo1.attach(SERVO_PIN_1);
    servo2.attach(SERVO_PIN_2);
    
    // 初始化舵机位置（闭合状态）
    servo1.write(0);
    servo2.write(180);
}

// 设置两个舵机的角度
void setServoAngles(int angle1, int angle2) {
    servo1.write(angle1);
    servo2.write(angle2);
}

// 渐进式移动舵机的函数
void moveServos(int startAngle, int endAngle, int step, int delayTime) {
    if (step > 0) {
        for (int angle = startAngle; angle <= endAngle; angle += step) {
            int reversedAngle = 180 - angle;
            setServoAngles(angle, reversedAngle);
            delay(delayTime);
        }
    } else {
        for (int angle = startAngle; angle >= endAngle; angle += step) {
            int reversedAngle = 180 - angle;
            setServoAngles(angle, reversedAngle);
            delay(delayTime);
        }
    }
}

// 打开书（将舵机移动到打开位置）
void openBook() {
    Serial.println("Opening the book...");
    // 直接设置舵机位置，不使用moveServos渐变
    setServoAngles(180, 0);
    Serial.println("Book is open!");
}

// 关闭书（将舵机移动到闭合位置）
void closeBook() {
    Serial.println("Closing the book...");
    // 直接设置舵机位置，不使用moveServos渐变
    setServoAngles(0, 180);
    Serial.println("Book is closed!");
}

#endif // SERVO_CONTROLLER_H