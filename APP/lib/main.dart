import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(), // 设置初始页面为登录页面
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8E8E93),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF8E8E93), // 上方灰色
              Colors.grey[300]!, // 下方浅灰色
            ],
            stops: const [0.5, 1.0], // 调整渐变位置
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 上半部分（Logo和标题）
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.65,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/image2.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    const Color(0xFF8E8E93).withOpacity(0.5),
                    BlendMode.srcATop,
                  ),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          const Text(
                            'Welcome to\nInter_Glow',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                              color: Colors.black,
                            ),
                          ),
                          Positioned(
                            right: 0,
                            top: 45,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.orange,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // 登录表单
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 8,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 8), // 增加顶部内边距从 12 到 15
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Email TextField
                      Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12), // 增加间距从 8 到 12
                      // Password TextField
                      Container(
                        height: 45, // 增加输入框高度从 40 到 45
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: 'Password',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12), // 增加内边距
                          ),
                        ),
                      ),
                      const SizedBox(height: 12), // 增加间距从 8 到 12
                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {
                            final email = _emailController.text;
                            final password = _passwordController.text;

                            if (!UserData.isEmailRegistered(email)) {
                              // 用户未注册
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('The user is not registered'),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            } else if (!UserData.verifyUser(email, password)) {
                              // 密码错误
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('password wrong'),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            } else {
                              // 验证成功，跳转到主页
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const MainPage()),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF4ED2C),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Log in',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 9),
                      // Forget password and Sign up
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 5), // 减小按钮垂直内边距到 2
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Forget password',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SignUpPage()),
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 5), // 减小按钮垂直内边距到 2
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

class MyListView extends StatefulWidget {
  @override
  ListViewState createState() {return ListViewState();}
}

class ListViewState extends State<MyListView>{
  late List<String> feeds;

  @override
  void initState() {
    super.initState();
    feeds = [];
    startMQTT();
  }
  void updateList(String s) {
    setState(() {
      feeds.insert(0,s);
    });
  }
  Future<void> startMQTT() async{
   final client = MqttServerClient('mqtt.cetools.org', '<my client id>');
   client.port=1883;
   client.setProtocolV311();
   client.keepAlivePeriod = 30;
   //final String username = 'username';
   //final String password = 'password';
   try {
    await client.connect();
   } catch (e) {
    print('client exception - $e');
    client.disconnect();
    return;
   }

   if (client.connectionStatus!.state == MqttConnectionState.connected) {
    print('Mosquitto client connected');
   } else {
    print('ERROR Mosquitto client connection failed - disconnecting, state is ${client.connectionStatus!.state}');
    client.disconnect();
   }

   const topic = 'student/CASA0014/plant/01';
   client.subscribe(topic, MqttQos.atMostOnce);

   client.updates!.listen( (List<MqttReceivedMessage<MqttMessage?>>? c) {
    final receivedMessage = c![0].payload as MqttPublishMessage;
    final messageString = MqttPublishPayload.bytesToStringAsString(receivedMessage.payload.message);
    print('Change notification:: topic is <${c[0].topic}>, payload is <-- $messageString -->');
    updateList(messageString);
   } );
 }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: feeds.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(feeds[index]),
        );
      },
    );
  }

}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  MainPageState createState() => MainPageState();
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _goalMinutes = 60;  // 默认目标时间
  int _alreadyMinutes = 0;  // 已读时间
  bool _isReading = false;  // 是否正在阅读
  Timer? _timer;  // 计时器

  void _startReading() {
    setState(() {
      _isReading = true;
    });
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {
        _alreadyMinutes++;
      });
    });
  }

  void _stopReading() {
    setState(() {
      _isReading = false;
    });
    _timer?.cancel();
  }

  Future<void> _showGoalPicker() async {
    final selectedGoal = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        int tempGoal = _goalMinutes;
        return AlertDialog(
          title: const Text('Set Reading Goal'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return DropdownButton<int>(
                value: tempGoal,
                items: [30, 45, 60, 90, 120].map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text('$value minutes'),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    tempGoal = newValue!;
                  });
                },
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () => Navigator.of(context).pop(tempGoal),
            ),
          ],
        );
      },
    );

    if (selectedGoal != null) {
      setState(() {
        _goalMinutes = selectedGoal;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Today's Reading"),
        backgroundColor: const Color(0xFFC2C2C6), // 将标题栏背景改为相同的灰色
        elevation: 0, // 移除阴影效果，使其与背景完全融合
      ),
      backgroundColor: const Color(0xFFC2C2C6),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 上半部分可以先空着，后续添加半圆图形
            const SizedBox(height: 40),
            // Already, Start button, Goal 部分
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Already read time
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Already',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black, // 将 Already 文本改为黑色
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '$_alreadyMinutes',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'min',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 2,
                      width: 60,
                      color: Colors.black,
                    ),
                  ],
                ),
                // Start/Stop button
                GestureDetector(
                  onTap: () {
                    if (_isReading) {
                      _stopReading();
                    } else {
                      _startReading();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Text(
                          _isReading ? 'Stop' : 'Start',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isReading ? Colors.red : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Goal time (clickable)
                GestureDetector(
                  onTap: _showGoalPicker,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Goal',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black, // 将 Goal 文本改为黑色
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '$_goalMinutes',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'min',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 2,
                        width: 60,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
      ),
      body: const Center(
        child: Text('Library Page Content'),
      ),
    );
  }
}

class GroupPage extends StatelessWidget {
  const GroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group'),
      ),
      body: const Center(
        child: Text('Group Page Content'),
      ),
    );
  }
}

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: const Center(
        child: Text('Settings Page Content'),
      ),
    );
  }
}

class MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  
  final List<Widget> _pages = const [
    HomePage(),
    LibraryPage(),
    GroupPage(),
    SettingPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade300,
              width: 1.0,
            ),
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: '',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            Column(
              children: [
                const Text(
                  'Welcome to',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                    color: Colors.black,
                  ),
                ),
                const Text(
                  'Inter_Glow',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Colors.black,
                ),
                textSelectionTheme: const TextSelectionThemeData(
                  cursorColor: Colors.black,
                  selectionColor: Colors.black12,
                  selectionHandleColor: Colors.black,
                ),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'user name',
                      border: UnderlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'email',
                      border: UnderlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'password',
                      border: UnderlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                UserData.addUser(_emailController.text, _passwordController.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('registered successfully'),
                    duration: Duration(seconds: 2),
                  ),
                );
                await Future.delayed(const Duration(seconds: 2));
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF4ED2C),
                minimumSize: const Size(200, 40),
              ),
              child: const Text(
                'Sign up',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

// 在文件顶部添加用户数据存储类
class UserData {
  static final Map<String, String> _users = {}; // 存储用户邮箱和密码

  static void addUser(String email, String password) {
    _users[email] = password;
  }

  static bool verifyUser(String email, String password) {
    if (!_users.containsKey(email)) {
      return false; // 用户不存在
    }
    return _users[email] == password; // 验证密码
  }

  static bool isEmailRegistered(String email) {
    return _users.containsKey(email);
  }
}