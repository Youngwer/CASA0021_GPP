#include <ESP32Servo.h>         // ESP32Servo 库
#include <Adafruit_NeoPixel.h>  // NeoPixel 库
#include <WiFi.h>              // WiFi 库
#include <PubSubClient.h>      // MQTT 库

Servo servo1;  // 创建舵机对象1
Servo servo2;  // 创建舵机对象2

// 引脚定义
const int servoPin1 = 15;  // 舵机1连接的GPIO
const int servoPin2 = 2;   // 舵机2连接的GPIO
const int buttonPin = 13;  // 按钮连接的GPIO
#define LED_PIN    23      // LED数据线引脚
#define NUM_LEDS   8       // LED数量

Adafruit_NeoPixel strip(NUM_LEDS, LED_PIN, NEO_GRB + NEO_KHZ800);

// MQTT 配置
const char* ssid          = "CE-Hub-Student";
const char* password      = "casa-ce-gagarin-public-service";
const char* mqtt_username = "student";
const char* mqtt_password = "ce2021-mqtt-forget-whale";
const char* mqtt_server   = "mqtt.cetools.org";
const int   mqtt_port     = 1884;
const char* mqtt_topic_isReading  = "student/ucfnwy2/DeviceA/isReading";
const char* mqtt_topic_totalDailyTime = "student/ucfnwy2/DeviceA/totalDailyTime";

WiFiClient espClient;
PubSubClient client(espClient);

// 状态变量
bool isOpen = false;            // 书的状态
int lastButtonState = HIGH;     // 上一次按钮状态
unsigned long lastDebounceTime = 0;
const unsigned long debounceDelay = 50;

// 阅读时间变量
unsigned long startTime = 0;
unsigned long dailyReadingTime = 0;
unsigned long lastResetTime = 0;

// 实时更新相关变量
unsigned long lastUpdateTime = 0;  // 上次更新MQTT的时间
const unsigned long updateInterval = 10000;  // 更新间隔（10秒）

void setup() {
    Serial.begin(115200);
    pinMode(buttonPin, INPUT_PULLUP);
    servo1.attach(servoPin1);
    servo2.attach(servoPin2);
    
    strip.begin();
    strip.show();
    strip.setBrightness(50);
    
    lastResetTime = millis();
    
    connectToWiFi();
    client.setServer(mqtt_server, mqtt_port);
    Serial.println("Setup complete");
}

void loop() {
    if (!client.connected()) {
        reconnectMQTT();
    }
    client.loop();
    
    checkDailyReset();
    
    // 实时更新阅读时间
    updateReadingTime();

    int buttonState = digitalRead(buttonPin);

    if (buttonState != lastButtonState) {
        lastDebounceTime = millis();
    }

    if ((millis() - lastDebounceTime) > debounceDelay) {
        if (buttonState == LOW) {
            if (isOpen) {
                closeBook();
                setLEDColor(0, 0, 0);
                stopReadingTimer();
            } else {
                openBook();
                setLEDColor(255, 0, 0);
                startReadingTimer();
            }
            isOpen = !isOpen;
        }
    }

    lastButtonState = buttonState;
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
        } else {
            Serial.print("Failed, rc=");
            Serial.print(client.state());
            Serial.println(" - trying again in 5 seconds");
            delay(5000);
        }
    }
}

// 实时更新阅读时间到MQTT
void updateReadingTime() {
    if (isOpen && startTime > 0) {  // 如果正在阅读
        unsigned long currentTime = millis();
        if (currentTime - lastUpdateTime >= updateInterval) {
            unsigned long currentSessionTime = currentTime - startTime;
            unsigned long totalTime = dailyReadingTime + currentSessionTime;
            
            // 发布当前总时间
            char timeStr[20];
            sprintf(timeStr, "%lu", totalTime / 1000);
            client.publish(mqtt_topic_totalDailyTime, timeStr, true);
            Serial.print("Updated total reading time to MQTT: ");
            printTime(totalTime);
            
            lastUpdateTime = currentTime;
        }
    }
}

// 阅读时间相关函数
void checkDailyReset() {
    unsigned long currentTime = millis();
    if (currentTime - lastResetTime >= 86400000) {
        Serial.print("New day started! Previous day's reading time: ");
        printTime(dailyReadingTime);
        
        client.publish(mqtt_topic_isReading, "false", true);
        client.publish(mqtt_topic_totalDailyTime, "0", true);
        
        dailyReadingTime = 0;
        lastResetTime = currentTime;
    }
}

void startReadingTimer() {
    startTime = millis();
    lastUpdateTime = startTime;  // 重置更新时间
    Serial.println("Reading session started!");
    
    char timeStr[20];
    sprintf(timeStr, "%lu", dailyReadingTime / 1000);
    client.publish(mqtt_topic_isReading, "true", true);
    client.publish(mqtt_topic_totalDailyTime, timeStr, true);
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
        client.publish(mqtt_topic_isReading, "false", true);
        client.publish(mqtt_topic_totalDailyTime, timeStr, true);
        Serial.println("Reading duration published to MQTT!");
        startTime = 0;
    }
}

// 舵机控制函数
void openBook() {
    Serial.println("Opening the book...");
    moveServos(0, 180, 10, 200);
    Serial.println("Book is open!");
}

void closeBook() {
    Serial.println("Closing the book...");
    moveServos(180, 0, -10, 200);
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