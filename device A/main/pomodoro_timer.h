#ifndef POMODORO_TIMER_H
#define POMODORO_TIMER_H

#include "config.h"
#include "servo_controller.h"
#include "button_handler.h"

// 番茄钟相关变量
unsigned long pomodoroStartTime = 0;    // 番茄钟开始时间
bool pomodoroActive = false;            // 番茄钟是否激活
int lastServoPosition = 0;              // 上次舵机位置

// 初始化番茄钟
void setupPomodoro() {
    pomodoroActive = false;
    pomodoroStartTime = 0;
    lastServoPosition = 0;
}

// 番茄钟更新函数
void updatePomodoro() {
    // 如果番茄钟未激活，直接返回
    if (!pomodoroActive || !isOpen) {
        return;
    }
    
    unsigned long currentTime = millis();
    unsigned long elapsedTime = currentTime - pomodoroStartTime;
    
    // 如果已经过了一小时，关闭书本
    if (elapsedTime >= POMODORO_TOTAL_TIME) {
        Serial.println("Pomodoro timer completed!");
        toggleBook(); // 这将关闭书本并停止番茄钟
        return;
    }
    
    // 计算当前应该的舵机位置 (从180度开始，到0度结束)
    // 60分钟对应180度，每分钟3度
    float percentComplete = (float)elapsedTime / POMODORO_TOTAL_TIME;
    int targetPosition = 180 - (int)(percentComplete * 180);
    
    // 每当位置变化1度时更新舵机
    if (targetPosition != lastServoPosition) {
        Serial.print("Pomodoro progress: ");
        Serial.print((int)(percentComplete * 100));
        Serial.print("%, servo position: ");
        Serial.println(targetPosition);
        
        // 更新舵机位置
        setServoAngles(targetPosition, 180 - targetPosition);
        lastServoPosition = targetPosition;
    }
}

#endif // POMODORO_TIMER_H