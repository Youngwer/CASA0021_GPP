#include <ESP32Servo.h>         // ESP32Servo 库
#include <Adafruit_NeoPixel.h>  // NeoPixel 库
#include <WiFi.h>              // WiFi 库
#include <PubSubClient.h>      // MQTT 库
#include "arduino_secrets.h"   // 包含敏感信息（如 SECRET_SSID 等）

// 引脚定义
const int servoPin = 2;         // 舵机引脚
const int touchPin = 13;        // TTP223 触摸传感器信号引脚
#define LED_PIN1    26          // D26, Device A 的进度灯
#define LED_PIN2    25          // D25, Device B 的进度灯
#define LED_PIN3    23          // D23, 照明灯
#define NUM_LEDS   8            // 每个进度灯条的 LED 数量
#define NUM_LEDS3  8            // 照明灯条的 LED 数量

// 舵机和 LED 灯条对象
Servo servo;
Adafruit_NeoPixel strip1(NUM_LEDS, LED_PIN1, NEO_GRB + NEO_KHZ800);  // Device A 进度灯
Adafruit_NeoPixel strip2(NUM_LEDS, LED_PIN2, NEO_GRB + NEO_KHZ800);  // Device B 进度灯
Adafruit_NeoPixel strip3(NUM_LEDS3, LED_PIN3, NEO_GRB + NEO_KHZ800); // 照明灯

// MQTT 配置
const char* ssid          = SECRET_SSID;
const char* password      = SECRET_PASS;
const char* mqtt_username = SECRET_MQTTUSER;
const char* mqtt_password = SECRET_MQTTPASS;
const char* mqtt_server   = "mqtt.cetools.org";
const int   mqtt_port     = 1884;

const char* mqtt_topic_isReading_A  = "student/ucfnwy2/DeviceA/isReading";
const char* mqtt_topic_totalDailyTime_A = "student/ucfnwy2/DeviceA/totalDailyTime";
const char* mqtt_topic_isReading_B  = "student/ucfnwy2/DeviceB/isReading";
const char* mqtt_topic_totalDailyTime_B = "student/ucfnwy2/DeviceB/totalDailyTime";

WiFiClient espClient;
PubSubClient client(espClient);

// 状态变量
bool servoState = false;        // 舵机状态（false: 关闭, true: 开启）
bool lastTouchState = LOW;      // 上次触摸状态
bool longPressTriggered = false;// 是否触发了长按
unsigned long touchStartTime = 0;  // 触摸开始时间
const unsigned long longPressDuration = 5000;  // 长按时长（5秒）

// 计时器和 MQTT 相关变量
unsigned long readingStartTime = 0;  // 阅读开始时间
unsigned long currentReadingTime = 0;  // 当前阅读时长
unsigned long totalDailyTimeA = 0;   // Device A 今日总阅读时间（单位：毫秒）
unsigned long totalDailyTimeB = 0;   // Device B 今日总阅读时间（单位：毫秒）
unsigned long lastResetTime = 0;     // 上次重置时间
unsigned long lastUpdateTime = 0;    // 上次更新时间
unsigned long lastBreathTime = 0;    // 上次呼吸灯更新时间
const unsigned long updateInterval = 10000;  // 实时更新间隔（10秒）
bool isReading = false;              // Device A 是否正在阅读
bool isReadingB = false;             // Device B 是否正在阅读（从 MQTT 获取）

void setup() {
    Serial.begin(115200);
    
    // 初始化舵机
    servo.attach(servoPin);
    servo.write(0);  // 初始位置（关闭）

    // 初始化进度灯1 (Device A)
    strip1.begin();
    strip1.show();
    strip1.setBrightness(50);
    setLEDColor(1, 0, 0, 0);  // 初始关闭

    // 初始化进度灯2 (Device B)
    strip2.begin();
    strip2.show();
    strip2.setBrightness(50);
    setLEDColor(2, 0, 0, 0);  // 初始关闭

    // 初始化照明灯
    strip3.begin();
    strip3.show();
    strip3.setBrightness(50);
    setLEDColor(3, 0, 0, 0);  // 初始关闭

    // 初始化触摸传感器引脚
    pinMode(touchPin, INPUT);
    lastResetTime = millis();  // 初始化上次重置时间
    totalDailyTimeA = 0;       // 程序启动时初始化 Device A 阅读时间为 0

    // 连接 WiFi 和 MQTT
    connectToWiFi();
    client.setServer(mqtt_server, mqtt_port);
    client.setCallback(callback);
    reconnectMQTT();

    Serial.println("Setup complete");
}

void loop() {
    // 保持 MQTT 连接
    if (!client.connected()) {
        reconnectMQTT();
    }
    client.loop();

    // 读取触摸传感器状态
    bool currentTouchState = digitalRead(touchPin);

    // 检查是否需要每日重置
    checkDailyReset();

    // 检测触摸按下（上升沿）
    if (currentTouchState == HIGH && lastTouchState == LOW) {
        touchStartTime = millis();  // 记录触摸开始时间
        longPressTriggered = false;  // 重置长按标志
        Serial.println("Touch pressed");
    }

    // 检测触摸松开（下降沿）
    if (currentTouchState == LOW && lastTouchState == HIGH) {
        unsigned long touchDuration = millis() - touchStartTime;
        if (touchDuration < longPressDuration && !longPressTriggered) {
            Serial.println("Short press detected (no action on progress LEDs)");
        }
        longPressTriggered = false;  // 松手后重置长按标志
        Serial.println("Touch released");
    }

    // 检测长按（5秒）
    if (currentTouchState == HIGH && (millis() - touchStartTime >= longPressDuration)) {
        servoState = !servoState;
        if (servoState) {
            moveServo(0, 180, 10, 500);  // 打开舵机
            readingStartTime = millis(); // 开始计时
            isReading = true;            // 设置 Device A 阅读状态
            client.publish(mqtt_topic_isReading_A, "true");  // 发布阅读状态
            Serial.println("Servo opened, reading timer started, isReading = true");
        } else {
            moveServo(180, 0, -10, 500); // 关闭舵机
            currentReadingTime = millis() - readingStartTime; // 计算本次阅读时间
            totalDailyTimeA += currentReadingTime;            // 累加到 Device A 总阅读时间
            isReading = false;           // 停止阅读状态
            char timeStr[16];
            sprintf(timeStr, "%lu", totalDailyTimeA / 1000);  // 转换为秒
            client.publish(mqtt_topic_isReading_A, "false");  // 发布阅读状态
            client.publish(mqtt_topic_totalDailyTime_A, timeStr); // 发布总时间
            Serial.print("Servo closed, reading time this session: ");
            Serial.print(currentReadingTime / 1000.0);        // 输出本次阅读时间（秒）
            Serial.print("s, Total daily reading time (Device A): ");
            Serial.print(totalDailyTimeA / 1000.0);           // 输出总阅读时间（秒）
            Serial.println("s");
        }
        longPressTriggered = true;
        touchStartTime = millis();  // 重置触摸时间，避免重复触发
    }

    // 实时更新 totalDailyTimeA（每 10 秒）
    if (isReading && (millis() - lastUpdateTime >= updateInterval)) {
        unsigned long elapsedTime = millis() - readingStartTime; // 当前阅读时间
        unsigned long tempTotalDailyTime = totalDailyTimeA + elapsedTime; // 临时总时间
        char timeStr[16];
        sprintf(timeStr, "%lu", tempTotalDailyTime / 1000); // 转换为秒
        client.publish(mqtt_topic_totalDailyTime_A, timeStr); // 发布实时总时间
        lastUpdateTime = millis(); // 更新上次发布时间
        Serial.print("Real-time update, Total daily reading time (Device A): ");
        Serial.print(tempTotalDailyTime / 1000.0);
        Serial.println("s");
    }

    // 更新照明灯 (D23)
    if (isReading && isReadingB) {
        // 两个设备都在阅读，显示呼吸灯效果
        breatheLED();
    } else if (isReading) {
        // 仅 Device A 在阅读，照明灯全红
        setLEDColor(3, 255, 0, 0);
    } else {
        // Device A 未阅读，照明灯关闭
        setLEDColor(3, 0, 0, 0);
    }

    // 始终更新进度灯显示
    updateProgressLEDs();

    lastTouchState = currentTouchState;
}

// WiFi 连接
void connectToWiFi() {
    Serial.print("Connecting to WiFi: ");
    Serial.println(ssid);
    WiFi.begin(ssid, password);
    while (WiFi.status() != WL_CONNECTED) {
        delay(500);
        Serial.print(".");
    }
    Serial.println("\nWiFi connected.");
    Serial.print("IP address: ");
    Serial.println(WiFi.localIP());
}

// MQTT 重连
void reconnectMQTT() {
    if (WiFi.status() != WL_CONNECTED) {
        connectToWiFi();
    }
    while (!client.connected()) {
        Serial.print("Attempting MQTT connection...");
        String clientId = "DeviceA_ESP32_";
        clientId += String(random(0xffff), HEX);
        if (client.connect(clientId.c_str(), mqtt_username, mqtt_password)) {
            Serial.println("Connected to MQTT broker");
            client.subscribe(mqtt_topic_isReading_B);
            client.subscribe(mqtt_topic_totalDailyTime_B);
            // 发布初始状态
            client.publish(mqtt_topic_isReading_A, "false");
            client.publish(mqtt_topic_totalDailyTime_A, "0"); // 启动时上传 0
        } else {
            Serial.print("Failed, rc=");
            Serial.print(client.state());
            Serial.println(" - trying again in 5 seconds");
            delay(5000);
        }
    }
}

// MQTT 回调函数
void callback(char* topic, byte* payload, unsigned int length) {
    String message;
    for (unsigned int i = 0; i < length; i++) {
        message += (char)payload[i];
    }
    Serial.print("Message received on topic [");
    Serial.print(topic);
    Serial.print("]: ");
    Serial.println(message);

    // 处理 Device B 的消息
    if (strcmp(topic, mqtt_topic_isReading_B) == 0) {
        isReadingB = (message == "true"); // 更新 Device B 阅读状态
    } else if (strcmp(topic, mqtt_topic_totalDailyTime_B) == 0) {
        totalDailyTimeB = message.toInt() * 1000; // 转换为毫秒
        updateProgressLEDs(); // 更新进度灯
    }
}

// 设置 LED 颜色
void setLEDColor(int stripNum, uint8_t r, uint8_t g, uint8_t b) {
    Adafruit_NeoPixel* strip;
    int numLeds;
    if (stripNum == 1) {
        strip = &strip1;
        numLeds = NUM_LEDS;
    } else if (stripNum == 2) {
        strip = &strip2;
        numLeds = NUM_LEDS;
    } else if (stripNum == 3) {
        strip = &strip3;
        numLeds = NUM_LEDS3;
    } else {
        return;
    }
    for (int i = 0; i < numLeds; i++) {
        strip->setPixelColor(i, strip->Color(r, g, b));
    }
    strip->show();
}

// 移动舵机
void moveServo(int startAngle, int endAngle, int step, int delayTime) {
    if (step > 0) {
        for (int angle = startAngle; angle <= endAngle; angle += step) {
            servo.write(angle);
            delay(delayTime);
        }
    } else {
        for (int angle = startAngle; angle >= endAngle; angle += step) {
            servo.write(angle);
            delay(delayTime);
        }
    }
}

// 检查是否需要每日重置
void checkDailyReset() {
    unsigned long currentTime = millis();
    if (currentTime - lastResetTime >= 86400000) {
        totalDailyTimeA = 0;  // 重置 Device A 阅读时间
        totalDailyTimeB = 0;  // 重置 Device B 阅读时间
        lastResetTime = currentTime;
        if (client.connected()) {
            client.publish(mqtt_topic_totalDailyTime_A, "0");
        }
        Serial.println("Daily reading time reset");
    }
}

// 更新进度灯显示
void updateProgressLEDs() {
    // Device A 的进度灯 (D26, strip1)
    unsigned long displayTimeA = totalDailyTimeA;
    if (isReading) {
        displayTimeA += (millis() - readingStartTime); // 实时显示当前总时间
    }
    int ledCountA;
    if (displayTimeA == 0) {
        ledCountA = NUM_LEDS; // 8 盏灯全亮
        for (int i = 0; i < NUM_LEDS; i++) {
            strip1.setPixelColor(i, strip1.Color(255, 0, 0)); // 红色
        }
    } else {
        unsigned long secondsA = displayTimeA / 1000;
        if (secondsA < 30) {
            ledCountA = 2;  // < 30s，亮 2 盏
        } else if (secondsA <= 60) {
            ledCountA = 4;  // 30-60s，亮 4 盏
        } else if (secondsA <= 120) {
            ledCountA = 6;  // 60-120s，亮 6 盏
        } else {
            ledCountA = 8;  // > 120s，亮 8 盏
        }
        for (int i = 0; i < NUM_LEDS; i++) {
            if (i < ledCountA) {
                strip1.setPixelColor(i, strip1.Color(0, 255, 0)); // 绿色
            } else {
                strip1.setPixelColor(i, strip1.Color(0, 0, 0));   // 关闭
            }
        }
    }
    strip1.show();

    // Device B 的进度灯 (D25, strip2)
    int ledCountB;
    if (totalDailyTimeB == 0) {
        ledCountB = NUM_LEDS; // 8 盏灯全亮
        for (int i = 0; i < NUM_LEDS; i++) {
            strip2.setPixelColor(i, strip2.Color(255, 0, 0)); // 红色
        }
    } else {
        unsigned long secondsB = totalDailyTimeB / 1000;
        if (secondsB < 30) {
            ledCountB = 2;  // < 30s，亮 2 盏
        } else if (secondsB <= 60) {
            ledCountB = 4;  // 30-60s，亮 4 盏
        } else if (secondsB <= 120) {
            ledCountB = 6;  // 60-120s，亮 6 盏
        } else {
            ledCountB = 8;  // > 120s，亮 8 盏
        }
        for (int i = 0; i < NUM_LEDS; i++) {
            if (i < ledCountB) {
                strip2.setPixelColor(i, strip2.Color(0, 255, 0)); // 绿色
            } else {
                strip2.setPixelColor(i, strip2.Color(0, 0, 0));   // 关闭
            }
        }
    }
    strip2.show();
}

// 呼吸灯效果
void breatheLED() {
    unsigned long currentTime = millis();
    if (currentTime - lastBreathTime >= 20) { // 每 20ms 更新一次，平滑过渡
        float brightness = (sin(currentTime / 1000.0) + 1) * 127.5; // 0-255 范围的正弦波
        uint8_t r = (uint8_t)brightness; // 柔和的红色呼吸效果
        for (int i = 0; i < NUM_LEDS3; i++) {
            strip3.setPixelColor(i, strip3.Color(r, 0, 0));
        }
        strip3.show();
        lastBreathTime = currentTime;
    }
}