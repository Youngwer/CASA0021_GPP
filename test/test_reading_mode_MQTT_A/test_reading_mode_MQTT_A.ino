#include <WiFi.h>
#include <PubSubClient.h>
#include <Adafruit_NeoPixel.h>

// ================================
// 定义引脚及LED配置
// ================================
#define LED_PIN    23    // LED数据线连接到 ESP32 的 23 号引脚
#define NUM_LEDS   8     // LEDstick 上LED数量，根据实际情况修改
#define BUTTON_PIN 13    // 按钮引脚（接按钮的一端，另一端接GND）

// 创建 NeoPixel 对象，采用 GRB 顺序及 800KHz 协议
Adafruit_NeoPixel strip = Adafruit_NeoPixel(NUM_LEDS, LED_PIN, NEO_GRB + NEO_KHZ800);

// ================================
// MQTT 配置
// ================================
const char* ssid          = "CE-Hub-Student";          // WiFi SSID
const char* password      = "casa-ce-gagarin-public-service"; // WiFi 密码
const char* mqtt_username = "student";                // MQTT 用户名
const char* mqtt_password = "ce2021-mqtt-forget-whale"; // MQTT 密码
const char* mqtt_server   = "mqtt.cetools.org";       // MQTT Broker 地址
const int   mqtt_port     = 1884;                     // MQTT Broker 端口

// 定义 MQTT 主题
const char* mqtt_topic_A = "student/ucfnwy2/DeviceA/time";

WiFiClient espClient;
PubSubClient client(espClient);

// ================================
// 状态变量
// ================================
int readingState = 0;              // 阅读状态
unsigned long startTime = 0;       // 阅读开始时间
unsigned long finishTime = 0;      // 阅读结束时间
unsigned long readingDuration = 0; // 阅读时长

void setup() {
  Serial.begin(115200);

  // 设置按钮引脚为输入，上拉模式
  pinMode(BUTTON_PIN, INPUT_PULLUP);

  // 初始化 LED 灯带
  strip.begin();
  strip.show(); // 先关闭所有LED

  // 连接 WiFi 和 MQTT
  connectToWiFi();
  client.setServer(mqtt_server, mqtt_port);
  Serial.println("Setup complete");
}

void loop() {
  // 检查 MQTT 连接
  if (!client.connected()) {
    reconnectMQTT();
  }
  client.loop(); // 保持 MQTT 客户端的后台任务

  // 状态机处理不同阶段
  if (readingState == 0) {
    // 初始状态：LED稳定显示红色
    setSteadyColor(255, 0, 0);

    // 检查是否按下按钮
    if (digitalRead(BUTTON_PIN) == LOW) {
      delay(50);  // 简单去抖
      if (digitalRead(BUTTON_PIN) == LOW) {
        // 等待按钮释放
        while (digitalRead(BUTTON_PIN) == LOW) { delay(10); }
        // 进入阅读模式
        readingState = 1;
        startTime = millis();
        Serial.println("Reading mode started");
      }
    }
  } else if (readingState == 1) {
    // 阅读模式：显示呼吸效果
    if (breathingEffectWithInterrupt(255, 0, 0)) {
      readingState = 2;
      finishTime = millis();
      readingDuration = finishTime - startTime;
      unsigned long durations = readingDuration / 1000;  // 转换为秒
      Serial.print("Reading duration: ");
      Serial.print(durations);
      Serial.println(" seconds.");

      // 发布阅读时长到 MQTT
      char time_message[50];
      sprintf(time_message, "{\"time\": \"%lu seconds\"}", durations);
      if (client.publish(mqtt_topic_A, time_message)) {
        Serial.println("Reading duration published to MQTT!");
      } else {
        Serial.println("Failed to publish reading duration.");
      }
    }
  } else if (readingState == 2) {
    // 阅读结束状态：LED稳定显示绿色
    setSteadyColor(0, 255, 0);
    delay(1000);  // 防止串口信息刷屏
  }
}

// ================================
// LED 控制函数
// ================================
bool breathingEffectWithInterrupt(uint8_t red, uint8_t green, uint8_t blue) {
  // 亮度上升阶段
  for (int brightness = 0; brightness < 256; brightness += 5) {
    setStripColorWithBrightness(red, green, blue, brightness);
    delay(20);
    if (digitalRead(BUTTON_PIN) == LOW) {
      delay(50);  // 去抖
      if (digitalRead(BUTTON_PIN) == LOW) {
        while (digitalRead(BUTTON_PIN) == LOW) { delay(10); }
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
        while (digitalRead(BUTTON_PIN) == LOW) { delay(10); }
        return true;
      }
    }
  }
  return false;
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

void setSteadyColor(uint8_t red, uint8_t green, uint8_t blue) {
  for (int i = 0; i < strip.numPixels(); i++) {
    strip.setPixelColor(i, strip.Color(red, green, blue));
  }
  strip.show();
}

// ================================
// WiFi 和 MQTT 函数
// ================================
void connectToWiFi() {
  Serial.print("Connecting to WiFi network: ");
  Serial.println(ssid);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.println("WiFi connected.");
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