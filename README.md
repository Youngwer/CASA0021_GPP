<img src="./Images/Title3.png" alt="LitMate Title" width="100%" style="width:100%;">

<a href="https://www.youtube.com/watch?v=BeWCd5zH7cs">
  <img src="https://img.youtube.com/vi/BeWCd5zH7cs/0.jpg" alt="LitMate Demo Video" width="100%" style="width:100%;">
</a>

🎥 Click the video above to watch [Your New Reading Partner](https://www.youtube.com/watch?v=BeWCd5zH7cs)

# LitMate: Smart Book Light for Shared Reading Experiences

## 📖 What the Project Does

LitMate is a smart book light that combines IoT technology with behavioral development concepts to help users build consistent reading habits. Using the MQTT protocol, LitMate enables remote users to share their reading status in real-time, fostering mutual companionship and accountability.

<img align="left" width="300" src="./Images/book1.png" alt="Product demo of LitMate" style="margin-right: 30px"/>

**Key Features:**
- Physical book light with open/close mechanism showing reading status
- Visual Pomodoro timer through page angle movement
- LED indicators showing reading progress for yourself and your reading partner
- Touch sensor for interaction and color changes
- Companion mobile app for tracking reading statistics and connecting with other readers
- WiFi connectivity with easy setup through Access Point mode
- MQTT protocol for real-time status synchronization between paired devices

<br clear="left"/>

## 🌟 Why the Project is Useful

LitMate addresses the challenge many readers face: difficulty in maintaining consistent reading habits. According to a 2019 Harris Poll, 81% of U.S. adults report not reading as much as they wish due to limited time. Research on the "false hope syndrome" explains this pattern of repeated failure and renewed intention (Polivy & Herman, 2002).

LitMate transforms reading from a solitary activity into a shared experience by:
1. **Creating accountability** through paired devices that show when your partner is reading
2. **Visualizing progress** with physical and light indicators
3. **Building routine** through Pomodoro timing techniques
4. **Fostering community** via the companion app's social features
5. **Reducing distractions** by making reading time visible and meaningful

![How to connect distant readers](./Images/connect.png)
<p style="text-align: center;"><em>How LitMate connects distant readers</em></p>

## 🚀 How Users Can Get Started with the Project

### Materials Required

| Component | Quantity | Estimated Cost (GBP) | Notes |
|-----------|----------|---------------------|-------|
| ESP32 Development Board | 1 | £7.2 | Main controller |
| SW420 Vibration Sensor | 1 | £0.8 | For touch detection |
| Servo Motor | 2 | £4.4 | Controls book opening/closing |
| WS2812B LED Strip | 4 segments (8 LEDs each) | £11.0 | For status display |
| Push Button | 1 | £0.4 | Stainless steel button |
| 4xAA Battery Holder | 1 | £0.8 | 6V power supply |
| Acrylic Sheets | - | £8.3 | Textured acrylic recommended |
| Other Components | - | £2.8 | Wires, resistors, etc. |

### Step 1: Hardware Assembly

1. **3D Modeling & Fabrication:**
   - Use the provided [Rhino files](./3D_Models/) for the enclosure design
   - Laser cut the components from acrylic sheets using the [DWG files](./Laser_Cutting/)
   - Follow the [assembly guide](./Documentation/assembly_guide.md) for detailed instructions

2. **Paper Folding:**
   - Use the [origami template](./Documentation/origami_template.pdf) to create the book page structure
   - Attach pages to the servo motors following the diagram in the assembly guide

3. **Circuit Connection:**
   - Wire the components according to the [circuit diagram](./PCB%20Design/Circuit%20diagram.png)
   - For a more permanent solution, the [PCB design](./PCB%20Design/PCB.png) can be manufactured

### Step 2: Software Setup

1. **Prerequisites:**
   - Install [Arduino IDE](https://www.arduino.cc/en/software)
   - Install ESP32 board package via Boards Manager
   - Install required libraries:
     - WiFiManager
     - PubSubClient (MQTT)
     - FastLED
     - ESP32Servo

2. **Loading the Code:**
   - Clone this repository: `git clone https://github.com/yourusername/litmate.git`
   - Open the [Arduino project](./Arduino/) in Arduino IDE
   - Update the `arduino_secrets.h` file with your WiFi and MQTT broker details
   - Upload the code to your ESP32

3. **First Boot & WiFi Setup:**
   - Power on the device
   - Connect to the "ESP32-Config" WiFi network from your phone/computer
   - Navigate to http://192.168.4.1 in a browser
   - Enter your home WiFi credentials
   - The device will restart and connect to your network

### Step 3: Mobile App Setup

1. **Installing the App:**
   - Download the APK from the [Releases](https://github.com/yourusername/litmate/releases) page
   - Install on your Android device (currently Android-only)

2. **Setting Up Your Profile:**
   - Create an account
   - Set reading goals
   - Add books to your library
   - Connect with friends or join reading groups

### Step 4: Pairing Devices

1. Configure both LitMate devices to use the same MQTT broker
2. Assign each device a unique ID in the code (DeviceA and DeviceB)
3. Both devices will automatically synchronize when connected to the network

## 🤝 Where Users Can Get Help

- **Documentation:** Complete documentation is available in the [Documentation](./Documentation/) folder
- **Issues:** Submit problems or feature requests through [GitHub Issues](https://github.com/yourusername/litmate/issues)
- **Discussions:** Join our [Discord community](https://discord.gg/litmate) to connect with other makers
- **Contact:** Reach the development team at litmate@example.com

## 👥 Who Maintains and Contributes to the Project

LitMate was developed by the CEuniverse Team as part of the CASA0016 Making & Prototyping course at UCL:

<div style="text-align: center;">
    <img src="./Images/CEuniverse.png" alt="CEuniverse Team" style="width: 80%;">
</div>

Team members:
- [Member 1] - Hardware Design & Fabrication
- [Member 2] - Software Development
- [Member 3] - Mobile App Development
- [Member 4] - Product Design
- [Member 5] - Documentation & Testing

## 🔧 Technical Details

### System Architecture

<div style="text-align: center;">
    <img src="./Images/arch.png" alt="System Architecture">
</div>

When significant state changes occur (book opening/closing, touch interaction, light color change), the device immediately publishes updates to the appropriate topics. The MQTT client maintains persistent connections with automatic reconnection mechanisms to ensure connected devices receive the latest state information.

Therefore, this lightweight communication framework enables the paired LitMate devices to maintain synchronized state and respond to each other's actions in real-time within seconds.

### 4.3 Core Reading Functionality
The core of LitMate's functionality revolves around its ability to physically interact with books, track reading sessions, and provide visual feedback through an integrated system of hardware control and state management.

#### 4.3.1 Pomodoro Timer 
The LitMate device incorporates a sophisticated Pomodoro timer that combines time tracking with physical visualization through servo motor positioning.

The Pomodoro functions are tightly integrated with the book state management system: When book is open, it start working, set an hour Pomodoro timer; When the full one-hour session completes, it triggers the book closure mechanism.

##### Servo Angle as Visual Progress Indicator
Another feature of LitMate's Pomodoro is the use of servo angle position as a physical progress indicator. As reading time advances, the servo motors adjust their position in 15-degree increments:

```cpp
if (currentStage != lastServoStage) {
        // Calculate new servo position: starting from 180 degrees, decreasing by 15 degrees per stage
        int targetPosition = 180 - (currentStage * DEGREES_PER_STAGE);
        
        // Smoothly move to the new position
        moveServosSmooth(180 - (lastServoStage * DEGREES_PER_STAGE), 
                          targetPosition, 
                          (lastServoStage < currentStage) ? 5 : -5, 
                          50);
        
        lastServoStage = currentStage;
    }

```

#### 4.3.2 Button Interaction Logic (Short Press vs. Long Press)
The system uses a single button interface with differentiated press durations to control multiple functions. The button handler utilise debouncing and timing mechanisms to distinguish between short and long presses:
- **Short Press**: Toggles the progress indicator LEDs on/off.
- **Long Press (for more than 3 seconds)**: Toggles the book's open/closed state.

```cpp
// Function to check button status
void checkButton() {
    // Read button state (LOW means pressed)
    int buttonState = digitalRead(BUTTON_PIN);
    
    // Button pressed
    if (buttonState == LOW && !buttonPressed) {
        buttonPressed = true;
        buttonPressTime = millis();
        longPressTriggered = false;
    } 
    
    // Button held down, check if long press duration is reached
    else if (buttonState == LOW && buttonPressed) {
        unsigned long pressDuration = millis() - buttonPressTime;
        
        // Long press duration reached and long press action not yet triggered
        if (pressDuration >= LONG_PRESS_TIME && !longPressTriggered) {
            toggleBook();         // Toggle the book's open/close status
            longPressTriggered = true;
            Serial.println("Long press detected, toggling book status");
        }
    }
    // Button released
    else if (buttonState == HIGH && buttonPressed) {
        unsigned long pressDuration = millis() - buttonPressTime;
        buttonPressed = false;
        
        // Short press - control LED lights
        if (pressDuration < LONG_PRESS_TIME && !longPressTriggered) {
            toggleLEDs();
            Serial.println("Short press detected, toggling LED status");
        }
        longPressTriggered = false;
    }
}
```

#### 4.3.3 Session-based and Cumulative Time Tracking
The system can distinguish between active reading sessions and cumulative daily reading time. When the book is opened, a new reading session begins. The system uses the millis() function to track time and records the start time and begins tracking the session duration. When the book is closed, the session duration is calculated and added to the cumulative daily reading time. This approach allows the system to maintain accurate time records even through multiple reading sessions throughout the day. The related code is shown below:
```cpp
// Start reading timer
void startReadingTimer() {
    startTime = millis();
    lastUpdateTime = startTime;
    Serial.println("Reading session started!");
    
    // Publish reading status to MQTT
    publishReadingStatus(true, dailyReadingTime);
}
// Stop reading timer
void stopReadingTimer() {
    if (startTime > 0) {
        unsigned long sessionTime = millis() - startTime;
        dailyReadingTime += sessionTime;
        Serial.print("Reading session ended. Session time: ");
        printTime(sessionTime);
        Serial.print("Total daily reading time: ");
        printTime(dailyReadingTime);
        
        // Publish reading status to MQTT
        publishReadingStatus(false, dailyReadingTime);
        
        startTime = 0;
    }
}
```

#### 4.3.4 Daily Reading Reset Mechanism
When a new day begins, the system logs the previous day's total reading time, resets the counter, and publishes the updated state to the MQTT network to ensure paired devices are synchronized.



### 4.4 User Interaction and Data Visualisation

#### 4.4.1 LED Indication System

##### Book Lamp
The main book lamp serves as both a reading light and a status indicator, using color and animation effects to visualise the device's state.

When both books are open, the Book Lamp will display a smooth "breathing" effect that provides ambient lighting, which enhances the reading experience across both users, creating a reading atmosphere.

```cpp
void updateBreathingEffect() {
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
	lastBreathTime = currentTime;
}
```
The book lamp color can be changed between pink (default) and yellow through the vibration sensor double-tap detection, which is design for interactive purposes to increase fun through readers:
```cpp
if (tapInterval > minTapInterval && tapInterval < doubleTapWindow) {
    // Toggle light color and publish
    isYellowColor = !isYellowColor;
    publishLightColor(isYellowColor);
    
    // Apply the new color to LEDs
    if (isYellowColor) {
        setLEDColor(255, 255, 0);  // Yellow
    } else {
        setLEDColor(255, 102, 178);  // Pink
    }
}

```
This color change is synchronized between paired devices, creating a shared visual experience between remote users.




#### 4.4.2 Progress Indicator LEDs

The system implements separate LED strips for each user, which can be identified by color, to visualise reading time for both the user's device and the paired device. The number of LED display logic is shown in code below:
```cpp
// Map reading time to LED display (8 LEDs represent progress thresholds)
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
```

Also, these reading progress LEDs can be switched on and off via a short button press to conserve power, which is shown below:
```cpp
    if (!progressLEDsEnabled) {
        // Turn off both progress bar LEDs
        timeStrip.clear();
        timeStrip.show();
        
        deviceBTimeStrip.clear();
        deviceBTimeStrip.show();
    } else {
        // Re-enable progress bar LEDs
        updateTimeLEDs();
        updateDeviceBTimeLEDs();
    }
```

# 5. Application

### 5.1 Overview
The mobile application aims to provide users with a simple reading record and reading sharing experience. It ensures that users can record the current reading time and number of pages, and view past reading statistics through the app to achieve better development of reading habits.

### 5.2 Main Functions
#### 5.2.1 Recording reading time and pages

<div style="text-align: center;">
    <img src="./Images/5.2.1.png" alt="Recording reading time and pages interface" style="width: 100%;">
    <p><em>Fig 24. Interface for recording reading time and pages</em></p>
</div>

- Click on the 'Goal' button and select the goal for today's reading time in the pop-up window.
- Click on the 'Start' button to select the book you are going to read in the pop-up window (the data of the book in the pop-up window comes from the Library).
- After starting to read, the 'Already' text will show the length of time already read, users can click the 'Stop' button to stop reading records, you can enter the progress of this reading in the pop-up window that appears after clicking.


#### 5.2.2 Viewing Reading Statistics



<div style="text-align: center;">
    <img src="./Images/5.2.2.png" alt="Reading statistics overview" style="width: 100%;">
    <p><em>Fig 25. Reading statistics overview showing weekly, monthly, and yearly views with time selection</em></p>
</div>

- Click on 'Recent Reading' on the homepage to go to the statistics page. 
- Click on 'WEEK', 'MONTH', 'YEAR' to see reading statistics in different time units.
- Click on the calendar icon to select a time in the pop-up window

#### 5.2.3 Managing Personal Library

<div style="text-align: center;">
    <img src="./Images/5.2.3.png" alt="Personal library interface" style="width: 80%;">
    <p><em>Fig 26. Personal library interface showing book collection with progress bars</em></p>
</div>

- The book cards on the Library page show each book's cover, title, author, and current reading progress bar.
- Click on the 'Add a new book' card to add a book to the e-library and enter information about the new book in the pop-up window.
- In the search box, you can enter the name of the book or author to search for existing book data.

#### 5.2.4 Managing Personal Library
Click the plus sign on the Group page to create a new group, and enter the group information in the pop-up window.
<div style="text-align: center;">
    <img src="./Images/group.png" alt="Group Photo" style="width: 80%;">
    <p><em>Fig 27. Group Photo</em></p>
</div>


Click on each Group card to see more information about the group, including the number of members currently reading, the ranking of reading hours for the month, and the books read by group members.
<div style="text-align: center;">
    <img src="./Images/CEuniverse.png" alt="CEuniverse" style="width: 80%;">
    <p><em>Fig 28. CEuniverse Team</em></p>
</div>





### 5.3 Interation
#### 5.3.1 Sketch

<div style="text-align: center;">
    <img src="./Images/app_sketch.png" alt="App interface sketch" style="width: 100%;">
    <p><em>Fig 29. Initial sketches of the app interface design</em></p>
</div>

#### 5.3.2 Prototype

<div style="text-align: center;">
    <img src="./Images/app_prototype.png" alt="App interface prototype" style="width: 100%;">
    <p><em>Fig 30. High-fidelity prototype of the app interface</em></p>
</div>

#### 5.3.3 Current Development

<div style="text-align: center;">
    <img src="./Images/app_development.png" alt="Current app development" style="width: 100%;">
    <p><em>Fig 31. Current development status of the app interface</em></p>
</div>



# **6. Limitations & Future development**
### 6.1 More Possibilities in Design

<div style="text-align: center;">
    <img src="./Images/futuresketch.jpg" alt="Future Design Possibilities" style="width: 80%;">
    <p><em>Fig 32. Future Design Possibilities</em></p>
</div>
Some of the advice about the product gained during the pitch made the team rethink about product design.

- **Size**: The team tends to reduce the size of the product in the next iteration by upgrading the hardware to make it more write and easy to use. In fact, the current product still has a lot of free space inside.
- **Visualisation**: For visualisation, the team preferred to make another prototype where the pages of the book could be opened from each side to represent the reading progress of both sides for a more intuitive comparison.

### 6.2 How to Improve Hardware of LitMate?
#### 6.2.1 Circuit Assembly and Challenges
The circuit was designed to be straightforward, focusing on ease of connection. However, the symmetrical layout made wiring more complex, leading to issues in organization and debugging. The key challenges faced during assembly were:
- **Complex Wiring Layout**: The symmetrical arrangement of components made routing difficult, increasing the risk of loose connections.
- **Power Supply Limitations**: The initial single power source was insufficient for stable operation, especially when driving multiple LEDs and servos.
- **Vibration Sensor Sensitivity**: The SW420 sensor was difficult to fine-tune, sometimes failing to detect subtle touches or triggering false readings.

To address these issues, some measures were taken :
1) Simplified the routing layout, reducing unnecessary wiring complexity.
2) Implemented a separate power supply, ensuring adequate power distribution.
3) Adjusted the sensitivity threshold of the SW420 sensor to improve its reliability.

#### 6.2.2 PCB Design
For the purpose of simplifying the hardware assembly of the product as well as reducing the size of the product. Designing a dedicated PCB is an ideal ending solution and the team has made the following attempts so far:

<div style="text-align: center;">
    <img src="./PCB Design/PCB.png" alt="PCB Design" style="width: 80%;">
    <p><em>Fig 33. PCB Design</em></p>
</div>

### 6.3 Application

The current APP is limited to Android mobile phones and has not yet been linked to a physical book light, which could be developed in both directions in future developments and iterations: 
1) Develop different versions of the app for Android and IOS phones; 
2) Implement a digital twin between mobile application and physical book light, allowing users to control the book light on/off and synchronise the reading time recorded by the book light in the application.

### 6.4 Marketisation：Inability to finally recognise costs
Below are the current individual equipment costing：

| Component | Quantity | Subtotal (GBP) | Estimated Cost (GBP) | Notes |
|-----------|----------|---------------|---------------------|-------|
| ESP32 Development Board | 1 | £5.5-£8.8 | £7.2 | Main controller |
| SW420 Vibration Sensor | 1 | £0.55-£1.1 | £0.8 | For touch detection |
| Servo Motor | 2 | £3.3-£5.5 | £4.4 | Controls book opening/closing |
| WS2812B LED Strip | 4 segments (8 LEDs each) | £8.8-£13.2 | £11.0 | For status display |
| Push Button | 1 | £0.22-£0.55 | £0.4 | Stainless steel button |
| 4xAA Battery Holder | 1 | £0.55-£1.1 | £0.8 | 6V power supply |
| Acrylic Enclosure | - | £5.5-£11 | £8.3 | Including laser cutting cost |
| Other Components (Wires, Resistors, etc.) | - | £2.2-£3.3 | £2.8 | Basic electronic components |
| **Total** | - | **£26.6-£44.5** | **£35.7** | - |


The ultimate goal of the product is to sell it on kickstater, so the cost and selling price need to be considered, but there are two uncertainties at the moment: the **paper-folding work** needs to seek cooperation from manufacturers for mass production, and the **subsequent development and maintenance costs of the APP**.

# **7. Reference**
1) Polivy, J., & Herman, C. P. (2002). If at First You Don't Succeed: False Hopes of Self-Change. American Psychologist, 57(9), 677–689. https://doi.org/10.1037/0003-066X.57.9.677
2) Harris Poll (2019). Reading Habits Survey, conducted for Scribd. Summary available via Mental Floss by Garin Pirnia: 81% of people don't read as much as they want
3) Wing, R. R., & Jeffery, R. W. (1999). Benefits of recruiting participants with friends and increasing social support for weight loss and maintenance. Journal of Consulting and Clinical Psychology, 67(1), 132–138. https://doi.org/10.1037/0022-006X.67.1.132
