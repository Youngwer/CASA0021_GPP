#ifndef WIFI_MANAGER_H
#define WIFI_MANAGER_H

#include <WiFi.h>
#include <WebServer.h>
#include <Preferences.h>

class WiFiManager {
  private:
    // Set AP mode parameters
    const char* apSSID = "ESP32-Config";
    const char* apPassword = "12345678";
    
    // Web server instance and Preferences object
    WebServer* server;
    Preferences preferences;
    
    // Save wifi configuration
    String savedSSID;
    String savedPassword;
    
    // HTML page
    const char* html = R"(
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
                <button type='submit'> Connect</button>
            </form>
        </div>
    </body>
    </html>
    )";
    
    // Helper methods
    void startAPMode() {
      WiFi.mode(WIFI_AP);
      //WiFi.softAP(apSSID, apPassword);
      // Set AP mode parameters
      WiFi.softAPConfig(IPAddress(192,168,4,1), IPAddress(192,168,4,1), IPAddress(255,255,255,0));
      
      // Set the WiFi channel to 1 and the maximum number of connections to 1
      bool result = WiFi.softAP(apSSID, apPassword, 1, false, 1);
      
      Serial.println("\nAP turned on, waiting for wifi information");
      Serial.println("AP mode configuration：");
      Serial.println("- Hotspot name " + String(apSSID));
      Serial.println("- Hotspot password: " + String(apPassword));
      Serial.println("- IP address: " + WiFi.softAPIP().toString());
      Serial.println("\nPlease connect to the hotspot with your mobile phone or computer and then visit the following address to input WiFi information：");
      Serial.println("http://" + WiFi.softAPIP().toString());
      Serial.flush();
      
      server->on("/", HTTP_GET, [this]() { this->handleRoot(); });
      server->on("/configure", HTTP_POST, [this]() { this->handleConfigure(); });
      server->begin();
    }
    
    void handleRoot() {
      server->send(200, "text/html", html);
    }
    
    void handleConfigure() {
      Serial.println("\nReceived wifi configuration information");
      
      String ssid = server->arg("ssid");
      String password = server->arg("password");
      
      // save wifi configuration into Flash
      preferences.putString("ssid", ssid);
      preferences.putString("password", password);
      savedSSID = ssid;
      savedPassword = password;
      
      Serial.println("This WiFi configuration has been saved to Flash");
      Serial.println("- WiFi name: " + ssid);
      Serial.println("- Password length: " + String(password.length()) + " characters");
      
      server->send(200, "text/html", 
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
        "<h2>Trying to connect WiFi, please wait...</h2>"
        "<p>The configuration has been saved, and the connection will be automatically attempted based on historical data first next time</p>"
        "<p>If the connection fails, reconnect to the ESP32-Config hotspot and try again</p>"
        "</div>"
        "</body></html>"
      );
      
      // trying to connect WiFi
      WiFi.disconnect();
      delay(1000);
      WiFi.mode(WIFI_STA);
      WiFi.begin(ssid.c_str(), password.c_str());
      
      Serial.println("\nStart to connect WiFi...");
      
      // waiting for connecting
      int attempts = 0;
      while (WiFi.status() != WL_CONNECTED && attempts < 30) {
        delay(1000);
        Serial.print(".");
        if(attempts % 5 == 0) {
          Serial.println();
          Serial.println("Attempts: " + String(attempts + 1) + " times");
          Serial.println("WiFi status: " + getWiFiStatusString(WiFi.status()) + " (" + String(WiFi.status()) + ")");
        }
        attempts++;
      }
      
      if (WiFi.status() == WL_CONNECTED) {
        Serial.println("\nWiFi connection successful！");
        Serial.println("information");
        Serial.println("- SSID: " + String(WiFi.SSID()));
        Serial.println("- IP address: " + WiFi.localIP().toString());
        Serial.println("- Signal: " + String(WiFi.RSSI()) + " dBm");
      } else {
        Serial.println("\nWiFi connection failed ！");
        Serial.println("failed status: " + getWiFiStatusString(WiFi.status()));
        Serial.println("\nPlease check if the WiFi password is correct (at least 8 characters)");

        // Restart the AP mode when the connection fails
        WiFi.mode(WIFI_AP);
        WiFi.softAP(apSSID, apPassword);
        Serial.println("\nAP mode has been restarted, please reconnect to ESP32-Config for configuration");
      }
    }
    
    String getWiFiStatusString(int status) {
      switch(status) {
        case WL_IDLE_STATUS:
          return "Waiting";
        case WL_NO_SSID_AVAIL:
          return "The specified WiFi network could not be found";
        case WL_SCAN_COMPLETED:
          return "Network scan complete";
        case WL_CONNECTED:
          return "Connection succeeded";
        case WL_CONNECT_FAILED:
          return "Connection failed";
        case WL_CONNECTION_LOST:
          return "Connection lost";
        case WL_DISCONNECTED:
          return "Disconnected";
        default:
          return "Unknown status";
      }
    }
    
  public:
    WiFiManager() {
      server = new WebServer(80);
    }
    
    ~WiFiManager() {
      if (server) {
        delete server;
      }
    }
    
    void begin() {
      Serial.println("\nInitializing WiFi Manager...");
      
      // Read the saved WiFi information from Flash
      preferences.begin("wifi-config", false);
      savedSSID = preferences.getString("ssid", "");
      savedPassword = preferences.getString("password", "");
      
      if (savedSSID != "" && savedPassword != "") {
        // If there is saved WiFi information, try to connect
        Serial.println("Trying to connect to wifi based on historical wifi information...");
        Serial.println("Historical WiFi name: " + savedSSID);
        
        WiFi.mode(WIFI_STA);
        WiFi.begin(savedSSID.c_str(), savedPassword.c_str());
        
        int attempts = 0;
        while (WiFi.status() != WL_CONNECTED && attempts < 20) {
          delay(500);
          Serial.print(".");
          attempts++;
        }
        
        if (WiFi.status() == WL_CONNECTED) {
          Serial.println("\nWiFi connection success！");
          Serial.println("connect information：");
          Serial.println("- SSID: " + String(WiFi.SSID()));
          Serial.println("- IP address: " + WiFi.localIP().toString());
          Serial.println("- Signal: " + String(WiFi.RSSI()) + " dBm");
          return;  // If the connection is successful, the AP mode is not enabled
        }
        
        Serial.println("\nFailed to use the historical configuration connection. Prepare to start the configuration mode");
      } else {
        Serial.println("Based on historical data, there is no suitable wifi to connect");
      } 

      // If no configuration is saved or the connection fails, enable AP mode
      startAPMode();
    }
    
    void update() {
      // Processing Web server request
      server->handleClient();
      
      // Check the WiFi connection status
      static bool wasConnected = false;  // Add a static variable to record the state of the last connection
      
      if (WiFi.status() == WL_CONNECTED) {
        if (!wasConnected) {  // If it was disconnected before, the connection is now successful
          Serial.println("\nThe WiFi reconnection is successful.");
          Serial.println("Connection information：");
          Serial.println("- SSID: " + String(WiFi.SSID()));
          Serial.println("- IP address: " + WiFi.localIP().toString());
          Serial.println("- Signal: " + String(WiFi.RSSI()) + " dBm");
          wasConnected = true;
        }
      } else {
        if (wasConnected) {  // If it was connected before, but it's disconnected now
          Serial.println("\nWiFi disconnected");
          wasConnected = false;
        }
        
        // If it is in STA mode and is not connected, trying to reconnect
        if (WiFi.getMode() == WIFI_STA) {
          static unsigned long lastAttempt = 0;
          unsigned long currentMillis = millis();
          
          // Try to reconnect every 30 seconds
          if (currentMillis - lastAttempt > 30000) {
            Serial.println("\nWiFi disconnection detected, trying to reconnect...");
            WiFi.begin(savedSSID.c_str(), savedPassword.c_str());
            lastAttempt = currentMillis;
          }
        }
      }
    }
    
    bool isConnected() {
      return WiFi.status() == WL_CONNECTED;
    }
};

#endif // WIFI_MANAGER_H