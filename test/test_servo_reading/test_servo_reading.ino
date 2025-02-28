#include <ESP32Servo.h>  // 安装 ESP32Servo 库
#include <Adafruit_NeoPixel.h>   // LED 条（NeoPixel）库
Servo servo1;  // 创建舵机对象1
Servo servo2;  // 创建舵机对象2

const int servoPin1 = 15; // 舵机1连接的GPIO
const int servoPin2 = 2;  // 舵机2连接的GPIO
const int buttonPin = 13; // 按钮连接的GPIO
#define LED_PIN 23
#define NUM_LEDS 8
Adafruit_NeoPixel strip(NUM_LEDS, LED_PIN, NEO_GRB + NEO_KHZ800);

bool isOpen = false; // 记录书的当前状态（false 表示关闭，true 表示打开）
int lastButtonState = HIGH; // 上一次按钮的状态
unsigned long lastDebounceTime = 0; // 上次去抖动时间
const unsigned long debounceDelay = 50; // 去抖动延时

void setup() {
    Serial.begin(115200);
    pinMode(buttonPin, INPUT_PULLUP); // 设置按钮引脚为输入，启用内部上拉电阻
    servo1.attach(servoPin1);  // 绑定舵机1
    servo2.attach(servoPin2);  // 绑定舵机2

}

void loop() {
    int buttonState = digitalRead(buttonPin); // 读取按钮状态

    // 检测按钮状态变化（按下事件）
    if (buttonState != lastButtonState) {
        lastDebounceTime = millis(); // 重置去抖动时间
    }

    // 去抖动处理
    if ((millis() - lastDebounceTime) > debounceDelay) {
        // 如果按钮状态稳定且为低电平（按下）
        if (buttonState == LOW) {
            // 切换书的状态
            if (isOpen) {
                closeBook();
            } else {
                openBook();
            }
            isOpen = !isOpen; // 更新书的状态
        }
    }

    lastButtonState = buttonState; // 更新按钮状态
}

// 打开书
void openBook() {
    Serial.println("Opening the book...");
    moveServos(0, 180, 10, 200); // 从0°到180°，每次增加10°，延时50ms
    Serial.println("Book is open!");
}

// 关闭书
void closeBook() {
    Serial.println("Closing the book...");
    moveServos(180, 0, -10, 200); // 从180°到0°，每次减少10°，延时50ms
    Serial.println("Book is closed!");
}

// 控制舵机运动
void moveServos(int startAngle, int endAngle, int step, int delayTime) {
    if (step > 0) {
        // 正向旋转
        for (int angle = startAngle; angle <= endAngle; angle += step) {
            int reversedAngle = 180 - angle;  // 反向旋转
            setServoAngles(angle, reversedAngle);
            delay(delayTime);
        }
    } else {
        // 反向旋转
        for (int angle = startAngle; angle >= endAngle; angle += step) {
            int reversedAngle = 180 - angle;  // 反向旋转
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