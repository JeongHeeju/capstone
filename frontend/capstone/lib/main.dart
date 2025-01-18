import 'package:flutter/material.dart';
import 'package:flutter_projects/screen/allergy_screen.dart';
import 'package:flutter_projects/screen/chatserve_screen.dart';
import 'screen/start_screen.dart';
import 'screen/login_screen.dart';
import 'screen/signup_screen.dart';
import 'screen/success_screen.dart';
import 'screen/survey_screen.dart';
import 'screen/health_screen.dart';
import 'screen/food_screen.dart';
import 'screen/allergy_screen.dart';
import 'screen/chat_screen.dart';
import 'screen/chatserve_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFFBFBFB),// 전역 배경색 설정
        textTheme: TextTheme(
        bodyMedium: TextStyle(color: Color(0xFF323232)),// 전역 글자색 설정
            ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color(0xFF323232), // 커서 색상
          selectionColor: Color(0xFFFF5833), // 텍스트 선택 색상
          selectionHandleColor: Color(0xFFFF5833), // 선택 핸들 색상
        ),
        inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(color: Color(0xFF323232)),//라벨텍스트 색상
            focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
            color: Color(0xFFFF5833),//포커스된 이후 텍스트색상
            ),
          ),
        ),
      ),
      initialRoute: '/start',
      routes: {
        '/start' : (context) => StartScreen(),
        '/login' : (context) => LoginScreen(),
        '/signup' : (context) => SignupScreen(),
        '/success' : (context) => SuccessScreen(),
        '/survey' : (context) => SurveyScreen(),
        '/health' : (context) => HealthScreen(),
        '/food' : (context) => FoodScreen(),
        '/allergy' : (context) => AllergyScreen(),
        '/chat': (context) => ChatScreen(),
        '/chatserve' : (context) => ChatserveScreen(),
      },
    );
  }
}

class CustomScaffold extends StatelessWidget {
  final Widget child;

  CustomScaffold({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: child,
          ),
        ),
      ),
    );
  }
}

class HoverAndClickButton extends StatefulWidget {
  @override
  _HoverAndClickButtonState createState() => _HoverAndClickButtonState();
}

class _HoverAndClickButtonState extends State<HoverAndClickButton> {
  bool isHovered = false; // Hover 상태
  bool isPressed = false; // 클릭 상태

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hover & Click Button Example')),
      body: Center(
        child: MouseRegion(
          onEnter: (_) => setState(() => isHovered = true), // Hover 시작
          onExit: (_) => setState(() => isHovered = false), // Hover 종료
          child: GestureDetector(
            onTapDown: (_) => setState(() => isPressed = true), // 클릭 시작
            onTapUp: (_) => setState(() => isPressed = false), // 클릭 종료
            onTapCancel: () => setState(() => isPressed = false), // 클릭 취소
            child: Material(
              color: Colors.transparent, // 클릭 효과 제거를 위해 배경 투명화
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200), // 애니메이션 지속 시간
                width: 150,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isPressed
                      ? Color(0xFFFF5833) // 클릭 상태 색상
                      : isHovered
                      ? Color(0xFFFF5833) // Hover 상태 색상
                      : Color(0xFFFBFBFB), // 기본 색상
                  borderRadius: BorderRadius.circular(20), // 둥근 모서리
                ),
                child: Text(
                  'Hover & Click',
                  style: TextStyle(
                    color: isPressed || isHovered ? Colors.white : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
