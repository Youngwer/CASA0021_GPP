#ifndef BUTTON_HANDLER_H
#define BUTTON_HANDLER_H

#include "config.h"
#include "led_controller.h"
#include "reading_timer.h"
#include "servo_controller.h"

// 按钮控制相关变量
bool buttonPressed = false;           // 按钮是否被按下
unsigned long buttonPressTime = 0;    // 按钮按下的时间
bool longPressTriggered = false;      // 长按是否已触发标志
int lastButtonState = HIGH;           // 上一次按钮状态
unsigned long lastDebounceTime = 0;   // 上次去抖动时间

// 外部声明从其他模块引用的变量
extern bool pomodoroActive;
extern unsigned long pomodoroStartTime;

// 初始化按钮引脚
void setupButton() {
    pinMode(BUTTON_PIN, INPUT_PULLUP);
}

// 切换书的开关状态
void toggleBook() {
    if (isOpen) {
        closeBook();
        setLEDColor(0, 0, 0);
        stopReadingTimer();
        // 停止番茄钟
        pomodoroActive = false;
    } else {
        openBook();
        startReadingTimer();
        // 启动番茄钟
        pomodoroStartTime = millis();
        pomodoroActive = true;
    }
    isOpen = !isOpen;
}

// 检查按钮状态的函数
void checkButton() {
    // 读取按钮状态（低电平为按下）
    int buttonState = digitalRead(BUTTON_PIN);
    
    // 按钮按下
    if (buttonState == LOW && !buttonPressed) {
        buttonPressed = true;
        buttonPressTime = millis();
        longPressTriggered = false;
        Serial.println("按钮被按下");
    } 
    
    // 按钮持续按下，检查是否达到长按时间
    else if (buttonState == LOW && buttonPressed) {
        unsigned long pressDuration = millis() - buttonPressTime;
        
        // 达到长按时间且尚未触发长按动作
        if (pressDuration >= LONG_PRESS_TIME && !longPressTriggered) {
            toggleBook();         // 切换书的开关状态
            longPressTriggered = true;  // 设置标志，防止重复触发
            Serial.println("长按3秒检测到，切换书的状态");
        }
    }
    
    // 按钮释放
    else if (buttonState == HIGH && buttonPressed) {
        unsigned long pressDuration = millis() - buttonPressTime;
        buttonPressed = false;
        
        // 短按（小于3秒）且没有触发过长按动作 - 控制LED灯
        if (pressDuration < LONG_PRESS_TIME && !longPressTriggered) {
            toggleLEDs();
            Serial.println("短按检测到，切换LED灯状态");
        }
        
        // 重置长按触发标志
        longPressTriggered = false;
    }
}

#endif // BUTTON_HANDLER_H