#ifndef POMODORO_TIMER_H
#define POMODORO_TIMER_H

#include "config.h"
#include "servo_controller.h"
#include "button_handler.h"

// 番茄钟相关变量
unsigned long pomodoroStartTime = 0;    // 番茄钟开始时间
bool pomodoroActive = false;            // 番茄钟是否激活
int lastServoStage = 0;                 // 上次舵机阶段（0-5，共6个阶段）

// 番茄钟阶段设置
const int POMODORO_STAGES = 12;                              // 总共6个阶段
const int DEGREES_PER_STAGE = 15;                           // 每个阶段移动30度
const unsigned long STAGE_DURATION = POMODORO_TOTAL_TIME / POMODORO_STAGES;  // 每个阶段持续时间

// 初始化番茄钟
void setupPomodoro() {
    pomodoroActive = false;
    pomodoroStartTime = 0;
    lastServoStage = 0;
}


// 平滑地移动舵机到新位置
void moveServosSmooth(int startAngle, int endAngle, int step, int delayTime) {
    Serial.print("Moving servos smoothly from ");
    Serial.print(startAngle);
    Serial.print(" to ");
    Serial.println(endAngle);
    
    if (step > 0) {
        for (int angle = startAngle; angle >= endAngle; angle -= step) {
            setServoAngles(angle, 180 - angle);
            delay(delayTime);
        }
    } else {
        for (int angle = startAngle; angle <= endAngle; angle -= step) {
            setServoAngles(angle, 180 - angle);
            delay(delayTime);
        }
    }
    
    // 确保最终位置精确
    setServoAngles(endAngle, 180 - endAngle);
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
    
    // 计算当前应在哪个阶段（0-5）
    int currentStage = elapsedTime / STAGE_DURATION;
    
    // 如果阶段变化，更新舵机位置
    if (currentStage != lastServoStage) {
        // 计算新的舵机位置：从180度开始，每阶段减少30度
        int targetPosition = 180 - (currentStage * DEGREES_PER_STAGE);
        
        Serial.print("Pomodoro progress: Stage ");
        Serial.print(currentStage + 1);
        Serial.print(" of ");
        Serial.print(POMODORO_STAGES);
        Serial.print(" (");
        Serial.print((int)((float)currentStage / POMODORO_STAGES * 100));
        Serial.print("%), servo position: ");
        Serial.println(targetPosition);
        
        // 平滑移动到新位置
        moveServosSmooth(180 - (lastServoStage * DEGREES_PER_STAGE), 
                          targetPosition, 
                          (lastServoStage < currentStage) ? 5 : -5, 
                          50);
        
        lastServoStage = currentStage;
    }
}

#endif // POMODORO_TIMER_H