#include <WiFi.h>
#include <PubSubClient.h>

// ================================
// WiFi 和 MQTT 配置
// ================================
const char* ssid          = "CE-Hub-Student";          // WiFi SSID
const char* password      = "casa-ce-gagarin-public-service"; // WiFi 密码
const char* mqtt_username = "student";                // MQTT 用户名
const char* mqtt_password = "ce2021-mqtt-forget-whale"; // MQTT 密码
const char* mqtt_server   = "mqtt.cetools.org";       // MQTT Broker 地址
const int   mqtt_port     = 1884;                     // MQTT Broker 端口

// 定义 MQTT 主题
const char* mqtt_topic_A = "student/ucfnwy2/DeviceA/time"; // 订阅 Device A 的主题

WiFiClient espClient;
PubSubClient client(espClient);

// ================================
// 初始化函数
// ================================
void setup() {
  Serial.begin(115200);

  // 连接 WiFi
  connectToWiFi();

  // 设置 MQTT Broker 和回调函数
  client.setServer(mqtt_server, mqtt_port);
  client.setCallback(callback);

  // 连接 MQTT
  reconnectMQTT();

  Serial.println("Device B setup complete");
}

void loop() {
  // 检查 MQTT 连接
  if (!client.connected()) {
    reconnectMQTT();
  }

  // 保持 MQTT 客户端的后台任务
  client.loop();
}

// ================================
// MQTT 回调函数
// ================================
void callback(char* topic, byte* payload, unsigned int length) {
  // 当接收到订阅主题的消息时，通过串口打印出来
  Serial.print("Message arrived [");
  Serial.print(topic);
  Serial.print("]: ");

  // 将 payload 转换为字符串
  char message[length + 1];
  for (unsigned int i = 0; i < length; i++) {
    message[i] = (char)payload[i];
  }
  message[length] = '\0';  // 添加字符串结束符

  // 打印接收到的消息
  Serial.println(message);

  // 解析并打印阅读时间
  if (strcmp(topic, mqtt_topic_A) == 0) {
    // 假设消息格式为 {"time": "XX seconds"}
    char* time_start = strstr(message, "\"time\": \"");
    if (time_start != NULL) {
      time_start += 9;  // 移动到时间值的起始位置
      char* time_end = strchr(time_start, '\"');
      if (time_end != NULL) {
        *time_end = '\0';  // 结束字符串
        Serial.print("Reading time from Device A: ");
        Serial.println(time_start);
      }
    }
  }
}

// ================================
// WiFi 和 MQTT 连接函数
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
    String clientId = "DeviceB_ESP32_";
    clientId += String(random(0xffff), HEX);
    if (client.connect(clientId.c_str(), mqtt_username, mqtt_password)) {
      Serial.println("Connected to MQTT broker");
      // 订阅 Device A 的主题
      if (client.subscribe(mqtt_topic_A)) {
        Serial.print("Subscribed to topic: ");
        Serial.println(mqtt_topic_A);
      } else {
        Serial.print("Failed to subscribe to topic: ");
        Serial.println(mqtt_topic_A);
      }
    } else {
      Serial.print("Failed, rc=");
      Serial.print(client.state());
      Serial.println(" - trying again in 5 seconds");
      delay(5000);
    }
  }
}