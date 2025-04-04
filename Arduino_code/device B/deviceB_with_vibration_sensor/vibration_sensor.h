#ifndef VIBRATION_SENSOR_H
#define VIBRATION_SENSOR_H

#include "config.h"
#include "mqtt_handler.h"

// 振动状态相关变量
bool vibrationDetected = false;             // 当前是否检测到振动
unsigned long lastVibrationTime = 0;        // 上次检测到振动的时间
unsigned long firstTapTime = 0;             // 第一次敲击的时间
bool firstTapDetected = false;              // 是否已检测到第一次敲击
const unsigned long doubleTapWindow = 800;  // 双击的时间窗口（毫秒）
const unsigned long minTapInterval = 150;   // 两次敲击的最小间隔（毫秒）
const unsigned long globalCooldown = 3000;  // 全局冷却时间，成功双击后的等待时间（毫秒）
bool inGlobalCooldown = false;              // 是否在全局冷却期内
unsigned long lastStateChangeTime = 0;      // 上次状态改变的时间

// 传感器敏感度调整
const int requiredSamples = 4;              // 需要连续的HIGH样本才认为是有效振动
int consecutiveSamples = 0;                 // 当前连续HIGH样本计数

// 这些变量在主程序中定义，这里只声明引用
extern bool isTouch;                     // 当前设备的触摸状态
extern bool otherDeviceIsTouch;          // 另一台设备的触摸状态
extern bool isOpen;                      // 书的状态

// 初始化振动传感器
void setupVibrationSensor() {
    pinMode(SW420_PIN, INPUT);  // 设置SW-420连接引脚为输入模式
    Serial.println("振动传感器初始化完成");
}

// 检查振动传感器状态，实现双击检测
void checkVibration() {
    // 只有当书处于打开状态时才处理振动
    if (!isOpen) {
        firstTapDetected = false;  // 如果书关闭，重置双击检测状态
        inGlobalCooldown = false;  // 重置全局冷却状态
        consecutiveSamples = 0;    // 重置样本计数
        return;
    }
    
    unsigned long currentTime = millis();
    
    // 检查全局冷却期
    if (inGlobalCooldown) {
        if (currentTime - lastStateChangeTime >= globalCooldown) {
            inGlobalCooldown = false;
            Serial.println("全局冷却结束，可以再次检测敲击");
        } else {
            return; // 仍在冷却期内，忽略所有敲击
        }
    }
    
    // 读取传感器数字信号
    int sensorValue = digitalRead(SW420_PIN);
    
    // 使用连续采样来减少误报
    if (sensorValue == HIGH) {
        consecutiveSamples++;
    } else {
        consecutiveSamples = 0; // 重置计数
    }
    
    // 只有当达到指定的连续样本数时才认为是有效振动
    bool validVibration = (consecutiveSamples >= requiredSamples);
    
    // 第一次敲击逻辑
    if (!firstTapDetected && validVibration) {
        // 检测到有效振动
        firstTapDetected = true;
        firstTapTime = currentTime;
        lastVibrationTime = currentTime;
        consecutiveSamples = 0; // 重置计数，准备检测第二次敲击
        Serial.println("检测到第一次敲击，等待第二次敲击...");
    }
    // 第二次敲击逻辑
    else if (firstTapDetected && validVibration) {
        unsigned long tapInterval = currentTime - firstTapTime;
        
        // 确保两次敲击之间有足够的间隔，但不超过窗口期
        if (tapInterval > minTapInterval && tapInterval < doubleTapWindow) {
            // 有效的双击，切换状态
            isTouch = !isTouch;
            lastStateChangeTime = currentTime;
            inGlobalCooldown = true;
            
            Serial.print("检测到有效双击! 触摸状态变更为: ");
            Serial.println(isTouch ? "true" : "false");
            Serial.println("进入全局冷却期，暂时忽略敲击");
            
            // 新增：切换灯光颜色并发布
            isYellowColor = !isYellowColor;
            // 发布新的灯光颜色
            publishLightColor(isYellowColor);
            
            // 应用新的颜色到LED
            if (isYellowColor) {
                setLEDColor(255, 255, 0);  // 黄色
            } else {
                setLEDColor(255, 102, 178);  // 粉色
            }
            
            // 发布触摸状态到MQTT
            publishTouchStatus(isTouch);
            
            // 重置所有状态
            firstTapDetected = false;
            consecutiveSamples = 0;
        }
    }
    
    // 检查是否超过双击窗口，重置第一次敲击状态
    if (firstTapDetected && (currentTime - firstTapTime > doubleTapWindow)) {
        firstTapDetected = false;
        consecutiveSamples = 0;
        Serial.println("双击窗口超时，重置敲击检测");
    }
}

#endif // VIBRATION_SENSOR_H