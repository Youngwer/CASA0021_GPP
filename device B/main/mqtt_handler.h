#ifndef MQTT_HANDLER_H
#define MQTT_HANDLER_H

#include "config.h"

// MQTT 配置
const char* MQTT_SERVER = "mqtt.cetools.org";
const int MQTT_PORT = 1884;

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

#endif // MQTT_HANDLER_H