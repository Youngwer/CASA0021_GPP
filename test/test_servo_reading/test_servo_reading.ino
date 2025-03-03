#include <ESP32Servo.h>         // 安装 ESP32Servo 库
#include <Adafruit_NeoPixel.h>  // LED 条（NeoPixel）库

Servo servo1;  // 创建舵机对象1
Servo servo2;  // 创建舵机对象2

const int servoPin1 = 15;  // 舵机1连接的GPIO
const int servoPin2 = 2;   // 舵机2连接的GPIO
const int buttonPin = 13;  // 按钮连接的GPIO
#define LED_PIN    23      // LED数据线连接到 ESP32 的 23 号引脚
#define NUM_LEDS   8       // LED条上的LED数量
Adafruit_NeoPixel strip(NUM_LEDS, LED_PIN, NEO_GRB + NEO_KHZ800);

bool isOpen = false;            // 记录书的当前状态
int lastButtonState = HIGH;     // 上一次按钮的状态
unsigned long lastDebounceTime = 0;  // 上次去抖动时间
const unsigned long debounceDelay = 50;  // 去抖动延时

// 阅读时间相关变量
unsigned long startTime = 0;        // 本次阅读开始时间
unsigned long dailyReadingTime = 0; // 每日总阅读时间（毫秒）
unsigned long lastResetTime = 0;    // 上次重置时间

void setup() {
    Serial.begin(115200);
    pinMode(buttonPin, INPUT_PULLUP);
    servo1.attach(servoPin1);
    servo2.attach(servoPin2);
    
    strip.begin();
    strip.show();
    strip.setBrightness(50);
    
    lastResetTime = millis();  // 初始化重置时间
}

void loop() {
    checkDailyReset();  // 检查是否需要每日重置
    int buttonState = digitalRead(buttonPin);

    if (buttonState != lastButtonState) {
        lastDebounceTime = millis();
    }

    if ((millis() - lastDebounceTime) > debounceDelay) {
        if (buttonState == LOW) {
            if (isOpen) {
                closeBook();
                setLEDColor(0, 0, 0);
                stopReadingTimer();  // 停止计时并记录
            } else {
                openBook();
                setLEDColor(255, 0, 0);
                startReadingTimer();  // 开始计时
            }
            isOpen = !isOpen;
        }
    }

    lastButtonState = buttonState;
}

// 检查是否需要每日重置
void checkDailyReset() {
    unsigned long currentTime = millis();
    // 检查是否过了一天 (86400000毫秒 = 24小时)
    if (currentTime - lastResetTime >= 86400000) {
        Serial.print("New day started! Previous day's reading time: ");
        printTime(dailyReadingTime);
        dailyReadingTime = 0;    // 重置每日阅读时间
        lastResetTime = currentTime;  // 更新重置时间
    }
}

// 开始阅读计时
void startReadingTimer() {
    startTime = millis();
    Serial.println("Reading session started!");
}

// 停止阅读计时并记录
void stopReadingTimer() {
    if (startTime > 0) {
        unsigned long sessionTime = millis() - startTime;
        dailyReadingTime += sessionTime;
        Serial.print("Reading session ended. Session time: ");
        printTime(sessionTime);
        Serial.print("Total daily reading time: ");
        printTime(dailyReadingTime);
        startTime = 0;
    }
}

// 打开书
void openBook() {
    Serial.println("Opening the book...");
    moveServos(0, 180, 10, 200);
    Serial.println("Book is open!");
}

// 关闭书
void closeBook() {
    Serial.println("Closing the book...");
    moveServos(180, 0, -10, 200);
    Serial.println("Book is closed!");
}

// 控制舵机运动
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

// 设置舵机角度
void setServoAngles(int angle1, int angle2) {
    servo1.write(angle1);
    servo2.write(angle2);
}

// 设置LED颜色
void setLEDColor(uint8_t r, uint8_t g, uint8_t b) {
    for(int i = 0; i < NUM_LEDS; i++) {
        strip.setPixelColor(i, strip.Color(r, g, b));
    }
    strip.show();
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