//V51:UI
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:async';
import 'dart:math';

final List<Book> books = [
  Book(
    title: 'Educated',
    author: 'Tara Westover',
    imageUrl: 'assets/images/book1_educated.jpg',
    progress: 0.0,
    readMinutes: 0,
    totalPages: 320,
    currentPage: 0,
  ),
  Book(
    title: 'AI Superpowers',
    author: 'Kai-Fu Lee',
    imageUrl: 'assets/images/book2_AI.jpg',
    progress: 0.0,
    readMinutes: 0,
    totalPages: 300,
    currentPage: 0,
  ),
  Book(
    title: 'Dominicana',
    author: 'Angie Cruz',
    imageUrl: 'assets/images/book3_dominicana.jpg',
    progress: 0.0,
    readMinutes: 0,
    totalPages: 250,
    currentPage: 0,
  ),
  Book(
    title: 'Steppenwolf',
    author: 'Hermann Hesse',
    imageUrl: 'assets/images/book4_steppenwolf.jpg',
    progress: 0.0,
    readMinutes: 0,
    totalPages: 200,
    currentPage: 0,
  ),
  Book(
    title: 'West with the Night',
    author: 'Beryl Markham',
    imageUrl: 'assets/images/book5_west.jpg',
    progress: 0.0,
    readMinutes: 0,
    totalPages: 220,
    currentPage: 0,
  ),
  Book(
    title: 'Muscle',
    author: 'Alan Trotter',
    imageUrl: 'assets/images/book6_muscle.jpg',
    progress: 0.0,
    readMinutes: 0,
    totalPages: 180,
    currentPage: 0,
  ),
];

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
      backgroundColor: const Color(0xFF848488), // 这里设置了基础背景色
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF7A7A7C), // 这里设置了渐变的上半部分颜色
                const Color(0xFF7A7A7C), // 这里设置了渐变的下半部分颜色
              ],
              stops: const [0.5, 1.0],
            ),
          ),
          child: Stack(
            // 使用 Stack 代替 Column
            children: [
              // 上半部分（Logo和标题）
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.65,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/image2.jpg'),
                    fit: BoxFit.cover,
                    // 移除或调整 colorFilter，让图片保持原有的亮度
                    colorFilter: ColorFilter.mode(
                      //const Color(0xFF8E8E93).withOpacity(0.5),
                      Colors.white.withOpacity(0.0), // 将灰色改为白色，透明度改为 0
                      BlendMode.srcATop,
                    ),
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40.0, vertical: 35.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            const Text(
                              'Welcome to\nLitMate',
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
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                bottom: MediaQuery.of(context).viewInsets.bottom > 0
                    ? MediaQuery.of(context).size.height * 0.45 // 将 0.4 改为 0.45
                    : 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      // 根据键盘是否弹出来动态设置圆角
                      borderRadius: MediaQuery.of(context).viewInsets.bottom > 0
                          ? BorderRadius.circular(30) // 键盘弹出时四周都是圆角
                          : const BorderRadius.only(
                              // 在底部时只有顶部圆角
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 添加一个顶部间距，让输入框整体下移
                        const SizedBox(height: 10), // 新增这行，让输入框下移 10
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
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 22), // 将这里从 12 改为 22，增加间距 10
                        // Password TextField
                        Container(
                          height: 50,
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
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 70), // 将这里从 85 改为 75，让按钮上移 10
                        SizedBox(
                          width: 150,
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
                              } else if (!UserData.verifyUser(
                                  email, password)) {
                                // 密码错误
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('password wrong'),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              } else {
                                // 获取用户名并传递给 MainPage
                                final username = UserData.getUsername(email);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MainPage(username: username ?? ''),
                                  ),
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
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5), // 减小按钮垂直内边距到 2
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
                                  MaterialPageRoute(
                                      builder: (context) => const SignUpPage()),
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5), // 减小按钮垂直内边距到 2
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
  ListViewState createState() {
    return ListViewState();
  }
}

class ListViewState extends State<MyListView> {
  late List<String> feeds;

  @override
  void initState() {
    super.initState();
    feeds = [];
    startMQTT();
  }

  void updateList(String s) {
    setState(() {
      feeds.insert(0, s);
    });
  }

  Future<void> startMQTT() async {
    final client = MqttServerClient('mqtt.cetools.org', '<my client id>');
    client.port = 1883;
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
      print(
          'ERROR Mosquitto client connection failed - disconnecting, state is ${client.connectionStatus!.state}');
      client.disconnect();
    }

    const topic = 'student/CASA0014/plant/01';
    client.subscribe(topic, MqttQos.atMostOnce);

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final receivedMessage = c![0].payload as MqttPublishMessage;
      final messageString = MqttPublishPayload.bytesToStringAsString(
          receivedMessage.payload.message);
      print(
          'Change notification:: topic is <${c[0].topic}>, payload is <-- $messageString -->');
      updateList(messageString);
    });
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
  final String username;

  const MainPage({
    super.key,
    required this.username,
  });

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  double _goalMinutes = 60;
  double _alreadyMinutes = 0;
  bool _isReading = false;
  Timer? _timer;
  Book? _selectedBook;
  double _noSpecificBookMinutes = 0;
  int _currentAnimationFrame = 1;
  Timer? _animationTimer;
  // 添加搜索相关的变量
  final TextEditingController _searchController = TextEditingController();
  List<Book> _searchResults = [];
  bool _skipBookSelection = false;

  void _startReading() async {
    final shouldStart = await _showBookSelectionDialog();
    if (shouldStart == true) {
      setState(() {
        _isReading = true;
        _currentAnimationFrame = 1;
      });
      _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
        setState(() {
          _alreadyMinutes += 0.5;
          if (_selectedBook != null) {
            _selectedBook!.readMinutes += 0.5;
            _selectedBook!.progress = _selectedBook!.readMinutes / _goalMinutes;
          } else {
            _noSpecificBookMinutes += 0.5;
          }
        });
      });

      final animationInterval = (_goalMinutes * 60) ~/ 8;
      _animationTimer =
          Timer.periodic(Duration(seconds: animationInterval), (timer) {
        setState(() {
          if (_currentAnimationFrame < 9) {
            _currentAnimationFrame++;
          }
        });
      });
    }
  }

  void _stopReading() async {
    _timer?.cancel();
    _animationTimer?.cancel();

    final result = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        TextEditingController pageController = TextEditingController();
        bool noSpecificPage = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white.withOpacity(0.95),
              contentPadding: const EdgeInsets.all(16),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Finished Page',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'No.',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 60,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: TextField(
                          controller: pageController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CheckboxListTile(
                    value: noSpecificPage,
                    onChanged: (value) {
                      setState(() {
                        noSpecificPage = value ?? false;
                        if (noSpecificPage) {
                          pageController.clear();
                        }
                      });
                    },
                    title: const Text(
                      'no specific page',
                      style: TextStyle(fontSize: 16),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!noSpecificPage) {
                          int? pages = int.tryParse(pageController.text);
                          if (pages != null && _selectedBook != null) {
                            _selectedBook!.currentPage = pages;
                            Navigator.of(context).pop(true);
                          }
                        } else {
                          Navigator.of(context).pop(true);
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
                        'Submit',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (result == true) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ConfettiWidget(
            onComplete: () {
              Navigator.of(context).pop();
              setState(() {
                _isReading = false;
                _selectedBook = null;
              });
            },
          );
        },
      );
    }
  }

  Future<void> _showGoalPicker() async {
    final List<double> goalOptions = [0.5, 10, 15, 30, 60, 90, 120, 150, 180];

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: double.minPositive,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: goalOptions.length,
              itemBuilder: (BuildContext context, int index) {
                final value = goalOptions[index];
                final displayValue =
                    value == 0.5 ? '0.5' : value.toInt().toString();
                return ListTile(
                  title: Text('$displayValue minutes'),
                  onTap: () {
                    setState(() {
                      _goalMinutes = goalOptions[index];
                    });
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<bool> _showBookSelectionDialog() async {
    _searchResults = List.from(books);
    bool? result = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white.withOpacity(0.95),
              contentPadding: const EdgeInsets.all(16),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select a book to read',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (value) {
                                setState(() {
                                  if (value.isEmpty) {
                                    _searchResults = List.from(books);
                                  } else {
                                    _searchResults = books
                                        .where((book) =>
                                            book.title.toLowerCase().contains(
                                                value.toLowerCase()) ||
                                            book.author
                                                .toLowerCase()
                                                .contains(value.toLowerCase()))
                                        .toList();
                                  }
                                });
                              },
                              decoration: const InputDecoration(
                                hintText: 'Search',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 20),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.search,
                                color: Colors.grey, size: 20),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 180,
                      child: _searchResults.isEmpty
                          ? const Center(child: Text('No result'))
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _searchResults.length,
                              itemBuilder: (context, index) {
                                final book = _searchResults[index];
                                final isSelected = book == _selectedBook;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedBook = book;
                                      _skipBookSelection = false;
                                    });
                                  },
                                  child: Container(
                                    width: 120,
                                    margin: const EdgeInsets.only(right: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: isSelected
                                            ? const Color(0xFFF4ED2C)
                                            : Colors.transparent,
                                        width: 2,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              const BorderRadius.vertical(
                                            top: Radius.circular(8),
                                          ),
                                          child: book.imageUrl.isEmpty
                                              ? Container(
                                                  height: 120,
                                                  width: double.infinity,
                                                  color: Colors.grey[200],
                                                  child: Center(
                                                    child: Text(
                                                      book.title,
                                                      style: const TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                )
                                              : Image.asset(
                                                  book.imageUrl,
                                                  height: 120,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                book.title,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                book.author,
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    const SizedBox(height: 16),
                    CheckboxListTile(
                      value: _skipBookSelection,
                      onChanged: (value) {
                        setState(() {
                          _skipBookSelection = value ?? false;
                          if (_skipBookSelection) {
                            _selectedBook = null;
                          }
                        });
                      },
                      title: const Text(
                        'no specific book this time',
                        style: TextStyle(fontSize: 16),
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_skipBookSelection || _selectedBook != null) {
                            Navigator.of(context).pop(true);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF4ED2C),
                          foregroundColor: Colors.black,
                        ),
                        child: const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
    return result ?? false;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationTimer?.cancel();
    _searchController.dispose(); // 添加控制器的销毁
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      HomePage(
        username: widget.username,
        isReading: _isReading,
        goalMinutes: _goalMinutes,
        alreadyMinutes: _alreadyMinutes,
        selectedBook: _selectedBook,
        currentAnimationFrame: _currentAnimationFrame,
        onStartReading: _startReading,
        onStopReading: _stopReading,
        onShowGoalPicker: _showGoalPicker,
      ),
      const LibraryPage(),
      const GroupPage(),
      const SettingPage(),
    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade300,
              width: 2.0,
            ),
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          iconSize: 30.0, // 将图标大小从默认的 24.0 改为 30.0
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
          onTap: (value) {
            setState(() {
              _selectedIndex = value;
            });
          },
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final String username;
  final bool isReading;
  final double goalMinutes;
  final double alreadyMinutes;
  final Book? selectedBook;
  final int currentAnimationFrame;
  final VoidCallback onStartReading;
  final VoidCallback onStopReading;
  final VoidCallback onShowGoalPicker;

  const HomePage({
    super.key,
    required this.username,
    required this.isReading,
    required this.goalMinutes,
    required this.alreadyMinutes,
    required this.selectedBook,
    required this.currentAnimationFrame,
    required this.onStartReading,
    required this.onStopReading,
    required this.onShowGoalPicker,
  });

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC2C2C6),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 60, 25, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Today's Reading",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 35), // 动画图片上方间距
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width - 50,
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500), // 动画持续时间
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    child: Image.asset(
                      'assets/images/Animation/R${widget.currentAnimationFrame}.png',
                      key: ValueKey<int>(
                          widget.currentAnimationFrame), // 添加key以触发动画
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 45), // 将这个值从35改为45，使卡片整体下移10个单位
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Already',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '${widget.alreadyMinutes.toInt()} min',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      height: 2,
                      width: 60,
                      color: Colors.black,
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    if (widget.isReading) {
                      widget.onStopReading();
                    } else {
                      widget.onStartReading();
                    }
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Text(
                          widget.isReading ? 'Stop' : 'Start',
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
                            color:
                                widget.isReading ? Colors.red : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: widget.onShowGoalPicker,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Goal',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        '${widget.goalMinutes == 0.5 ? '0.5' : widget.goalMinutes.toInt()} min',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
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
            const SizedBox(height: 40), //这个值是首页两张卡片距离上一个组件的距离高度
            SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.34, // 将这个值改小:首页两张卡片的高度减小
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecentReadingPage(
                              username: widget.username,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4ED2C),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Recent',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Reading',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Image.asset(
                                  'assets/images/Icon/Recent.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Device',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Setting',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Image.asset(
                                'assets/images/Icon/Device.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10), // 这里增加一个底部间距
          ],
        ),
      ),
    );
  }
}

class Book {
  final String title;
  final String author;
  final String imageUrl;
  double progress;
  double readMinutes;
  final int totalPages;
  int currentPage;

  Book({
    required this.title,
    required this.author,
    required this.imageUrl,
    this.progress = 0.0,
    this.readMinutes = 0,
    required this.totalPages,
    this.currentPage = 0,
  });

  // 添加一个新的构造函数用于创建新书籍
  Book.create({
    required this.title,
    required this.author,
    required this.totalPages,
  })  : imageUrl = '', // 空字符串表示使用默认灰色背景
        progress = 0.0,
        readMinutes = 0,
        currentPage = 0;
}

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Book> filteredBooks = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    filteredBooks = List.from(books);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC2C2C6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 9, 25, 16), // 上边距60，左右边距25
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 左对齐
            children: [
              const Text(
                'Your Book\nCollection',
                style: TextStyle(
                  fontSize: 28, // 字体大小28
                  fontWeight: FontWeight.bold, // 粗体
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 15),

              // 修改搜索框
              Container(
                height: 35, // 减小搜索框高度
                margin: const EdgeInsets.only(bottom: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            if (value.isEmpty) {
                              isSearching = false;
                              filteredBooks = List.from(books);
                            } else {
                              isSearching = true;
                              filteredBooks = books
                                  .where((book) =>
                                      book.title
                                          .toLowerCase()
                                          .contains(value.toLowerCase()) ||
                                      book.author
                                          .toLowerCase()
                                          .contains(value.toLowerCase()))
                                  .toList();
                            }
                          });
                        },
                        onSubmitted: (value) {
                          // 处理键盘回车键搜索
                          FocusScope.of(context).unfocus();
                        },
                        decoration: const InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search,
                          color: Colors.grey, size: 20),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    Container(
                      height: 20,
                      width: 1,
                      color: Colors.grey[300],
                    ),
                    IconButton(
                      icon: const Icon(Icons.filter_list,
                          color: Colors.grey, size: 20),
                      onPressed: () {
                        // 过滤功能
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 修改书籍网格部分
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.only(bottom: 40), // 将原来的 80 改为 40
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.55,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: (isSearching ? filteredBooks : books).length + 1,
                  itemBuilder: (context, index) {
                    return Transform.translate(
                      offset: Offset(0, index % 2 == 1 ? 30 : -20),
                      child: index == 0
                          ? _buildAddBookCard()
                          : _buildBookCard(isSearching
                              ? filteredBooks[index - 1]
                              : books[index - 1]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddBookCard() {
    return GestureDetector(
      onTap: () => _showAddBookDialog(),
      child: Container(
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.add,
              size: 40,
              color: Colors.grey,
            ),
            SizedBox(height: 8),
            Text(
              'Add\na new book',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookCard(Book book) {
    double progressPercentage = book.totalPages > 0
        ? (book.currentPage / book.totalPages * 100).roundToDouble()
        : 0.0;

    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // 增加图片部分的高度，占据卡片大部分空间
          Expanded(
            flex: 4, // 图片部分占据更多空间
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
              child: book.imageUrl.isEmpty
                  ? Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: Text(
                          book.title,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                  : Image.asset(
                      book.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          // 书籍信息部分固定在底部
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  book.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  book.author,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // 进度条
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: progressPercentage / 100,
                          backgroundColor: Colors.grey[200],
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color.fromARGB(255, 3, 10,
                                16), // 将这里从紫色改为蓝色 (或者使用 const Color(0xFF2196F3))
                          ),
                          minHeight: 4,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${(progressPercentage).toInt()}%', // 进度百分比
                      style: TextStyle(
                        color:
                            const Color.fromARGB(255, 3, 10, 16), // 这里也要改为相同的蓝色
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddBookDialog() async {
    final titleController = TextEditingController();
    final authorController = TextEditingController();
    final pagesController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white.withOpacity(0.95),
          contentPadding: const EdgeInsets.all(16),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add a new book',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text('book name: '),
                  Expanded(
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('author: '),
                  Expanded(
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: authorController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('total page: '),
                  Expanded(
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: pagesController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    final pages = int.tryParse(pagesController.text) ?? 0;
                    if (titleController.text.isNotEmpty &&
                        authorController.text.isNotEmpty &&
                        pages > 0) {
                      final newBook = Book.create(
                        title: titleController.text,
                        author: authorController.text,
                        totalPages: pages,
                      );
                      books.insert(0, newBook);
                      Navigator.of(context).pop(true);
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
                    'Submit',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (result == true) {
      setState(() {
        filteredBooks = List.from(books);
      });
    }
  }
}

class GroupPage extends StatelessWidget {
  const GroupPage({super.key});

  // 保持原有的群组数据不变
  final List<Map<String, dynamic>> groups = const [
    {
      'name': "CE Universe",
      'memberCount': 8,
    },
    {
      'name': 'Family',
      'memberCount': 3,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 60, 25, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题栏和添加按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Group',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () => _showCreateGroupDialog(context),
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: const BoxDecoration(
                      color: Color(
                          0xFFF4ED2C), // 将 Colors.red 改为 Color(0xFFF4ED2C)
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.black, // 由于背景色变浅，建议将图标颜色改为黑色以提高对比度
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // 保持原有的群组列表不变
            SizedBox(
              height: 350,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: groups.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      right: 16,
                      left: index == 0 ? 0 : 0,
                    ),
                    child: GestureDetector(
                      onTap: groups[index]['name'] == 'CE Universe'
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GroupMembersPage(
                                    groupName: groups[index]['name'],
                                  ),
                                ),
                              );
                            }
                          : null,
                      child: Container(
                        width: 260,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Text(
                                groups[index]
                                    ['name'], // 'CE Universe' 或 'Family'
                                style: const TextStyle(
                                  fontSize: 20, // 将原来的 18 改为 20
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            // 头像列表
                            if (groups[index]['name'] == 'CE Universe')
                              _buildCEUniverseAvatars()
                            else
                              _buildFamilyAvatars(),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCEUniverseAvatars() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Wrap(
        spacing: 5,
        runSpacing: 5,
        children: [
          _buildAvatar('assets/images/Andy.png'), // 1
          _buildAvatar('assets/images/Valerio.png'), // 2
          _buildAvatar('assets/images/Leah.png'), // 3
          _buildAvatar('assets/images/Duncan.png'), // 4
          _buildAvatar('assets/images/Qijie.png'), // 5
          _buildAvatar('assets/images/Ke.png'), // 6
          _buildAvatar('assets/images/Wenhao.png'), // 7
          _buildAvatar('assets/images/Qijing.png'), // 8
        ],
      ),
    );
  }

  Widget _buildFamilyAvatars() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Wrap(
        spacing: 5,
        runSpacing: 5,
        children: [
          _buildAvatar('assets/images/mom.png'),
          _buildAvatar('assets/images/dad.png'),
          _buildAvatar('assets/images/Qijing.png'),
        ],
      ),
    );
  }

  Widget _buildAvatar(String imagePath) {
    return CircleAvatar(
      radius: 20, // 将头像半径从 15 改为 20
      backgroundImage: AssetImage(imagePath),
    );
  }

  void _showCreateGroupDialog(BuildContext context) {
    final groupNameController = TextEditingController();

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white.withOpacity(0.95),
          contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create new group',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    'Group name: ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: groupNameController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    'Group members: ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 18,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'invite friends',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF4ED2C),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  // 修改初始状态为 false
  bool readingStatusEnabled = false;
  bool readingTimeEnabled = false;
  bool bookListEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 60, 25, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 用户信息部分
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/images/Qijing.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                const Text(
                  'Qijing',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 30),

            // My Booklight 部分
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Text(
                    'My Booklight',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.menu, color: Colors.black),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 在线状态 - 向右移动5个单位
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Row(
                children: [
                  const Icon(Icons.book_outlined, color: Colors.black),
                  const SizedBox(width: 10),
                  const Text(
                    'online',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // 隐私设置部分
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Privacy Setting',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Allowing other users to see your:',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildSwitchRow('reading status', readingStatusEnabled,
                      (value) {
                    setState(() => readingStatusEnabled = value);
                  }),
                  _buildSwitchRow('reading time statistic', readingTimeEnabled,
                      (value) {
                    setState(() => readingTimeEnabled = value);
                  }),
                  _buildSwitchRow('book list', bookListEnabled, (value) {
                    setState(() => bookListEnabled = value);
                  }),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // 客服中心
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Text(
                    'Customer service center',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(), // 添加这一行，将登出按钮推到底部

            // 登出按钮
            Center(
              // 使用 Center 包裹来居中显示按钮
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: SizedBox(
                  width: 150, // 设置固定宽度为150
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Log out',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchRow(String title, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
          Transform.scale(
            scale: 0.7,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor:
                  const Color.fromARGB(255, 240, 221, 55), // 选中时，使用更浅的黄色
              inactiveThumbColor: Colors.grey[400], // 未选中时滑块的颜色
              inactiveTrackColor: Colors.grey[300], // 未选中时轨道的颜色
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
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
                  'LitMate',
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
                UserData.addUser(
                  _emailController.text,
                  _passwordController.text,
                  _usernameController.text,
                );
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
  static final Map<String, Map<String, String>> _users = {}; // 存储用户邮箱、密码和用户名

  static void addUser(String email, String password, String username) {
    _users[email] = {
      'password': password,
      'username': username,
    };
  }

  static bool verifyUser(String email, String password) {
    if (!_users.containsKey(email)) {
      return false;
    }
    return _users[email]?['password'] == password;
  }

  static bool isEmailRegistered(String email) {
    return _users.containsKey(email);
  }

  static String? getUsername(String email) {
    return _users[email]?['username'];
  }
}

class ConfettiWidget extends StatefulWidget {
  final VoidCallback onComplete;

  const ConfettiWidget({
    Key? key,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<ConfettiWidget> createState() => _ConfettiWidgetState();
}

class _ConfettiWidgetState extends State<ConfettiWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Confetti> confetti = [];
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // 创建50个彩色碎片
    for (int i = 0; i < 50; i++) {
      confetti.add(Confetti(random));
    }

    _controller.forward().then((_) => widget.onComplete());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ConfettiPainter(
            confetti: confetti,
            progress: _controller.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class Confetti {
  late double x;
  late double y;
  late Color color;
  late double width;
  late double height;
  late double speed;
  late double angle;

  Confetti(Random random) {
    x = random.nextDouble() * 300 + 50;
    y = random.nextDouble() * 200 + 100;
    // 使用更鲜艳的颜色
    color = [
      const Color(0xFFF4ED2C), // 黄色
      const Color(0xFF00BCD4), // 青色
      const Color(0xFFE91E63), // 粉红
      const Color(0xFF9C27B0), // 紫色
      const Color(0xFF4CAF50), // 绿色
    ][random.nextInt(5)];
    width = random.nextDouble() * 15 + 5; // 彩带宽度
    height = random.nextDouble() * 4 + 2; // 彩带高度
    speed = random.nextDouble() * 8 + 4;
    angle = random.nextDouble() * pi * 2;
  }
}

class ConfettiPainter extends CustomPainter {
  final List<Confetti> confetti;
  final double progress;

  ConfettiPainter({required this.confetti, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in confetti) {
      final paint = Paint()
        ..color = particle.color.withOpacity(1 - progress)
        ..style = PaintingStyle.fill;

      double dx = particle.speed * progress * cos(particle.angle);
      double dy = particle.speed * progress * sin(particle.angle) +
          progress * progress * 30;

      canvas.save();
      canvas.translate(particle.x + dx, particle.y + dy);
      canvas.rotate(particle.angle);

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset.zero,
            width: particle.width * (1 - progress * 0.5),
            height: particle.height,
          ),
          const Radius.circular(1),
        ),
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ConfettiPainter oldDelegate) => true;
}

class RecentReadingPage extends StatefulWidget {
  final String username;

  const RecentReadingPage({
    super.key,
    required this.username,
  });

  @override
  State<RecentReadingPage> createState() => _RecentReadingPageState();
}

class _RecentReadingPageState extends State<RecentReadingPage> {
  String selectedPeriod = 'week';
  DateTime selectedDate = DateTime.now();
  late DateTime weekStart;
  late DateTime weekEnd;
  List<double> chartData = [];

  @override
  void initState() {
    super.initState();
    _updateWeekDates(selectedDate);
    _updateChartData();
  }

  void _updateWeekDates(DateTime date) {
    // 获取所选日期所在周的周一和周日
    weekStart = date.subtract(Duration(days: date.weekday - 1));
    weekEnd = weekStart.add(const Duration(days: 6));
  }

  void _updateChartData() {
    setState(() {
      if (selectedPeriod == 'week') {
        // 保持周视图代码不变
        final now = DateTime.now();
        chartData = List.generate(7, (index) {
          final currentDate = weekStart.add(Duration(days: index));
          if (currentDate.isAfter(now)) {
            return 0.0;
          }
          return Random().nextInt(50) + 10.0;
        });
      } else if (selectedPeriod == 'month') {
        // 保持月视图代码不变
        final now = DateTime.now();
        final selectedMonthDate =
            DateTime(selectedDate.year, selectedDate.month, 1);
        final currentMonthDate = DateTime(now.year, now.month, 1);

        chartData = List.generate(7, (index) {
          final day =
              int.parse(['1', '5', '10', '15', '20', '25', '30'][index]);
          final currentDate =
              DateTime(selectedDate.year, selectedDate.month, day);

          if (selectedMonthDate.isAfter(currentMonthDate)) {
            return 0.0;
          }

          if (selectedMonthDate.year == now.year &&
              selectedMonthDate.month == now.month &&
              currentDate.isAfter(now)) {
            return 0.0;
          }

          return Random().nextInt(50) + 10.0;
        });
      } else {
        // 年视图：根据月份生成数据
        final now = DateTime.now();
        chartData = List.generate(12, (index) {
          final currentDate = DateTime(selectedDate.year, index + 1, 1);

          // 如果是未来年份或当前年份的未来月份，返回0
          if (selectedDate.year > now.year ||
              (selectedDate.year == now.year && index + 1 > now.month)) {
            return 0.0;
          }

          return Random().nextInt(50).toDouble();
        });
      }
    });
  }

  String _getDateDisplay() {
    final List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    if (selectedPeriod == 'week') {
      return '${months[weekStart.month - 1]} ${weekStart.day} - ${months[weekEnd.month - 1]} ${weekEnd.day}, ${weekEnd.year}';
    } else if (selectedPeriod == 'month') {
      return '${months[selectedDate.month - 1]}, ${selectedDate.year}';
    } else if (selectedPeriod == 'year') {
      // 年视图只显示年份
      return '${selectedDate.year}';
    }
    return '';
  }

  Future<void> _showCalendarDialog() async {
    print('开始显示日历弹窗');
    if (selectedPeriod == 'week') {
      print('周视图日历选择');
      DateTime tempSelectedDate = selectedDate;

      await showDialog(
        context: context,
        builder: (BuildContext context) {
          print('构建弹窗');
          return StatefulBuilder(
            builder: (context, setDialogState) {
              print('构建 StatefulBuilder');
              return Dialog(
                child: Container(
                  width: 300,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 400,
                        child: CalendarDatePicker(
                          initialDate: selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                          onDateChanged: (date) {
                            print('选择日期: $date');
                            setDialogState(() {
                              tempSelectedDate = date;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {
                            print('点击 Submit 按钮');
                            Navigator.of(context).pop();
                            setState(() {
                              selectedDate = tempSelectedDate;
                              _updateWeekDates(tempSelectedDate);
                              _updateChartData();
                            });
                            print('更新完成');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF4ED2C),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
      print('弹窗关闭');
    } else if (selectedPeriod == 'month') {
      // 月视图的日期选择
      final List<String> months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ];

      int tempSelectedMonth = selectedDate.month;
      int tempSelectedYear = selectedDate.year;

      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setDialogState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: Colors.white,
                contentPadding: const EdgeInsets.all(20),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${months[tempSelectedMonth - 1]} $tempSelectedYear',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // 月份和年份选择行
                    Row(
                      children: [
                        // 月份选择列
                        Expanded(
                          child: Container(
                            height: 240,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListWheelScrollView(
                              itemExtent: 48,
                              diameterRatio: 1.5,
                              offAxisFraction: 0,
                              useMagnifier: true,
                              magnification: 1.2,
                              physics: const FixedExtentScrollPhysics(),
                              controller: FixedExtentScrollController(
                                initialItem: tempSelectedMonth - 1,
                              ),
                              onSelectedItemChanged: (index) {
                                setDialogState(() {
                                  tempSelectedMonth = index + 1;
                                });
                              },
                              children: List.generate(12, (index) {
                                bool isSelected =
                                    index + 1 == tempSelectedMonth;
                                return Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: Center(
                                    child: Text(
                                      months[index],
                                      style: TextStyle(
                                        color: isSelected
                                            ? const Color(0xFF8E8EF3)
                                            : Colors.black,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // 年份选择列
                        Expanded(
                          child: Container(
                            height: 240,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListWheelScrollView(
                              itemExtent: 48,
                              diameterRatio: 1.5,
                              offAxisFraction: 0,
                              useMagnifier: true,
                              magnification: 1.2,
                              physics: const FixedExtentScrollPhysics(),
                              controller: FixedExtentScrollController(
                                initialItem: tempSelectedYear - 2020,
                              ),
                              onSelectedItemChanged: (index) {
                                setDialogState(() {
                                  tempSelectedYear = 2020 + index;
                                });
                              },
                              children: List.generate(15, (index) {
                                int year = 2020 + index;
                                bool isSelected = year == tempSelectedYear;
                                return Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: Center(
                                    child: Text(
                                      year.toString(),
                                      style: TextStyle(
                                        color: isSelected
                                            ? const Color(0xFF8E8EF3)
                                            : Colors.black,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Submit按钮
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedDate =
                                DateTime(tempSelectedYear, tempSelectedMonth);
                            _updateChartData();
                          });
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF4ED2C),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    } else if (selectedPeriod == 'year') {
      // 年视图的年份选择
      int tempSelectedYear = selectedDate.year;

      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setDialogState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: Colors.white,
                contentPadding: const EdgeInsets.all(20),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$tempSelectedYear',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // 年份选择列表
                    Container(
                      height: 240,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListWheelScrollView(
                        itemExtent: 48,
                        diameterRatio: 1.5,
                        offAxisFraction: 0,
                        useMagnifier: true,
                        magnification: 1.2,
                        physics: const FixedExtentScrollPhysics(),
                        controller: FixedExtentScrollController(
                          initialItem: tempSelectedYear - 2020,
                        ),
                        onSelectedItemChanged: (index) {
                          setDialogState(() {
                            tempSelectedYear = 2020 + index;
                          });
                        },
                        children: List.generate(15, (index) {
                          int year = 2020 + index;
                          bool isSelected = year == tempSelectedYear;
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Center(
                              child: Text(
                                year.toString(),
                                style: TextStyle(
                                  color: isSelected
                                      ? const Color(0xFF8E8EF3)
                                      : Colors.black,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Submit按钮
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedDate = DateTime(tempSelectedYear);
                            _updateChartData();
                          });
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF4ED2C),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    }
  }

  // 计算总阅读时间
  double _calculateTotalReadingTime() {
    if (selectedPeriod == 'week') {
      // 保持周视图的计算逻辑不变
      double total = 0;
      for (int i = 0; i < chartData.length; i++) {
        total += chartData[i];
      }
      return total;
    } else if (selectedPeriod == 'month') {
      // 保持月视图的计算逻辑不变
      double total = 0;
      for (int i = 0; i < chartData.length; i++) {
        total += chartData[i];
      }
      return total;
    } else if (selectedPeriod == 'year') {
      // 年视图：计算所有月份数据的总和
      double total = 0;
      for (int i = 0; i < chartData.length; i++) {
        total += chartData[i];
      }
      return total;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons
                .arrow_back_ios, // 将默认的 Icons.arrow_back 改为 Icons.arrow_back_ios
            size: 20, // 设置图标大小为 20
          ),
        ),
        title: const Text(
          'Recent Reading',
          style: TextStyle(
            fontSize: 28,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 时间段选择按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPeriodButton('week'),
                const SizedBox(width: 16),
                _buildPeriodButton('month'),
                const SizedBox(width: 16),
                _buildPeriodButton('year'),
              ],
            ),
            const SizedBox(height: 24),
            // 日历图标和日期
            GestureDetector(
              onTap: () => _showCalendarDialog(),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    _getDateDisplay(),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // 折线图
            Container(
              height: 300,
              padding: const EdgeInsets.all(16),
              child: CustomPaint(
                size: Size.infinite,
                painter: ChartPainter(
                  data: chartData,
                  weekStart: weekStart,
                  period: selectedPeriod,
                ),
              ),
            ),

            // 添加阅读时间总结文本
            if (selectedPeriod == 'week' ||
                selectedPeriod == 'month' ||
                selectedPeriod == 'year') ...[
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi, ${widget.username}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: "You've read ",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                            ),
                          ),
                          TextSpan(
                            text: '${_calculateTotalReadingTime().toInt()}',
                            style: const TextStyle(
                              fontSize: 28,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: selectedPeriod == 'week'
                                ? ' minutes this week!'
                                : selectedPeriod == 'month'
                                    ? ' minutes this month!'
                                    : ' hours this year!',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodButton(String period) {
    bool isSelected = selectedPeriod == period;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPeriod = period;
          // 切换到年视图时重置selectedDate为当前年份
          if (period == 'year') {
            selectedDate = DateTime.now();
            _updateChartData();
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF4ED2C) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFF4ED2C) : Colors.grey,
          ),
        ),
        child: Text(
          period.toUpperCase(),
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

// 自定义折线图画笔
class ChartPainter extends CustomPainter {
  final List<double> data;
  final DateTime weekStart;
  final String period;

  ChartPainter({
    required this.data,
    required this.weekStart,
    required this.period,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFF4ED2C)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final pointPaint = Paint()
      ..color = const Color(0xFFF4ED2C)
      ..style = PaintingStyle.fill;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    // 根据不同视图类型绘制坐标轴
    if (period == 'week') {
      // 周视图：只显示到今天的数据
      final now = DateTime.now();
      final path = Path();
      bool isFirstValidPoint = true;

      for (int i = 0; i < 7; i++) {
        final currentDate = weekStart.add(Duration(days: i));
        final double x = 40 + i * 45.0;
        final double y = size.height - 40 - (data[i] / 10) * 2.0;

        if (!currentDate.isAfter(now)) {
          if (isFirstValidPoint) {
            path.moveTo(x, y);
            isFirstValidPoint = false;
          } else {
            path.lineTo(x, y);
          }
          canvas.drawCircle(Offset(x, y), 4, pointPaint);
        }

        textPainter.text = TextSpan(
          text: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][i],
          style: TextStyle(
            color: currentDate.isAfter(now)
                ? Colors.grey.withOpacity(0.5)
                : Colors.grey,
            fontSize: 12,
          ),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x - textPainter.width / 2, size.height - 35),
        );
      }
      canvas.drawPath(path, paint);
    } else if (period == 'month') {
      final now = DateTime.now();
      final labels = ['1', '5', '10', '15', '20', '25', '30'];

      final double xStep = (size.width - 60) / (labels.length - 1);
      final double maxYValue = 120.0;
      final double yStep = (size.height - 60) / maxYValue;

      final path = Path();
      bool isFirstValidPoint = true;

      for (int i = 0; i < labels.length; i++) {
        final double x = 40 + i * xStep;
        final double y = size.height - 40 - (data[i] * yStep);

        if (data[i] > 0) {
          // 只绘制有数据的点
          if (isFirstValidPoint) {
            path.moveTo(x, y);
            isFirstValidPoint = false;
          } else {
            path.lineTo(x, y);
          }
          canvas.drawCircle(Offset(x, y), 4, pointPaint);
        }

        textPainter.text = TextSpan(
          text: labels[i],
          style: TextStyle(
            color: data[i] > 0 ? Colors.grey : Colors.grey.withOpacity(0.5),
            fontSize: 12,
          ),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x - textPainter.width / 2, size.height - 35),
        );
      }

      if (!isFirstValidPoint) {
        canvas.drawPath(path, paint);
      }
    } else {
      // 年视图：只显示到当前月份的数据点
      final labels = List.generate(12, (index) => '${index + 1}');

      final double xStep = (size.width - 60) / (labels.length - 1);
      final double maxYValue = 50;
      final double yStep = (size.height - 60) / maxYValue;

      final path = Path();
      bool isFirstValidPoint = true;

      for (int i = 0; i < 12; i++) {
        double x = 40 + i * xStep;
        double y = size.height - 40 - (data[i] * yStep);

        if (data[i] > 0) {
          if (isFirstValidPoint) {
            path.moveTo(x, y);
            isFirstValidPoint = false;
          } else {
            path.lineTo(x, y);
          }
          canvas.drawCircle(Offset(x, y), 4, pointPaint);
        }

        textPainter.text = TextSpan(
          text: labels[i],
          style: TextStyle(
            color: data[i] > 0 ? Colors.grey : Colors.grey.withOpacity(0.5),
            fontSize: 12,
          ),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x - textPainter.width / 2, size.height - 35),
        );
      }

      if (!isFirstValidPoint) {
        canvas.drawPath(path, paint);
      }
    }

    // 绘制坐标轴和刻度
    _drawAxes(canvas, size);
  }

  void _drawAxes(Canvas canvas, Size size) {
    final axisPath = Path();

    // 绘制y轴（延长并添加箭头）
    axisPath
      ..moveTo(40, size.height - 40)
      ..lineTo(40, 10)
      ..lineTo(35, 15)
      ..moveTo(40, 10)
      ..lineTo(45, 15);

    // 绘制x轴（延长并添加箭头）
    axisPath
      ..moveTo(40, size.height - 40)
      ..lineTo(size.width - 10, size.height - 40)
      ..lineTo(size.width - 15, size.height - 45)
      ..moveTo(size.width - 10, size.height - 40)
      ..lineTo(size.width - 15, size.height - 35);

    canvas.drawPath(
      axisPath,
      Paint()
        ..color = Colors.grey
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke,
    );

    // 绘制y轴刻度
    final yAxisValues = period == 'year'
        ? [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50]
        : [0, 15, 30, 45, 60, 75, 90, 105, 120];

    final yAxisStep = (size.height - 60) / (yAxisValues.length - 1);

    for (int i = 0; i < yAxisValues.length; i++) {
      canvas.drawLine(
        Offset(35, size.height - 40 - i * yAxisStep),
        Offset(45, size.height - 40 - i * yAxisStep),
        Paint()..color = Colors.grey,
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text: '${yAxisValues[i]}',
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(10, size.height - 40 - i * yAxisStep - textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// 添加 Group_Members 页面
class GroupMembersPage extends StatefulWidget {
  final String groupName;

  const GroupMembersPage({
    super.key,
    required this.groupName,
  });

  @override
  State<GroupMembersPage> createState() => _GroupMembersPageState();
}

class _GroupMembersPageState extends State<GroupMembersPage> {
  String selectedTab = 'Members';

  // 修改群组数据，添加 readingTime 字段
  final List<Map<String, dynamic>> orderedUsers = [
    {
      'name': 'Qijing',
      'photo': 'assets/images/Qijing.png',
      'readingTime': 29,
    },
    {
      'name': 'Valerio',
      'photo': 'assets/images/Valerio.png',
      'readingTime': 28,
    },
    {
      'name': 'Wenhao',
      'photo': 'assets/images/Wenhao.png',
      'readingTime': 27,
    },
    {
      'name': 'Leah',
      'photo': 'assets/images/Leah.png',
      'readingTime': 26,
    },
    {
      'name': 'Andy',
      'photo': 'assets/images/Andy.png',
      'readingTime': 25,
    },
    {
      'name': 'Qijie',
      'photo': 'assets/images/Qijie.png',
      'readingTime': 23,
    },
    {
      'name': 'Duncan',
      'photo': 'assets/images/Duncan.png',
      'readingTime': 22,
    },
    {
      'name': 'Ke',
      'photo': 'assets/images/Ke.png',
      'readingTime': 8,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        // 将底部 padding 从 16 改为 36，增加白色框高度
        padding: const EdgeInsets.fromLTRB(25, 45, 25, 36), // 修改这里
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题栏
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back_ios,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.groupName,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // 导航栏
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTabButton('Members'),
                  const SizedBox(width: 20),
                  _buildTabButton('Rank'),
                  const SizedBox(width: 20),
                  _buildTabButton('Books'),
                ],
              ),
              const SizedBox(height: 30),
              // Members 和 Rank 的条件渲染
              if (selectedTab == 'Members') ...[
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '2',
                                  style: TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(
                                        0xFFF44336), // 将原来的 0xFFF4ED2C 改为 0xFFF44336
                                  ),
                                ),
                                TextSpan(
                                  text: '    /    8',
                                  style: TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'reading',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(width: 100),
                        Text(
                          'total',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4), // 将原来的 40 改为 20，减少间距
                    // 按行构建用户列表
                    Column(
                      children: [
                        Transform.translate(
                          offset: const Offset(0, -30), // 整体向上移动10个单位
                          child: Column(
                            children: [
                              for (int i = 0;
                                  i < orderedUsers.length;
                                  i += 2) ...[
                                Transform.translate(
                                  offset: i == 0
                                      ? Offset.zero
                                      : (i == 2
                                          ? const Offset(0, -120) // 第二行偏移保持不变
                                          : (i == 4
                                              ? const Offset(
                                                  0, -240) // 第三行偏移保持不变
                                              : const Offset(
                                                  0, -360) // 第四行偏移保持不变
                                          )),
                                  child: Column(
                                    children: [
                                      // Logo 行
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            i == 0
                                                ? 'assets/images/GroupLogo3.png' // 第一行使用 GroupLogo3
                                                : 'assets/images/GroupLogo2.png', // 其他行使用 GroupLogo2
                                            width: 160,
                                            height: 225, // 统一所有图片高度为225
                                            fit: BoxFit.contain,
                                          ),
                                          const SizedBox(width: 20),
                                          Image.asset(
                                            i == 0
                                                ? 'assets/images/GroupLogo3.png' // 第一行使用 GroupLogo3
                                                : 'assets/images/GroupLogo2.png', // 其他行使用 GroupLogo2
                                            width: 160,
                                            height: 225, // 统一所有图片高度为225
                                            fit: BoxFit.contain,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 0),
                                      // 用户信息行
                                      Transform.translate(
                                        offset: const Offset(0, -50),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            // 左侧用户
                                            Row(
                                              children: [
                                                Container(
                                                  width: 35,
                                                  height: 35,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                          orderedUsers[i]
                                                              ['photo']),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  orderedUsers[i]['name'],
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(width: 110),
                                            // 右侧用户
                                            if (i + 1 < orderedUsers.length)
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 35,
                                                    height: 35,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                            orderedUsers[i + 1]
                                                                ['photo']),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    orderedUsers[i + 1]['name'],
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                          height: 5), // 将 height 从 10 改为 5
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ] else if (selectedTab == 'Rank') ...[
                Transform.translate(
                  offset: const Offset(0, -35),
                  child: Column(
                    children: [
                      const SizedBox(height: 5),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: orderedUsers.length,
                        itemBuilder: (context, index) {
                          final user = orderedUsers[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                // 为第一名添加黄色发光效果
                                if (index == 0) ...[
                                  BoxShadow(
                                    color: const Color(0xFFF4ED2C)
                                        .withOpacity(0.3),
                                    spreadRadius: 4,
                                    blurRadius: 15,
                                    offset: const Offset(0, 0),
                                  ),
                                  BoxShadow(
                                    color: const Color(0xFFF4ED2C)
                                        .withOpacity(0.2),
                                    spreadRadius: 6,
                                    blurRadius: 20,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                                // 为最后一名添加红色发光效果
                                if (index == orderedUsers.length - 1) ...[
                                  BoxShadow(
                                    color: const Color(0xFFF44336)
                                        .withOpacity(0.3),
                                    spreadRadius: 4,
                                    blurRadius: 15,
                                    offset: const Offset(0, 0),
                                  ),
                                  BoxShadow(
                                    color: const Color(0xFFF44336)
                                        .withOpacity(0.2),
                                    spreadRadius: 6,
                                    blurRadius: 20,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                                // 保持原有的阴影效果
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // 排名数字
                                Container(
                                  width: 30,
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                // 用户头像
                                Container(
                                  width: 45,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: AssetImage(user['photo']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                // 用户名和阅读时长
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user['name'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${user['readingTime']} hours',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ] else if (selectedTab == 'Books') ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // "The most popular book of this month" 标题
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'The most popular book of this month',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // 热门书籍卡片
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            children: [
                              // 书籍封面
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  'assets/images/book2_AI.jpg', // 更改图片路径
                                  width: 100,
                                  height: 150, // 将原来的 150 改为 145
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 15),
                              // 书籍信息
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'AI at the Edge', // 更改书名
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    const Text(
                                      'Kai-Fu Lee', // 更改作者名
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    // 阅读人数信息
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.people_outline,
                                          size: 20,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          '4: ',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        // 读者头像
                                        for (var i = 0; i < 4; i++)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 5),
                                            child: Container(
                                              width: 25,
                                              height: 25,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                    i == 0
                                                        ? 'assets/images/Andy.png'
                                                        : i == 1
                                                            ? 'assets/images/Valerio.png'
                                                            : i == 2
                                                                ? 'assets/images/Leah.png'
                                                                : 'assets/images/Duncan.png',
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // "Other books" 标题
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Other books',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // 这里可以添加其他书籍的列表
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            children: [
                              // 书籍封面
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  'assets/images/book1_educated.jpg', // 更改图片路径
                                  width: 100,
                                  height: 150, // 将原来的 150 改为 145
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 15),
                              // 书籍信息
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Educated', // 更改书名
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    const Text(
                                      'Tara Westover', // 更改作者名
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    // 阅读人数信息
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.people_outline,
                                          size: 20,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          '3: ',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        // 读者头像
                                        for (var i = 0; i < 3; i++)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 5),
                                            child: Container(
                                              width: 25,
                                              height: 25,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                    i == 0
                                                        ? 'assets/images/Wenhao.png'
                                                        : i == 1
                                                            ? 'assets/images/Andy.png'
                                                            : 'assets/images/Qijing.png', // 直接使用第三张照片，移除了多余的条件判断
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    //
                    //
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            children: [
                              // 书籍封面
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  'assets/images/book6_muscle.jpg', // 更改图片路径
                                  width: 100,
                                  height: 150, // 将原来的 150 改为 145
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 15),
                              // 书籍信息
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Muscle', // 更改书名
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    const Text(
                                      'Alan Trotter', // 更改作者名
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    // 阅读人数信息
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.people_outline,
                                          size: 20,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          '3: ',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        // 读者头像
                                        for (var i = 0; i < 3; i++)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 5),
                                            child: Container(
                                              width: 25,
                                              height: 25,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                    i == 0
                                                        ? 'assets/images/Qijie.png'
                                                        : i == 1
                                                            ? 'assets/images/Duncan.png'
                                                            : 'assets/images/Valerio.png', // 直接使用第三张照片，移除了多余的条件判断
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    //
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            children: [
                              // 书籍封面
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  'assets/images/book5_west.jpg', // 更改图片路径
                                  width: 100,
                                  height: 150, // 将原来的 150 改为 145
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 15),
                              // 书籍信息
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'West with the Night', // 更改书名
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    const Text(
                                      'Beryl Markham', // 更改作者名
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    // 阅读人数信息
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.people_outline,
                                          size: 20,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          '2: ',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        // 读者头像
                                        for (var i = 0; i < 2; i++)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 5),
                                            child: Container(
                                              width: 25,
                                              height: 25,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                    i == 0
                                                        ? 'assets/images/Leah.png'
                                                        : 'assets/images/Qijing.png', // 直接使用第三张照片，移除了多余的条件判断
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    //
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(String text) {
    final isSelected = selectedTab == text;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = text;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFD9D9D9) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontSize: 21, // 增大字体大小
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // 修改用户卡片构建方法
  Widget _buildUserCard(Map<String, dynamic> user, bool isReading) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 70) / 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/GroupLogo3.png',
            width: 160,
            height: 200, // 将高度增加到原来的5倍（45 * 5 = 225）
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(user['photo']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                user['name'],
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
