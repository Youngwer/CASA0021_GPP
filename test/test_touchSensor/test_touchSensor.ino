#include <ESP32Servo.h>         // ESP32Servo 库
#include <Adafruit_NeoPixel.h>

// 定义引脚
#define BUTTON_PIN 13     // 按钮连接到D13
#define SERVO_PIN 2       // 舵机连接到D2
#define LED_PIN 25        // WS2812 LED灯带连接到D25
#define LED_COUNT 12      // LED灯带数量为12

// 创建对象
Servo myServo;
Adafruit_NeoPixel strip(LED_COUNT, LED_PIN, NEO_GRB + NEO_KHZ800);

// 状态变量
bool servoState = false;   // 舵机状态（false为关闭）
bool ledState = false;     // LED灯状态（false为关闭）
bool buttonPressed = false;
unsigned long buttonPressTime = 0;
const long longPressTime = 3000;  // 长按定义为3秒
bool longPressTriggered = false;  // 长按是否已触发标志

void setup() {
  // 初始化串口
  Serial.begin(115200);
  
  // 初始化按钮引脚为输入，使用内部上拉电阻
  pinMode(BUTTON_PIN, INPUT_PULLUP);
  
  // 初始化舵机
  myServo.attach(SERVO_PIN);
  myServo.write(0);  // 初始位置为0度
  
  // 初始化LED灯带
  strip.begin();
  strip.show();  // 初始化为全部关闭
  strip.setBrightness(50);  // 设置亮度（0-255）
}

void loop() {
  // 检测按钮状态
  checkButton();
}

void checkButton() {
  // 读取按钮状态（低电平为按下）
  bool currentState = !digitalRead(BUTTON_PIN);
  
  // 按钮按下
  if (currentState && !buttonPressed) {
    buttonPressed = true;
    buttonPressTime = millis();
    longPressTriggered = false;
    Serial.println("按钮被按下");
  } 
  
  // 按钮持续按下，检查是否达到长按时间
  else if (currentState && buttonPressed) {
    unsigned long pressDuration = millis() - buttonPressTime;
    
    // 达到长按时间且尚未触发长按动作
    if (pressDuration >= longPressTime && !longPressTriggered) {
      toggleServo();
      longPressTriggered = true;  // 设置标志，防止重复触发
      Serial.println("长按3秒检测到，切换舵机状态");
    }
  }
  
  // 按钮释放
  else if (!currentState && buttonPressed) {
    unsigned long pressDuration = millis() - buttonPressTime;
    buttonPressed = false;
    
    // 短按（小于3秒）且没有触发过长按动作 - 控制LED灯
    if (pressDuration < longPressTime && !longPressTriggered) {
      toggleLED();
      Serial.println("短按检测到，切换LED状态");
    }
    
    // 重置长按触发标志
    longPressTriggered = false;
  }
}

// 切换舵机状态
void toggleServo() {
  servoState = !servoState;
  
  if (servoState) {
    // 打开舵机（旋转到180度）
    myServo.write(180);
    Serial.println("舵机：开启（180度）");
  } else {
    // 关闭舵机（旋转到0度）
    myServo.write(0);
    Serial.println("舵机：关闭（0度）");
  }
}

// 切换LED灯状态
void toggleLED() {
  ledState = !ledState;
  
  if (ledState) {
    // 打开LED灯（设置为蓝色）
    for (int i = 0; i < LED_COUNT; i++) {
      strip.setPixelColor(i, strip.Color(0, 0, 255));
    }
    strip.show();
    Serial.println("LED灯带：开启");
  } else {
    // 关闭LED灯
    strip.clear();
    strip.show();
    Serial.println("LED灯带：关闭");
  }
}