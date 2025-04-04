#include "config.h"
#include "mqtt_handler.h"
#include "servo_controller.h"
#include "led_controller.h"
#include "button_handler.h"
#include "reading_timer.h"
#include "pomodoro_timer.h"
#include "wifi_manager.h"

// 全局对象实例化
Servo servo1;
Servo servo2;
Adafruit_NeoPixel strip(NUM_LEDS, LED_PIN, NEO_GRB + NEO_KHZ800);        // 第一个照明灯带（引脚23）
Adafruit_NeoPixel strip2(NUM_LEDS, LED_PIN2, NEO_GRB + NEO_KHZ800);      // 第二个照明灯带（引脚22）
Adafruit_NeoPixel timeStrip(NUM_TIME_LEDS, TIME_LED_PIN, NEO_GRB + NEO_KHZ800);
Adafruit_NeoPixel deviceBTimeStrip(NUM_DEVICEB_TIME_LEDS, DEVICEB_TIME_LED_PIN, NEO_GRB + NEO_KHZ800);
WiFiClient espClient;
PubSubClient client(espClient);

// 全局状态变量实例化
bool isOpen = false;                         // 书的状态
bool progressLEDsEnabled = true;             // 进度灯状态
unsigned long dailyReadingTime = 0;          // 每日阅读时间
unsigned long startTime = 0;                 // 当前阅读会话开始时间
bool deviceBIsReading = false;               // 设备B的阅读状态
unsigned long deviceBTotalDailyTime = 0;     // 设备B的每日总阅读时间

void setup() {
    Serial.begin(115200);
    Serial.println("Starting setup...");
    
    // 初始化各个模块
    setupButton();
    setupServos();
    setupLEDs();
    setupReadingTimer();
    setupPomodoro();
    
    // 设置WiFi连接 - 如果返回true表示已连接到WiFi
    bool wifiReady = setupWiFiManager();
    
    // 只有当WiFi连接成功后才初始化MQTT
    if (wifiReady) {
        setupMQTT();
    }
    
    Serial.println("Setup complete");
}

void loop() {
    // 检查并维护WiFi连接
    checkWiFiConnection();
    
    // 只有在WiFi连接成功的情况下才处理MQTT
    if (wifiConnected) {
        // 确保MQTT连接
        if (!client.connected()) {
            reconnectMQTT();
        }
        client.loop();
        
        // 更新阅读时间到MQTT
        updateReadingTime();
    }
    
    // 本地功能始终运行，不依赖于WiFi连接
    checkDailyReset();
    updateTimeLEDs();
    updateDeviceBTimeLEDs();
    checkButton();
    updatePomodoro();
    
    // 根据设备A和B的阅读状态更新LED效果
    if (isOpen) {
        if (deviceBIsReading) {
            updateBreathingEffect(255, 102, 178);  // 粉呼吸灯效果
        } else {
            setLEDColor(255, 102, 178);            // 固定粉色
        }
    }
}