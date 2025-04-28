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

The system is built with a modular design architecture divided into four distinct layers:

1. **Core Configuration** (`config.h`): Centralizes system constants and pin definitions
2. **Network Layer**: Handles WiFi connectivity and MQTT communication
3. **Hardware Control Layer**: Manages physical components (servos, LEDs, sensors)
4. **Feature Layer**: Implements high-level functionality (timers, user interactions)

### Code Structure

```
Arduino/
├── LitMate.ino           # Main sketch file
├── arduino_secrets.h     # WiFi and MQTT credentials (create from template)
├── button_handler.h      # Button input handling
├── config.h              # Pin definitions and constants
├── led_controller.h      # LED control functions
├── mqtt_handler.h        # MQTT communication
├── pomodoro_timer.h      # Pomodoro timing functionality
├── reading_timer.h       # Reading session tracking
├── servo_controller.h    # Book movement control
├── vibration_sensor.h    # Touch detection
└── wifi_manager.h        # WiFi connection management
```

### Key Implementation Features

- **WiFi Setup with AP Mode**: On first boot, creates a configuration hotspot
- **MQTT Communication**: Real-time synchronization between paired devices
- **LED Indication System**: Visual feedback for reading status and progress
- **Pomodoro Timer**: Physical visualization of reading sessions
- **Daily Reading Reset**: Automatic session tracking and daily statistics

## 📝 Future Development

- PCB manufacturing for simpler assembly
- iOS version of the companion app
- Full integration between app and physical device
- Reduced form factor with more compact components
- Alternative visualizations for reading progress

## 📚 References

1. Polivy, J., & Herman, C. P. (2002). If at First You Don't Succeed: False Hopes of Self-Change. American Psychologist, 57(9), 677–689. https://doi.org/10.1037/0003-066X.57.9.677
2. Harris Poll (2019). Reading Habits Survey, conducted for Scribd.
3. Wing, R. R., & Jeffery, R. W. (1999). Benefits of recruiting participants with friends and increasing social support for weight loss and maintenance. Journal of Consulting and Clinical Psychology, 67(1), 132–138. https://doi.org/10.1037/0022-006X.67.1.132

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
