#include <Adafruit_NeoPixel.h>

// ================================
// 定义引脚及LED配置
// ================================
#define LED_PIN    23    // LED数据线连接到 ESP32 的 23 号引脚
#define NUM_LEDS   8     // LEDstick 上LED数量，根据实际情况修改

// 定义按钮连接的引脚（接按钮的一端，另一端接GND）
// 使用内部上拉电阻
#define BUTTON_PIN 13

// 创建 NeoPixel 对象，采用 GRB 顺序及 800KHz 协议
Adafruit_NeoPixel strip = Adafruit_NeoPixel(NUM_LEDS, LED_PIN, NEO_GRB + NEO_KHZ800);

// ================================
// 状态变量
// ================================
/*
   readingState 状态定义：
   0 - 初始状态（未开始阅读），LED 稳定显示红色
   1 - 阅读模式中，LED 呼吸闪烁
   2 - 阅读结束，LED 稳定显示绿色（或蓝色）
*/
int readingState = 0;
unsigned long startTime = 0;
unsigned long finishTime = 0;
unsigned long readingDuration = 0;

void setup() {
  Serial.begin(115200);
  // 设置按钮引脚为输入，上拉模式
  pinMode(BUTTON_PIN, INPUT_PULLUP);
  
  // 初始化 LED 灯带
  strip.begin();
  strip.show(); // 先关闭所有LED
}

void loop() {
  // 状态机处理不同阶段
  if (readingState == 0) {
    // 初始状态：LED稳定显示红色
    setSteadyColor(255, 0, 0);
    
    // 检查是否按下按钮
    if (digitalRead(BUTTON_PIN) == LOW) {
      delay(50);  // 简单去抖
      if (digitalRead(BUTTON_PIN) == LOW) {
        // 等待按钮释放
        while(digitalRead(BUTTON_PIN) == LOW) { delay(10); }
        // 进入阅读模式
        readingState = 1;
        startTime = millis();
        Serial.println("Reading mode started");
      }
    }
  } 
  else if (readingState == 1) {
    // 阅读模式：显示呼吸效果
    // 当呼吸效果过程中检测到按钮按下，则结束阅读
    if (breathingEffectWithInterrupt(255, 0, 0)) {
      readingState = 2;
      finishTime = millis();
      readingDuration = finishTime - startTime;
      unsigned long durations = readingDuration/1000;  // readingDuration为毫秒数
      Serial.print("Reading duration: ");
      Serial.print(durations);
      Serial.println(" seconds.");
    }
  }
  else if (readingState == 2) {
    // 阅读结束状态：LED稳定显示绿色（可改为蓝色）
    setSteadyColor(0, 255, 0);
    // 这里保持该状态，串口也只输出一次阅读时长
    delay(1000);  // 防止串口信息刷屏
  }
}

/*
  breathingEffectWithInterrupt：实现呼吸效果并允许在过程中检测按钮中断。
  如果在效果过程中检测到按钮按下，则返回 true，退出呼吸效果。
  参数 red/green/blue 为目标颜色分量（0~255）。
*/
bool breathingEffectWithInterrupt(uint8_t red, uint8_t green, uint8_t blue) {
  // 亮度上升阶段
  for (int brightness = 0; brightness < 256; brightness += 5) {
    setStripColorWithBrightness(red, green, blue, brightness);
    delay(20);
    if (digitalRead(BUTTON_PIN) == LOW) {
      delay(50);  // 去抖
      if (digitalRead(BUTTON_PIN) == LOW) {
        // 等待按钮释放
        while(digitalRead(BUTTON_PIN) == LOW) { delay(10); }
        return true;
      }
    }
  }
  // 亮度下降阶段
  for (int brightness = 255; brightness >= 0; brightness -= 5) {
    setStripColorWithBrightness(red, green, blue, brightness);
    delay(20);
    if (digitalRead(BUTTON_PIN) == LOW) {
      delay(50);  // 去抖
      if (digitalRead(BUTTON_PIN) == LOW) {
        while(digitalRead(BUTTON_PIN) == LOW) { delay(10); }
        return true;
      }
    }
  }
  return false;
}

/*
  setStripColorWithBrightness：根据给定颜色和亮度设置所有 LED。
  brightness 范围 0～255。
*/
void setStripColorWithBrightness(uint8_t red, uint8_t green, uint8_t blue, uint8_t brightness) {
  // 根据亮度调整颜色分量
  uint8_t r = (red * brightness) / 255;
  uint8_t g = (green * brightness) / 255;
  uint8_t b = (blue * brightness) / 255;
  
  for (int i = 0; i < strip.numPixels(); i++) {
    strip.setPixelColor(i, strip.Color(r, g, b));
  }
  strip.show();
}

/*
  setSteadyColor：将LED设置为稳定不闪烁的颜色。
*/
void setSteadyColor(uint8_t red, uint8_t green, uint8_t blue) {
  for (int i = 0; i < strip.numPixels(); i++) {
    strip.setPixelColor(i, strip.Color(red, green, blue));
  }
  strip.show();
}
