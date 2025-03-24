#ifndef MQTT_HANDLER_H
#define MQTT_HANDLER_H

#include "config.h"

// MQTT 配置
const char* MQTT_SERVER = "mqtt.cetools.org";
const int MQTT_PORT = 1884;
void publishTouchStatus(bool isTouched);

// 添加前向声明
void setLEDColor(uint8_t r, uint8_t g, uint8_t b);  // 前向声明 LED 控制函数

// 添加灯光颜色主题
const char* MQTT_TOPIC_LIGHT_COLOR = "student/ucfnwy2/lightColor";

// 全局颜色状态变量 - 改为extern声明
extern bool isYellowColor;  // 默认为粉色

// 发布灯光颜色状态
void publishLightColor(bool isYellow) {
    // 确保MQTT连接可用时才发布
    if (client.connected()) {
        client.publish(MQTT_TOPIC_LIGHT_COLOR, isYellow ? "yellow" : "pink", true);
        
        Serial.print("发布灯光颜色: ");
        Serial.println(isYellow ? "yellow" : "pink");
    } else {
        Serial.println("MQTT未连接，无法发布灯光颜色");
    }
}

// MQTT消息回调函数
void mqttCallback(char* topic, byte* payload, unsigned int length) {
    String message;
    for (unsigned int i = 0; i < length; i++) {
        message += (char)payload[i];
    }

    if (String(topic) == MQTT_TOPIC_ISREADING_B) {
        deviceBIsReading = (message == "true");
        Serial.print("Device A isReading: ");  // 改为Device A
        Serial.println(deviceBIsReading ? "true" : "false");
    } else if (String(topic) == MQTT_TOPIC_TOTALDAILYTIME_B) {
        deviceBTotalDailyTime = message.toInt();
        Serial.print("Device A totalDailyTime: ");  // 改为Device A
        Serial.print(deviceBTotalDailyTime);
        Serial.println(" seconds");
    } else if (String(topic) == MQTT_TOPIC_ISTOUCH) {
        Serial.println("收到触摸状态消息!");
        
        // 解析消息格式："A:true" 或 "B:false" 等
        int separatorPos = message.indexOf(':');
        if (separatorPos != -1) {
            String deviceId = message.substring(0, separatorPos);
            String touchState = message.substring(separatorPos + 1);
            
            // 判断是否是自己的设备ID
            #ifdef DEVICE_A
                bool isSelfDevice = (deviceId == "A");
            #else
                bool isSelfDevice = (deviceId == "B");
            #endif
            
            // 如果不是自己的设备发送的消息，更新otherDeviceIsTouch
            if (!isSelfDevice) {
                otherDeviceIsTouch = (touchState == "true");
                Serial.print("另一设备的触摸状态更新为: ");
                Serial.println(otherDeviceIsTouch ? "true" : "false");
            }
        }
    } else if (String(topic) == MQTT_TOPIC_LIGHT_COLOR) {
        Serial.println("收到灯光颜色消息: " + message);
        
        if (message == "yellow") {
            isYellowColor = true;
            
            // 如果书是打开的，更新灯光颜色
            if (isOpen) {
                // 设置黄色
                setLEDColor(255, 255, 0);
            }
            
            Serial.println("灯光颜色更新为黄色");
        } 
        else if (message == "pink") {
            isYellowColor = false;
            
            // 如果书是打开的，更新灯光颜色
            if (isOpen) {
                // 设置粉色
                setLEDColor(255, 102, 178);
            }
            
            Serial.println("灯光颜色更新为粉色");
        }
    }
}

// 重新连接到MQTT服务器，添加非阻塞选项
void reconnectMQTT() {
    // 注意：现在WiFi连接状态由wifi_manager.h管理
    
    // 非阻塞MQTT重连尝试
    if (!client.connected()) {
        Serial.print("尝试MQTT连接...");
        String clientId = "DeviceA_ESP32_";
        clientId += String(random(0xffff), HEX);
        if (client.connect(clientId.c_str(), SECRET_MQTTUSER, SECRET_MQTTPASS)) {
            Serial.println("已连接到MQTT代理");
            client.subscribe(MQTT_TOPIC_ISREADING_B);
            client.subscribe(MQTT_TOPIC_TOTALDAILYTIME_B);
            client.subscribe(MQTT_TOPIC_ISTOUCH);  // 订阅设备B的触摸状态
            client.subscribe(MQTT_TOPIC_LIGHT_COLOR);  // 订阅灯光颜色主题
        } else {
            Serial.print("失败，rc=");
            Serial.print(client.state());
            Serial.println(" - 5秒后将重试");
        }
    }
}

// 初始化MQTT连接
void setupMQTT() {
    client.setServer(MQTT_SERVER, MQTT_PORT);
    client.setCallback(mqttCallback);
    
    // 确保MQTT连接已建立
    if (!client.connected()) {
        reconnectMQTT();
    }
    
    // 发布初始状态
    if (client.connected()) {
        client.publish(MQTT_TOPIC_ISREADING_A, "false", true);
        client.publish(MQTT_TOPIC_TOTALDAILYTIME_A, "0", true);
        Serial.println("MQTT状态重置: isReading=false, totalDailyTime=0");
        isTouch = false;
        publishTouchStatus(false);
        // 发布初始灯光颜色为粉色
        publishLightColor(false);
    } else {
        Serial.println("MQTT未连接，无法发布初始状态");
    }
}

// 发布阅读状态到MQTT
void publishReadingStatus(bool isReading, unsigned long totalTime) {
    char timeStr[20];
    sprintf(timeStr, "%lu", totalTime / 1000);
    
    client.publish(MQTT_TOPIC_ISREADING_A, isReading ? "true" : "false", true);
    client.publish(MQTT_TOPIC_TOTALDAILYTIME_A, timeStr, true);
    
    Serial.print("Published to MQTT - isReading: ");
    Serial.print(isReading ? "true" : "false");
    Serial.print(", totalTime: ");
    Serial.print(timeStr);
    Serial.println(" seconds");
}

// 发布触摸状态到MQTT
void publishTouchStatus(bool isTouched) {
    // 确保MQTT连接可用时才发布
    if (client.connected()) {
        client.publish(MQTT_TOPIC_ISTOUCH, isTouched ? "true" : "false", true);
        
        Serial.print("发布到MQTT - isTouch: ");
        Serial.println(isTouched ? "true" : "false");
    } else {
        Serial.println("MQTT未连接，无法发布触摸状态");
    }
}

#endif // MQTT_HANDLER_H