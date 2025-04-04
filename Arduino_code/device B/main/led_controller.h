#ifndef LED_CONTROLLER_H
#define LED_CONTROLLER_H

#include "config.h"

// 呼吸灯相关变量
int brightness = 0;                      // 当前亮度（0-255）
bool increasing = true;                  // 亮度是否在增加
unsigned long lastBreathTime = 0;        // 上次呼吸灯更新时间

// 设置所有主LED灯带的颜色
void setLEDColor(uint8_t r, uint8_t g, uint8_t b) {
    // 设置第一个灯带（引脚23）
    for (int i = 0; i < NUM_LEDS; i++) {
        strip.setPixelColor(i, strip.Color(r, g, b));
    }
    strip.show();
    
    // 设置第二个灯带（引脚22），保持与第一个灯带同步
    for (int i = 0; i < NUM_LEDS; i++) {
        strip2.setPixelColor(i, strip2.Color(r, g, b));
    }
    strip2.show();
    
    Serial.print("设置主照明灯颜色：R=");
    Serial.print(r);
    Serial.print(", G=");
    Serial.print(g);
    Serial.print(", B=");
    Serial.println(b);
}

// 设置LED灯带颜色并调整亮度
void setStripColorWithBrightness(uint8_t red, uint8_t green, uint8_t blue, uint8_t brightness) {
    uint8_t r = (red * brightness) / 255;
    uint8_t g = (green * brightness) / 255;
    uint8_t b = (blue * brightness) / 255;
    
    // 设置第一个灯带（引脚23）
    for (int i = 0; i < strip.numPixels(); i++) {
        strip.setPixelColor(i, strip.Color(r, g, b));
    }
    strip.show();
    
    // 设置第二个灯带（引脚22）保持同步
    for (int i = 0; i < strip2.numPixels(); i++) {
        strip2.setPixelColor(i, strip2.Color(r, g, b));
    }
    strip2.show();
}

// 初始化所有LED灯带
void setupLEDs() {
    // 初始化主照明灯带1（引脚23）
    strip.begin();
    strip.show();
    strip.setBrightness(50);
    
    // 初始化主照明灯带2（引脚22）
    strip2.begin();
    strip2.show();
    strip2.setBrightness(50);

    // 初始化时间指示灯带
    timeStrip.begin();
    timeStrip.show();
    timeStrip.setBrightness(50);

    // 初始化设备B时间指示灯带
    deviceBTimeStrip.begin();
    deviceBTimeStrip.show();
    deviceBTimeStrip.setBrightness(50);
    
    // 初始化时，确保所有灯都是关闭状态
    setLEDColor(0, 0, 0);
    timeStrip.clear();
    timeStrip.show();
    deviceBTimeStrip.clear();
    deviceBTimeStrip.show();
    
    Serial.println("所有LED灯带已初始化并设置为关闭状态");
}


// 非阻塞呼吸灯效果
void updateBreathingEffect(uint8_t red, uint8_t green, uint8_t blue) {
    unsigned long currentTime = millis();
    if (currentTime - lastBreathTime >= BREATH_INTERVAL) {
        if (increasing) {
            brightness += 5;
            if (brightness >= 255) {
                brightness = 255;
                increasing = false;
            }
        } else {
            brightness -= 5;
            if (brightness <= 0) {
                brightness = 0;
                increasing = true;
            }
        }
        setStripColorWithBrightness(red, green, blue, brightness);
        lastBreathTime = currentTime;
    }
}

// 更新设备A时间指示灯
void updateTimeLEDs() {
    // 如果进度灯被禁用，直接返回
    if (!progressLEDsEnabled) {
        return;
    }
    
    // 如果设备A未阅读（且不是当前在阅读），则关闭进度灯
    if (dailyReadingTime == 0 && !isOpen) {
        timeStrip.clear();
        timeStrip.show();
        return;
    }
    
    unsigned long totalTime = dailyReadingTime;
    if (isOpen && startTime > 0) {
        totalTime += (millis() - startTime);
    }
    unsigned long totalSeconds = totalTime / 1000;

    // 正常亮灯逻辑
    int ledsToLight = 0;
    if (totalSeconds < 450) {
        ledsToLight = 1;
    } else if (totalSeconds < 900) {
        ledsToLight = 2;
    } else if (totalSeconds < 1350) {
        ledsToLight = 3;
    } else if (totalSeconds < 1800) {
        ledsToLight = 4;
    } else if (totalSeconds < 2250) {
        ledsToLight = 5;
    } else if (totalSeconds < 2700) {
        ledsToLight = 6;
    } else if (totalSeconds < 3150) {
        ledsToLight = 7;
    } else {
        ledsToLight = 8;
    }

    for (int i = 0; i < NUM_TIME_LEDS; i++) {
        if (i < ledsToLight) {
            timeStrip.setPixelColor(i, timeStrip.Color(255, 102, 178));  // 粉色
        } else {
            timeStrip.setPixelColor(i, timeStrip.Color(0, 0, 0));    // 关闭
        }
    }
    timeStrip.show();
}

// 更新设备B时间指示灯
void updateDeviceBTimeLEDs() {
    // 如果进度灯被禁用，直接返回
    if (!progressLEDsEnabled) {
        return;
    }
    
    // 如果设备B未阅读，则关闭进度灯
    if (deviceBTotalDailyTime == 0 && !deviceBIsReading) {
        deviceBTimeStrip.clear();
        deviceBTimeStrip.show();
        return;
    }
    
    unsigned long totalSeconds = deviceBTotalDailyTime;

    // 正常亮灯逻辑
    int ledsToLight = 0;
    if (totalSeconds < 450) {
        ledsToLight = 1;
    } else if (totalSeconds < 900) {
        ledsToLight = 2;
    } else if (totalSeconds < 1350) {
        ledsToLight = 3;
    } else if (totalSeconds < 1800) {
        ledsToLight = 4;
    } else if (totalSeconds < 2250) {
        ledsToLight = 5;
    } else if (totalSeconds < 2700) {
        ledsToLight = 6;
    } else if (totalSeconds < 3150) {
        ledsToLight = 7;
    } else {
        ledsToLight = 8;
    }
    
    for (int i = 0; i < NUM_DEVICEB_TIME_LEDS; i++) {
        if (i < ledsToLight) {
            deviceBTimeStrip.setPixelColor(i, deviceBTimeStrip.Color(102, 178, 255));  // 蓝色
        } else {
            deviceBTimeStrip.setPixelColor(i, deviceBTimeStrip.Color(0, 0, 0));    // 关闭
        }
    }
    deviceBTimeStrip.show();
}

// 切换进度条LED灯的状态
void toggleLEDs() {
    progressLEDsEnabled = !progressLEDsEnabled;
    
    if (!progressLEDsEnabled) {
        // 关闭两个进度条LED灯
        timeStrip.clear();
        timeStrip.show();
        
        deviceBTimeStrip.clear();
        deviceBTimeStrip.show();
        
        Serial.println("进度条LED灯带(D25, D26)：关闭");
    } else {
        // 重新启用进度条LED灯（会在下一次更新循环中根据阅读时间自动点亮）
        Serial.println("进度条LED灯带(D25, D26)：启用");
        // 立即更新一次灯带状态
        updateTimeLEDs();
        updateDeviceBTimeLEDs();
    }
}

#endif // LED_CONTROLLER_H