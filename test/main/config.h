#ifndef CONFIG_H
#define CONFIG_H

#include <ESP32Servo.h>
#include <Adafruit_NeoPixel.h>
#include <WiFi.h>
#include <PubSubClient.h>
#include "arduino_secrets.h"

// 引脚定义
const int SERVO_PIN_1 = 15;       // 舵机1连接的GPIO
const int SERVO_PIN_2 = 2;        // 舵机2连接的GPIO
const int BUTTON_PIN = 13;        // 按钮连接的GPIO
#define LED_PIN 23                // 状态指示灯引脚1
#define LED_PIN2 22               // 状态指示灯引脚2（额外照明）
#define NUM_LEDS 8                // 每个状态指示灯的LED数量
#define TIME_LED_PIN 25           // 设备A时间指示灯引脚
#define NUM_TIME_LEDS 12          // 设备A时间指示灯LED数量
#define DEVICEB_TIME_LED_PIN 26   // 设备B时间指示灯引脚
#define NUM_DEVICEB_TIME_LEDS 12  // 设备B时间指示灯LED数量

// MQTT主题配置
const char* MQTT_TOPIC_ISREADING_A = "student/ucfnwy2/DeviceA/isReading";
const char* MQTT_TOPIC_TOTALDAILYTIME_A = "student/ucfnwy2/DeviceA/totalDailyTime";
const char* MQTT_TOPIC_ISREADING_B = "student/ucfnwy2/DeviceB/isReading";
const char* MQTT_TOPIC_TOTALDAILYTIME_B = "student/ucfnwy2/DeviceB/totalDailyTime";

// 时间常量
const unsigned long UPDATE_INTERVAL = 10000;       // MQTT更新间隔（10秒）
const unsigned long BREATH_INTERVAL = 20;          // 呼吸灯更新间隔（毫秒）
const unsigned long DEBOUNCE_DELAY = 50;           // 按钮去抖动延迟（毫秒）
const unsigned long LONG_PRESS_TIME = 3000;        // 长按定义时间（3秒）
const unsigned long POMODORO_TOTAL_TIME = 3600000; // 番茄钟总时间（1小时）
const unsigned long DAY_IN_MS = 86400000;          // 一天的毫秒数

// 全局对象声明（在主文件中实例化）
extern Servo servo1;
extern Servo servo2;
extern Adafruit_NeoPixel strip;     // 第一个LED灯带（引脚23）
extern Adafruit_NeoPixel strip2;    // 第二个LED灯带（引脚22）
extern Adafruit_NeoPixel timeStrip;
extern Adafruit_NeoPixel deviceBTimeStrip;
extern WiFiClient espClient;
extern PubSubClient client;

// 全局状态变量声明（在主文件中实例化）
extern bool isOpen;                         // 书的状态
extern bool progressLEDsEnabled;            // 进度灯状态
extern unsigned long dailyReadingTime;      // 每日阅读时间
extern unsigned long startTime;             // 当前阅读会话开始时间
extern bool deviceBIsReading;               // 设备B的阅读状态
extern unsigned long deviceBTotalDailyTime; // 设备B的每日总阅读时间

#endif // CONFIG_H