#include <ESP32Servo.h>         // ESP32Servo 库
#include <Adafruit_NeoPixel.h>  // NeoPixel 库

// 引脚定义
const int servoPin = 2;         // 舵机引脚
const int touchPin = 13;        // TTP223 触摸传感器信号引脚
#define LED_PIN    23           // LED 灯条引脚 (D26)
#define NUM_LEDS   8            // LED 数量

// 舵机和 LED 灯条对象
Servo servo;
Adafruit_NeoPixel strip(NUM_LEDS, LED_PIN, NEO_GRB + NEO_KHZ800);

// 状态变量
bool ledState = false;          // LED 状态（false: 关闭, true: 开启）
bool servoState = false;        // 舵机状态（false: 关闭, true: 开启）
bool lastTouchState = LOW;      // 上次触摸状态
bool longPressTriggered = false;  // 是否触发了长按
unsigned long touchStartTime = 0;  // 触摸开始时间
const unsigned long longPressDuration = 5000;  // 长按时长（5秒）

void setup() {
    Serial.begin(115200);
    
    // 初始化舵机
    servo.attach(servoPin);
    servo.write(0);  // 初始位置（关闭）

    // 初始化 LED 灯条
    strip.begin();
    strip.show();
    strip.setBrightness(50);
    setLEDColor(0, 0, 0);  // 初始关闭 LED

    // 初始化触摸传感器引脚
    pinMode(touchPin, INPUT);
    Serial.println("Setup complete");
}

void loop() {
    // 读取触摸传感器状态
    bool currentTouchState = digitalRead(touchPin);

    // 检测触摸按下（上升沿）
    if (currentTouchState == HIGH && lastTouchState == LOW) {
        touchStartTime = millis();  // 记录触摸开始时间
        longPressTriggered = false;  // 重置长按标志
        Serial.println("Touch detected");
    }

    // 检测触摸松开（下降沿）
    if (currentTouchState == LOW && lastTouchState == HIGH) {
        unsigned long touchDuration = millis() - touchStartTime;
        // 只有在未触发长按的情况下，才认为是短按
        if (touchDuration < longPressDuration && !longPressTriggered) {
            // 短按：切换 LED 状态
            ledState = !ledState;
            if (ledState) {
                setLEDColor(255, 255, 255);  // 白色（点亮）
                Serial.println("LED turned ON");
            } else {
                setLEDColor(0, 0, 0);  // 关闭
                Serial.println("LED turned OFF");
            }
        }
        longPressTriggered = false;  // 松手后重置长按标志
    }

    // 检测长按（5秒）
    if (currentTouchState == HIGH && (millis() - touchStartTime >= longPressDuration)) {
        // 长按：切换舵机状态
        servoState = !servoState;
        if (servoState) {
            moveServo(0, 180, 10, 20);  // 打开（0 -> 180 度）
            Serial.println("Servo opened");
        } else {
            moveServo(180, 0, -10, 20);  // 关闭（180 -> 0 度）
            Serial.println("Servo closed");
        }
        longPressTriggered = true;  // 标记长按已触发
        touchStartTime = millis();  // 重置 touchStartTime，避免重复触发长按
    }

    lastTouchState = currentTouchState;
}

// 设置 LED 颜色
void setLEDColor(uint8_t r, uint8_t g, uint8_t b) {
    for (int i = 0; i < NUM_LEDS; i++) {
        strip.setPixelColor(i, strip.Color(r, g, b));
    }
    strip.show();
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