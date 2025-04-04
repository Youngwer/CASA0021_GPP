#include <ESP32Servo.h>         // ESP32Servo 库
#include <Adafruit_NeoPixel.h>  // NeoPixel 库
#include <WiFi.h>              // WiFi 库
#include <PubSubClient.h>      // MQTT 库
#include "arduino_secrets.h" 

// 函数前向声明
void connectToWiFi();
void reconnectMQTT();
void callback(char* topic, byte* payload, unsigned int length);
void checkDailyReset();
void updateReadingTime();
void updateTimeLEDs();
void updateDeviceBTimeLEDs();
void toggleLEDs();
void toggleBook();
void openBook();
void closeBook();
void startReadingTimer();
void stopReadingTimer();
void moveServos(int startAngle, int endAngle, int step, int delayTime);
void setServoAngles(int angle1, int angle2);
void setLEDColor(uint8_t r, uint8_t g, uint8_t b);
void updateBreathingEffect(uint8_t red, uint8_t green, uint8_t blue);
void setStripColorWithBrightness(uint8_t red, uint8_t green, uint8_t blue, uint8_t brightness);
void printTime(unsigned long milliseconds);
void checkButton();
void updatePomodoro();

Servo servo2;  // 创建舵机对象2
Servo servo1;
// 引脚定义
const int servoPin1 = 15;   // 舵机1连接的GPIO
const int servoPin2 = 2;    // 舵机2连接的GPIO
const int buttonPin = 13;   // 按钮连接的GPIO
#define LED_PIN    23       // 原LED数据线引脚（状态指示灯）
#define NUM_LEDS   8        // 原LED数量
#define TIME_LED_PIN  25    // 设备A时间指示灯引脚
#define NUM_TIME_LEDS 12    // 设备A时间指示灯LED数量
#define DEVICEB_TIME_LED_PIN 26  // 设备B时间指示灯引脚 (D26)
#define NUM_DEVICEB_TIME_LEDS 12 // 设备B时间指示灯LED数量

Adafruit_NeoPixel strip(NUM_LEDS, LED_PIN, NEO_GRB + NEO_KHZ800);
Adafruit_NeoPixel timeStrip(NUM_TIME_LEDS, TIME_LED_PIN, NEO_GRB + NEO_KHZ800);
Adafruit_NeoPixel deviceBTimeStrip(NUM_DEVICEB_TIME_LEDS, DEVICEB_TIME_LED_PIN, NEO_GRB + NEO_KHZ800);

// MQTT 配置
const char* ssid          = SECRET_SSID;
const char* password      = SECRET_PASS;
const char* mqtt_username = SECRET_MQTTUSER;
const char* mqtt_password = SECRET_MQTTPASS;
const char* mqtt_server   = "mqtt.cetools.org";
const int   mqtt_port     = 1884;

const char* mqtt_topic_isReading_A  = "student/ucfnwy2/DeviceA/isReading";
const char* mqtt_topic_totalDailyTime_A = "student/ucfnwy2/DeviceA/totalDailyTime";
const char* mqtt_topic_isReading_B = "student/ucfnwy2/DeviceB/isReading";
const char* mqtt_topic_totalDailyTime_B = "student/ucfnwy2/DeviceB/totalDailyTime";

WiFiClient espClient;
PubSubClient client(espClient);

// 按钮控制相关变量
bool buttonPressed = false;           // 按钮是否被按下
unsigned long buttonPressTime = 0;    // 按钮按下的时间
const long longPressTime = 3000;      // 长按定义为3秒
bool longPressTriggered = false;      // 长按是否已触发标志

// 状态变量
bool isOpen = false;            // 书的状态
int lastButtonState = HIGH;     // 上一次按钮状态
unsigned long lastDebounceTime = 0;
const unsigned long debounceDelay = 50;
bool progressLEDsEnabled = true;  // 进度灯是否启用的标志

// 阅读时间变量
unsigned long startTime = 0;
unsigned long dailyReadingTime = 0;
unsigned long lastResetTime = 0;

// 实时更新相关变量
unsigned long lastUpdateTime = 0;
const unsigned long updateInterval = 10000;  // 更新间隔（10秒）

// 设备B的阅读状态和时间
bool deviceBIsReading = false;  // 设备B是否在阅读
unsigned long deviceBTotalDailyTime = 0;  // 设备B的每日总阅读时间（秒）

// 呼吸灯相关变量
int brightness = 0;             // 当前亮度（0-255）
bool increasing = true;         // 亮度是否在增加
unsigned long lastBreathTime = 0;  // 上次呼吸灯更新时间
const unsigned long breathInterval = 20;  // 呼吸灯每次更新的间隔（毫秒）

// 番茄钟相关变量
unsigned long pomodoroStartTime = 0;    // 番茄钟开始时间
const unsigned long pomodoroTotalTime = 3600000; // 一小时 = 3600000毫秒
bool pomodoroActive = false;            // 番茄钟是否激活
int lastServoPosition = 0;              // 上次舵机位置

void setup() {
    Serial.begin(115200);
    pinMode(buttonPin, INPUT_PULLUP);
    servo1.attach(servoPin1);
    servo2.attach(servoPin2);
    
    strip.begin();
    strip.show();
    strip.setBrightness(50);

    timeStrip.begin();
    timeStrip.show();
    timeStrip.setBrightness(50);

    deviceBTimeStrip.begin();
    deviceBTimeStrip.show();
    deviceBTimeStrip.setBrightness(50);
    
    lastResetTime = millis();
    
    // 重置阅读状态和时间
    isOpen = false;
    dailyReadingTime = 0;
    startTime = 0;
    pomodoroActive = false;
    
    connectToWiFi();
    client.setServer(mqtt_server, mqtt_port);
    client.setCallback(callback);

    // 初始化舵机位置
    servo1.write(0);
    servo2.write(180);
    
    // 等待MQTT连接建立
    if (!client.connected()) {
        reconnectMQTT();
    }
    
    // 发布重置后的状态到MQTT
    client.publish(mqtt_topic_isReading_A, "false", true);
    client.publish(mqtt_topic_totalDailyTime_A, "0", true);
    Serial.println("MQTT status reset: isReading=false, totalDailyTime=0");
    
    Serial.println("Setup complete");
}

void loop() {
    if (!client.connected()) {
        reconnectMQTT();
    }
    client.loop();
    
    checkDailyReset();
    updateReadingTime();
    updateTimeLEDs();          // 更新设备A时间指示灯
    updateDeviceBTimeLEDs();   // 更新设备B时间指示灯
    checkButton();             // 检查按钮状态
    updatePomodoro();          // 更新番茄钟状态和舵机位置

    // 根据设备A和B的阅读状态更新LED效果
    if (isOpen) {
        if (deviceBIsReading) {
            updateBreathingEffect(255, 0, 0);  // 红色
        } else {
            setLEDColor(255, 0, 0);
        }
    }
}

// WiFi和MQTT连接函数
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
        } else {
            Serial.print("Failed, rc=");
            Serial.print(client.state());
            Serial.println(" - trying again in 5 seconds");
            delay(5000);
        }
    }
}

// MQTT回调函数，处理订阅的消息
void callback(char* topic, byte* payload, unsigned int length) {
    String message;
    for (unsigned int i = 0; i < length; i++) {
        message += (char)payload[i];
    }

    if (String(topic) == mqtt_topic_isReading_B) {
        deviceBIsReading = (message == "true");
        Serial.print("Device B isReading: ");
        Serial.println(deviceBIsReading ? "true" : "false");
    } else if (String(topic) == mqtt_topic_totalDailyTime_B) {
        deviceBTotalDailyTime = message.toInt();
        Serial.print("Device B totalDailyTime: ");
        Serial.print(deviceBTotalDailyTime);
        Serial.println(" seconds");
    }
}

// 检查按钮状态的函数
void checkButton() {
    // 读取按钮状态（低电平为按下）
    int buttonState = digitalRead(buttonPin);
    
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
        if (pressDuration >= longPressTime && !longPressTriggered) {
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
        if (pressDuration < longPressTime && !longPressTriggered) {
            toggleLEDs();
            Serial.println("短按检测到，切换LED灯状态");
        }
        
        // 重置长按触发标志
        longPressTriggered = false;
    }
}

// 控制两个进度条灯(D25和D26)的开关
void toggleLEDs() {
    progressLEDsEnabled = !progressLEDsEnabled;
    
    if (!progressLEDsEnabled) {
        // 关闭两个进度条LED灯
        timeStrip.clear();
        timeStrip.show();
        
        deviceBTimeStrip.clear();
        deviceBTimeStrip.show();
        
        Serial.println("进度条LED灯带(D25, D26)：关闭");
    } else {
        // 重新启用进度条LED灯（会在下一次更新循环中根据阅读时间自动点亮）
        Serial.println("进度条LED灯带(D25, D26)：启用");
        // 立即更新一次灯带状态
        updateTimeLEDs();
        updateDeviceBTimeLEDs();
    }
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
        lastServoPosition = 180; // 初始位置为完全打开
    }
    isOpen = !isOpen;
}

// 实时更新阅读时间到MQTT
void updateReadingTime() {
    if (isOpen && startTime > 0) {
        unsigned long currentTime = millis();
        if (currentTime - lastUpdateTime >= updateInterval) {
            unsigned long currentSessionTime = currentTime - startTime;
            unsigned long totalTime = dailyReadingTime + currentSessionTime;
            
            char timeStr[20];
            sprintf(timeStr, "%lu", totalTime / 1000);
            client.publish(mqtt_topic_totalDailyTime_A, timeStr, true);
            Serial.print("Updated total reading time to MQTT: ");
            printTime(totalTime);
            
            lastUpdateTime = currentTime;
        }
    }
}

// 更新设备A时间指示灯（简化版，无特效）
void updateTimeLEDs() {
    // 如果进度灯被禁用，直接返回
    if (!progressLEDsEnabled) {
        return;
    }
    
    unsigned long totalTime = dailyReadingTime;
    if (isOpen && startTime > 0) {
        totalTime += (millis() - startTime);
    }
    unsigned long totalSeconds = totalTime / 1000;

    // 如果总时间为0，所有灯亮红色
    if (totalTime == 0) {
        for (int i = 0; i < NUM_TIME_LEDS; i++) {
            timeStrip.setPixelColor(i, timeStrip.Color(255, 0, 0));  // 红色
        }
        timeStrip.show();
        return;
    }

    // 正常亮灯逻辑
    int ledsToLight = 0;
    if (totalSeconds < 900) {
        ledsToLight = 2;
    } else if (totalSeconds < 1800) {
        ledsToLight = 3;
    } else if (totalSeconds < 2700) {
        ledsToLight = 6;
    } else if (totalSeconds < 3600) {
        ledsToLight = 9;
    } else {
        ledsToLight = 12;
    }

    for (int i = 0; i < NUM_TIME_LEDS; i++) {
        if (i < ledsToLight) {
            timeStrip.setPixelColor(i, timeStrip.Color(0, 255, 0));  // 绿色
        } else {
            timeStrip.setPixelColor(i, timeStrip.Color(0, 0, 0));    // 关闭
        }
    }
    timeStrip.show();
}

// 更新设备B时间指示灯（简化版，无特效）
void updateDeviceBTimeLEDs() {
    // 如果进度灯被禁用，直接返回
    if (!progressLEDsEnabled) {
        return;
    }
    
    unsigned long totalSeconds = deviceBTotalDailyTime;

    // 如果总时间为0，所有灯亮红色
    if (totalSeconds == 0) {
        for (int i = 0; i < NUM_DEVICEB_TIME_LEDS; i++) {
            deviceBTimeStrip.setPixelColor(i, deviceBTimeStrip.Color(255, 0, 0));  // 红色
        }
        deviceBTimeStrip.show();
        return;
    }

    // 正常亮灯逻辑
    int ledsToLight = 0;
    if (totalSeconds < 900) {
        ledsToLight = 2;
    } else if (totalSeconds < 1800) {
        ledsToLight = 3;
    } else if (totalSeconds < 2700) {
        ledsToLight = 6;
    } else if (totalSeconds < 3600) {
        ledsToLight = 9;
    } else {
        ledsToLight = 12;
    }

    for (int i = 0; i < NUM_DEVICEB_TIME_LEDS; i++) {
        if (i < ledsToLight) {
            deviceBTimeStrip.setPixelColor(i, deviceBTimeStrip.Color(0, 255, 0));  // 绿色
        } else {
            deviceBTimeStrip.setPixelColor(i, deviceBTimeStrip.Color(0, 0, 0));    // 关闭
        }
    }
    deviceBTimeStrip.show();
}

// 阅读时间相关函数
void checkDailyReset() {
    unsigned long currentTime = millis();
    if (currentTime - lastResetTime >= 86400000) {
        Serial.print("New day started! Previous day's reading time: ");
        printTime(dailyReadingTime);
        
        client.publish(mqtt_topic_isReading_A, "false", true);
        client.publish(mqtt_topic_totalDailyTime_A, "0", true);
        
        dailyReadingTime = 0;
        lastResetTime = currentTime;
    }
}

void startReadingTimer() {
    startTime = millis();
    lastUpdateTime = startTime;
    Serial.println("Reading session started!");
    
    char timeStr[20];
    sprintf(timeStr, "%lu", dailyReadingTime / 1000);
    client.publish(mqtt_topic_isReading_A, "true", true);
    client.publish(mqtt_topic_totalDailyTime_A, timeStr, true);
    Serial.println("Reading status published to MQTT!");
}

void stopReadingTimer() {
    if (startTime > 0) {
        unsigned long sessionTime = millis() - startTime;
        dailyReadingTime += sessionTime;
        Serial.print("Reading session ended. Session time: ");
        printTime(sessionTime);
        Serial.print("Total daily reading time: ");
        printTime(dailyReadingTime);
        
        char timeStr[20];
        sprintf(timeStr, "%lu", dailyReadingTime / 1000);
        client.publish(mqtt_topic_isReading_A, "false", true);
        client.publish(mqtt_topic_totalDailyTime_A, timeStr, true);
        Serial.println("Reading duration published to MQTT!");
        startTime = 0;
    }
}

// 舵机控制函数
void openBook() {
    Serial.println("Opening the book...");
    // 直接设置舵机位置，不使用moveServos渐变
    setServoAngles(180, 0);
    Serial.println("Book is open!");
}

void closeBook() {
    Serial.println("Closing the book...");
    // 直接设置舵机位置，不使用moveServos渐变
    setServoAngles(0, 180);
    Serial.println("Book is closed!");
}

void moveServos(int startAngle, int endAngle, int step, int delayTime) {
    if (step > 0) {
        for (int angle = startAngle; angle <= endAngle; angle += step) {
            int reversedAngle = 180 - angle;
            setServoAngles(angle, reversedAngle);
            delay(delayTime);
        }
    } else {
        for (int angle = startAngle; angle >= endAngle; angle += step) {
            int reversedAngle = 180 - angle;
            setServoAngles(angle, reversedAngle);
            delay(delayTime);
        }
    }
}

void setServoAngles(int angle1, int angle2) {
  servo1.write(angle1);
  servo2.write(angle2);
}

// LED控制函数
void setLEDColor(uint8_t r, uint8_t g, uint8_t b) {
    for(int i = 0; i < NUM_LEDS; i++) {
        strip.setPixelColor(i, strip.Color(r, g, b));
    }
    strip.show();
}

// 非阻塞呼吸灯效果
void updateBreathingEffect(uint8_t red, uint8_t green, uint8_t blue) {
    unsigned long currentTime = millis();
    if (currentTime - lastBreathTime >= breathInterval) {
        if (increasing) {
            brightness += 5;
            if (brightness >= 255) {
                brightness = 255;
                increasing = false;
            }
        } else {
            brightness -= 5;
            if (brightness <= 0) {
                brightness = 0;
                increasing = true;
            }
        }
        setStripColorWithBrightness(red, green, blue, brightness);
        lastBreathTime = currentTime;
    }
}

void setStripColorWithBrightness(uint8_t red, uint8_t green, uint8_t blue, uint8_t brightness) {
    uint8_t r = (red * brightness) / 255;
    uint8_t g = (green * brightness) / 255;
    uint8_t b = (blue * brightness) / 255;
    for (int i = 0; i < strip.numPixels(); i++) {
        strip.setPixelColor(i, strip.Color(r, g, b));
    }
    strip.show();
}

// 时间格式化函数
void printTime(unsigned long milliseconds) {
    unsigned long seconds = milliseconds / 1000;
    unsigned long minutes = seconds / 60;
    seconds = seconds % 60;
    Serial.print(minutes);
    Serial.print(" minutes ");
    Serial.print(seconds);
    Serial.println(" seconds");
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
    if (elapsedTime >= pomodoroTotalTime) {
        Serial.println("Pomodoro timer completed!");
        toggleBook(); // 这将关闭书本并停止番茄钟
        return;
    }
    
    // 计算当前应该的舵机位置 (从180度开始，到0度结束)
    // 60分钟对应180度，每分钟3度
    float percentComplete = (float)elapsedTime / pomodoroTotalTime;
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