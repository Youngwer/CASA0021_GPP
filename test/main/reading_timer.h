#ifndef READING_TIMER_H
#define READING_TIMER_H

#include "config.h"
#include "mqtt_handler.h"

// 阅读时间变量
unsigned long lastResetTime = 0;      // 上次重置时间
unsigned long lastUpdateTime = 0;      // 上次更新MQTT的时间

// 初始化阅读计时器
void setupReadingTimer() {
    lastResetTime = millis();
    dailyReadingTime = 0;
    startTime = 0;
}

// 格式化并打印时间
void printTime(unsigned long milliseconds) {
    unsigned long seconds = milliseconds / 1000;
    unsigned long minutes = seconds / 60;
    seconds = seconds % 60;
    Serial.print(minutes);
    Serial.print(" minutes ");
    Serial.print(seconds);
    Serial.println(" seconds");
}

// 检查是否需要每日重置
void checkDailyReset() {
    unsigned long currentTime = millis();
    if (currentTime - lastResetTime >= DAY_IN_MS) {
        Serial.print("New day started! Previous day's reading time: ");
        printTime(dailyReadingTime);
        
        // 重置计时器并发布到MQTT
        publishReadingStatus(false, 0);
        
        dailyReadingTime = 0;
        lastResetTime = currentTime;
    }
}

// 开始阅读计时
void startReadingTimer() {
    startTime = millis();
    lastUpdateTime = startTime;
    Serial.println("Reading session started!");
    
    // 发布阅读状态到MQTT
    publishReadingStatus(true, dailyReadingTime);
}

// 停止阅读计时
void stopReadingTimer() {
    if (startTime > 0) {
        unsigned long sessionTime = millis() - startTime;
        dailyReadingTime += sessionTime;
        Serial.print("Reading session ended. Session time: ");
        printTime(sessionTime);
        Serial.print("Total daily reading time: ");
        printTime(dailyReadingTime);
        
        // 发布阅读状态到MQTT
        publishReadingStatus(false, dailyReadingTime);
        
        startTime = 0;
    }
}

// 定期更新阅读时间到MQTT
void updateReadingTime() {
    if (isOpen && startTime > 0) {
        unsigned long currentTime = millis();
        if (currentTime - lastUpdateTime >= UPDATE_INTERVAL) {
            unsigned long currentSessionTime = currentTime - startTime;
            unsigned long totalTime = dailyReadingTime + currentSessionTime;
            
            // 发布总阅读时间到MQTT
            publishReadingStatus(true, totalTime);
            
            lastUpdateTime = currentTime;
        }
    }
}

#endif // READING_TIMER_H