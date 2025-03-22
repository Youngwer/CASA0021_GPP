//V33：Group_Members页面完善了，终于
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
                  padding: const EdgeInsets.fromLTRB(
                      20, 15, 20, 8), // 增加顶部内边距从 12 到 15
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
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
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
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12), // 增加内边距
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
                      const SizedBox(height: 9),
                      // Forget password and Sign up
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

  @override
  Widget build(BuildContext context) {
    // 在 build 方法中创建 _pages 列表，这样可以使用 widget.username
    final List<Widget> _pages = [
      HomePage(username: widget.username), // 传递用户名
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

  const HomePage({
    super.key,
    required this.username,
  });

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _goalMinutes = 60;
  int _alreadyMinutes = 0;
  bool _isReading = false;
  Timer? _timer;
  Book? _selectedBook;
  int _noSpecificBookMinutes = 0;
  final TextEditingController _searchController = TextEditingController();
  List<Book> _searchResults = [];
  bool _skipBookSelection = false;

  void _startReading() async {
    final shouldStart = await _showBookSelectionDialog();
    if (shouldStart == true) {
      setState(() {
        _isReading = true;
      });
      _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
        setState(() {
          _alreadyMinutes++;
          if (_selectedBook != null) {
            _selectedBook!.readMinutes++;
            _selectedBook!.progress = _selectedBook!.readMinutes / _goalMinutes;
          } else {
            _noSpecificBookMinutes++;
          }
        });
      });
    }
  }

  void _stopReading() async {
    _timer?.cancel();

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
                      style: TextStyle(fontSize: 14),
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
      // 显示彩带特效
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
                    // 搜索框
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
                    // 书本列表
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
                    // 暂不选择具体书本的选项
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
                        style: TextStyle(fontSize: 14),
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 16),
                    // Submit 按钮
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Today's Reading"),
        backgroundColor: const Color(0xFFC2C2C6),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFC2C2C6),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // 增加上方空间，将计时器下移
            const Expanded(flex: 4, child: SizedBox()),

            // 计时器部分
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Already read time
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Already',
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      '${_alreadyMinutes}min',
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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

                // Goal time
                GestureDetector(
                  onTap: _showGoalPicker,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Goal',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        '${_goalMinutes}min',
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

            const SizedBox(height: 14), // 使用固定高度代替 Expanded

            // Recent Reading 和 Device Setting 部分
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.35, // 稍微减小卡片高度
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Recent Reading Card
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
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                    ),
                  ),

                  // Device Setting Card
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
                            padding: const EdgeInsets.all(15.0),
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10), // 使用固定高度保持与上方相同
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
  int readMinutes;
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your book\nCollections',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 16),

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
    // 计算阅读进度百分比
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 第一行：书籍封面图片
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
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
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
          ),
          // 第二行到第四行：书籍信息
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0), // 移除底部padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 第二行：书名
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
                // 第三行：作者
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
                // 第四行：进度条和百分比
                Padding(
                  padding: const EdgeInsets.only(bottom: 6), // 只给进度条部分添加底部间距
                  child: Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(
                            value: book.currentPage / book.totalPages,
                            backgroundColor: Colors.grey[200],
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFFF4ED2C),
                            ),
                            minHeight: 3,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${progressPercentage.toInt()}%',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
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

  // 群组数据
  final List<Map<String, dynamic>> groups = const [
    {
      'name': "CE Universe",
      'memberCount': 8,
    },
    {
      'name': 'Family',
      'memberCount': 3,
    },
    {
      'name': 'read partner',
      'memberCount': 2,
    },
    {
      'name': 'who is reading?',
      'memberCount': 4,
    },
  ];

  // CE Universe 群组的用户数据
  final List<Map<String, dynamic>> ceUniverseUsers = const [
    {
      'name': 'Andy',
      'photo': 'assets/images/Andy.png',
    },
    {
      'name': 'Valerio',
      'photo': 'assets/images/Valerio.png',
    },
    {
      'name': 'Leah',
      'photo': 'assets/images/Leah.png',
    },
    {
      'name': 'Duncan',
      'photo': 'assets/images/Duncan.png',
    },
    {
      'name': 'Qijie',
      'photo': 'assets/images/Qijie.png',
    },
    {
      'name': 'Ke',
      'photo': 'assets/images/Ke.png',
    },
    {
      'name': 'Wenhao',
      'photo': 'assets/images/Wenhao.png',
    },
    {
      'name': 'Qijing',
      'photo': 'assets/images/Qijing.png',
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
            const Text(
              'Group',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GroupMembersPage(
                              groupName: groups[index]['name'],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 260,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                groups[index]['name'],
                                style: const TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              // 修改用户头像显示
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: index == 0
                                    ? ceUniverseUsers
                                        .map((user) => Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  image:
                                                      AssetImage(user['photo']),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ))
                                        .toList()
                                    : List.generate(
                                        groups[index]['memberCount'],
                                        (i) => Container(
                                          width: 30,
                                          height: 30,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                              ),
                              const SizedBox(height: 33), // 增加间距使 logo 向下移动
                              Center(
                                child: Image.asset(
                                  'assets/images/GroupLogo.png',
                                  width: 140,
                                  height: 140,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
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
        title: const Text('Recent Reading'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
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
                      fontSize: 14,
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
                        fontSize: 20,
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
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          TextSpan(
                            text: '${_calculateTotalReadingTime().toInt()}',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: selectedPeriod == 'week'
                                ? ' minutes this week!'
                                : selectedPeriod == 'month'
                                    ? ' minutes this month!'
                                    : ' minutes this year!',
                            style: const TextStyle(
                              fontSize: 16,
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

  // 修改群组数据
  final List<Map<String, dynamic>> readingUsers = [
    {
      'name': 'Wenhao',
      'photo': 'assets/images/Wenhao.png',
    },
    {
      'name': 'Qijing',
      'photo': 'assets/images/Qijing.png',
    },
  ];

  final List<Map<String, dynamic>> notReadingUsers = [
    {
      'name': 'Andy',
      'photo': 'assets/images/Andy.png',
    },
    {
      'name': 'Valerio',
      'photo': 'assets/images/Valerio.png',
    },
    {
      'name': 'Leah',
      'photo': 'assets/images/Leah.png',
    },
    {
      'name': 'Duncan',
      'photo': 'assets/images/Duncan.png',
    },
    {
      'name': 'Qijie',
      'photo': 'assets/images/Qijie.png',
    },
    {
      'name': 'Ke',
      'photo': 'assets/images/Ke.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // 创建按指定顺序排列的用户列表
    final orderedUsers = [
      notReadingUsers.firstWhere((user) => user['name'] == 'Andy'),
      notReadingUsers.firstWhere((user) => user['name'] == 'Valerio'),
      notReadingUsers.firstWhere((user) => user['name'] == 'Leah'),
      notReadingUsers.firstWhere((user) => user['name'] == 'Duncan'),
      notReadingUsers.firstWhere((user) => user['name'] == 'Qijie'),
      notReadingUsers.firstWhere((user) => user['name'] == 'Ke'),
      readingUsers.firstWhere((user) => user['name'] == 'Wenhao'),
      readingUsers.firstWhere((user) => user['name'] == 'Qijing'),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 45, 25, 16),
        child: SingleChildScrollView(
          // 添加滚动功能
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
              // Members 内容
              if (selectedTab == 'Members')
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
                    const SizedBox(height: 5), // 将原来的 40 改为 20，减少间距
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
                                            height: 112,
                                            fit: BoxFit.contain,
                                          ),
                                          const SizedBox(width: 20),
                                          Image.asset(
                                            i == 0
                                                ? 'assets/images/GroupLogo3.png' // 第一行使用 GroupLogo3
                                                : 'assets/images/GroupLogo2.png', // 其他行使用 GroupLogo2
                                            width: 160,
                                            height: 225,
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
