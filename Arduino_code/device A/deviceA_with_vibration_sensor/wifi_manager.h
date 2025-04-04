#ifndef WIFI_MANAGER_H
#define WIFI_MANAGER_H

#include <WiFi.h>
#include <WebServer.h>
#include <Preferences.h>

// AP模式参数
const char* apSSID = "ESP32-Config";
const char* apPassword = "12345678";

// 创建Web服务器实例和Preferences对象
WebServer wifiServer(80);
Preferences wifiPreferences;

// 保存的WiFi配置
String savedSSID;
String savedPassword;
bool wifiConnected = false;

// 函数前向声明
void handleRoot();
void handleConfigure(); 
void startAPMode();
String getWiFiStatusString(int status);

// HTML页面
const char* htmlPage = R"(
<!DOCTYPE html>
<html>
<head>
    <meta charset='UTF-8'>
    <title>ESP32 WiFi Config</title>
    <style>
        body { 
            font-family: Arial; 
            padding: 20px; 
            text-align: center;
            font-size: 20px;
            min-height: 100vh;
            margin: 0;
            display: flex;
            flex-direction: column;
            justify-content: flex-start;  
            padding-top: 25vh;  
        }
        h2 {
            font-size: 28px;
            margin-bottom: 30px;
        }
        .form-group { 
            margin-bottom: 25px; 
        }
        input { 
            width: 80%;
            max-width: 300px;
            padding: 10px;
            font-size: 18px;
            margin-top: 10px;
        }
        button { 
            padding: 12px 30px;
            font-size: 20px;
            background-color: #007AFF;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        label {
            font-size: 20px;
        }
    </style>
</head>
<body>
    <div>
        <h2>ESP32 WiFi Config</h2>
        <form method='post' action='/configure'>
            <div class='form-group'>
                <label>WiFi Name：</label><br>
                <input type='text' name='ssid' required>
            </div>
            <div class='form-group'>
                <label>WiFi Password：</label><br>
                <input type='password' name='password' required minlength='8'>
            </div>
            <button type='submit'>Connect</button>
        </form>
    </div>
</body>
</html>
)";

// 获取WiFi状态的字符串描述
String getWiFiStatusString(int status) {
  switch(status) {
    case WL_IDLE_STATUS:
      return "等待中";
    case WL_NO_SSID_AVAIL:
      return "找不到指定的WiFi网络";
    case WL_SCAN_COMPLETED:
      return "网络扫描完成";
    case WL_CONNECTED:
      return "连接成功";
    case WL_CONNECT_FAILED:
      return "连接失败";
    case WL_CONNECTION_LOST:
      return "连接丢失";
    case WL_DISCONNECTED:
      return "已断开连接";
    default:
      return "未知状态";
  }
}

// 处理根路径请求
void handleRoot() {
  wifiServer.send(200, "text/html", htmlPage);
}

// 处理WiFi配置
void handleConfigure();  // 先声明，再定义（前向声明的实际实现）

// 启动AP模式
void startAPMode() {
  WiFi.mode(WIFI_AP);
  
  // 设置AP模式参数
  WiFi.softAPConfig(IPAddress(192,168,4,1), IPAddress(192,168,4,1), IPAddress(255,255,255,0));
  
  // 设置WiFi通道为1，最大连接数为1
  bool result = WiFi.softAP(apSSID, apPassword, 1, false, 1);
  
  Serial.println("\nAP已开启，等待WiFi信息");
  Serial.println("AP模式配置:");
  Serial.println("- 热点名称: " + String(apSSID));
  Serial.println("- 热点密码: " + String(apPassword));
  Serial.println("- IP地址: " + WiFi.softAPIP().toString());
  Serial.println("\n请用手机或电脑连接热点，然后访问以下地址输入WiFi信息:");
  Serial.println("http://" + WiFi.softAPIP().toString());
  Serial.flush();
  
  wifiServer.on("/", HTTP_GET, handleRoot);
  wifiServer.on("/configure", HTTP_POST, handleConfigure);
  wifiServer.begin();
}

// 处理WiFi配置的完整实现
void handleConfigure() {
  Serial.println("\n收到WiFi配置信息");
  
  String ssid = wifiServer.arg("ssid");
  String password = wifiServer.arg("password");
  
  // 保存WiFi配置到Flash
  wifiPreferences.putString("ssid", ssid);
  wifiPreferences.putString("password", password);
  savedSSID = ssid;
  savedPassword = password;
  
  Serial.println("WiFi配置已保存到Flash");
  Serial.println("- WiFi名称: " + ssid);
  Serial.println("- 密码长度: " + String(password.length()) + "个字符");
  
  wifiServer.send(200, "text/html", 
    "<html><meta charset='UTF-8'>"
    "<head><style>"
    "body { "
    "    font-family: Arial; "
    "    padding: 20px; "
    "    text-align: center; "
    "    font-size: 20px; "
    "    min-height: 100vh; "
    "    margin: 0; "
    "    display: flex; "
    "    flex-direction: column; "
    "    justify-content: flex-start; "  
    "    padding-top: 25vh; "  
    "}"
    "h2 { font-size: 28px; margin-bottom: 30px; }"
    "p { font-size: 20px; line-height: 1.5; }"
    "</style></head>"
    "<body>"
    "<div>"
    "<h2>正在尝试连接WiFi，请稍候...</h2>"
    "<p>配置已保存，下次会先根据历史数据自动尝试连接</p>"
    "<p>如果连接失败，请重新连接ESP32-Config热点并重试</p>"
    "</div>"
    "</body></html>"
  );
  
  // 尝试连接WiFi
  WiFi.disconnect();
  delay(1000);
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid.c_str(), password.c_str());
  
  Serial.println("\n开始连接WiFi...");
  
  // 等待连接
  int attempts = 0;
  while (WiFi.status() != WL_CONNECTED && attempts < 30) {
    delay(1000);
    Serial.print(".");
    if(attempts % 5 == 0) {
      Serial.println();
      Serial.println("尝试次数: " + String(attempts + 1) + "次");
      Serial.println("WiFi状态: " + getWiFiStatusString(WiFi.status()) + " (" + String(WiFi.status()) + ")");
    }
    attempts++;
  }
  
  if (WiFi.status() == WL_CONNECTED) {
    Serial.println("\nWiFi连接成功！");
    Serial.println("连接信息:");
    Serial.println("- SSID: " + String(WiFi.SSID()));
    Serial.println("- IP地址: " + WiFi.localIP().toString());
    Serial.println("- 信号强度: " + String(WiFi.RSSI()) + " dBm");
    wifiConnected = true;
  } else {
    Serial.println("\nWiFi连接失败！");
    Serial.println("失败状态: " + getWiFiStatusString(WiFi.status()));
    Serial.println("\n请检查WiFi密码是否正确（至少8个字符）");

    // 连接失败时重启AP模式
    startAPMode();
  }
}

// 初始化WiFi管理器
bool setupWiFiManager() {
  Serial.println("\nESP32启动中...");
  
  // 从Flash读取保存的WiFi信息
  wifiPreferences.begin("wifi-config", false);
  savedSSID = wifiPreferences.getString("ssid", "");
  savedPassword = wifiPreferences.getString("password", "");
  
  if (savedSSID != "" && savedPassword != "") {
    // 如果有保存的WiFi信息，尝试连接
    Serial.println("尝试根据历史WiFi信息连接...");
    Serial.println("历史WiFi名称: " + savedSSID);
    
    WiFi.mode(WIFI_STA);
    WiFi.begin(savedSSID.c_str(), savedPassword.c_str());
    
    int attempts = 0;
    while (WiFi.status() != WL_CONNECTED && attempts < 20) {
      delay(500);
      Serial.print(".");
      attempts++;
    }
    
    if (WiFi.status() == WL_CONNECTED) {
      Serial.println("\nWiFi连接成功！");
      Serial.println("连接信息:");
      Serial.println("- SSID: " + String(WiFi.SSID()));
      Serial.println("- IP地址: " + WiFi.localIP().toString());
      Serial.println("- 信号强度: " + String(WiFi.RSSI()) + " dBm");
      wifiConnected = true;
      return true;  // 如果连接成功，不启用AP模式
    }
    
    Serial.println("\n使用历史配置连接失败。准备启动配置模式");
  } else {
    Serial.println("根据历史数据，没有合适的WiFi可连接");
  } 

  // 如果没有保存配置或连接失败，启用AP模式
  startAPMode();
  return false;
}

// 检查和管理WiFi连接
void checkWiFiConnection() {
  // 处理Web服务器请求
  wifiServer.handleClient();
  
  // 检查WiFi连接状态
  static bool wasConnected = false;  // 记录上次连接状态的静态变量
  
  if (WiFi.status() == WL_CONNECTED) {
    if (!wasConnected) {  // 如果之前是断开状态，现在连接成功
      Serial.println("\nWiFi重新连接成功。");
      Serial.println("连接信息:");
      Serial.println("- SSID: " + String(WiFi.SSID()));
      Serial.println("- IP地址: " + WiFi.localIP().toString());
      Serial.println("- 信号强度: " + String(WiFi.RSSI()) + " dBm");
      wasConnected = true;
      wifiConnected = true;
    }
  } else {
    if (wasConnected) {  // 如果之前是连接状态，现在断开了
      Serial.println("\nWiFi已断开");
      wasConnected = false;
      wifiConnected = false;
    }
    
    // 如果是STA模式且未连接，尝试重新连接
    if (WiFi.getMode() == WIFI_STA) {
      static unsigned long lastAttempt = 0;
      unsigned long currentMillis = millis();
      
      // 每30秒尝试重新连接一次
      if (currentMillis - lastAttempt > 30000) {
        Serial.println("\n检测到WiFi断开，尝试重新连接...");
        WiFi.begin(savedSSID.c_str(), savedPassword.c_str());
        lastAttempt = currentMillis;
      }
    }
  }
}

#endif // WIFI_MANAGER_H