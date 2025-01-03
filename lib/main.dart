import 'package:flutter/material.dart';
import 'screen/start_screen.dart';
import 'screen/login_screen.dart';
import 'screen/signup_screen.dart';
import 'screen/success_screen.dart';
import 'screen/survey_screen.dart';
import 'screen/health_screen.dart';
import 'screen/food_screen.dart';
import 'package:google_fonts/google_fonts.dart'; // google_fonts 패키지 import

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFFBFBFB), // 전역 배경색 설정
        textTheme: TextTheme(
          bodyMedium: GoogleFonts.roboto( // Google Fonts를 사용해 Roboto 설정
            color: Color(0xFF2F2F2F), // 변경된 색상
          ),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color(0xFF2F2F2F), // 커서 색상 변경
          selectionColor: Color(0xFFE0E0E0), // 텍스트 선택 색상
          selectionHandleColor: Color(0xFFFF5833), // 선택 핸들 색상
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: GoogleFonts.roboto( // 라벨 텍스트 폰트도 Roboto로 설정
            color: Color(0xFF2F2F2F), // 변경된 색상
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFF2F2F2F), // 포커스된 이후 텍스트 색상
            ),
          ),
        ),
        fontFamily: 'Roboto', // 전역 폰트 설정

        // AppBar 스타일 추가
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFFBFBFB), // AppBar 배경색
          foregroundColor: Color(0xFF2F2F2F), // 변경된 색상
          elevation: 0, // 그림자 제거
          titleTextStyle: GoogleFonts.roboto( // AppBar 타이틀 폰트 설정
            color: Color(0xFF2F2F2F), // 변경된 색상
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          iconTheme: IconThemeData(
            color: Color(0xFF2F2F2F), // 변경된 색상
          ),
        ),

        // ElevatedButton 스타일 추가
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFF5833), // 배경색 설정
            foregroundColor: Color(0xFFFBFBFB), // 텍스트 색상 설정
            //splashFactory: NoSplash.splashFactory, // 클릭 시 효과 제거
          ),
        ),

        // TextButton 스타일 추가
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Color(0xFFE0E0E0), // 기본 텍스트 색상
            backgroundColor: Colors.transparent, // 기본 배경 색상
          ),
        ),
      ),
      initialRoute: '/start',
      routes: {
        '/start': (context) => StartScreen(selectedFoods: [],),
        '/login': (context) => LoginScreen(selectedFoods: [],),
        '/signup': (context) => SignupScreen(),
        '/success': (context) => SuccessScreen(),
        '/survey': (context) => SurveyScreen(selectedFoods: [],),
        '/health': (context) => HealthScreen(),
        '/food': (context) => FoodScreen(),
      },
    );
  }
}


class HoverTextButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color textColor; // 텍스트 색상을 외부에서 설정할 수 있도록 추가

  HoverTextButton({
    required this.text,
    required this.onPressed,
    this.textColor = const Color(0xFFFF5833), // 기본 텍스트 색상은 오렌지
  });

  @override
  _HoverTextButtonState createState() => _HoverTextButtonState();
}

class _HoverTextButtonState extends State<HoverTextButton> {
  bool isHovered = false; // Hover 상태
  bool isPressed = false; // 클릭 상태

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true), // Hover 시작
      onExit: (_) => setState(() => isHovered = false), // Hover 종료
      child: GestureDetector(
        onTapDown: (_) => setState(() => isPressed = true), // 클릭 시작
        onTapUp: (_) => setState(() => isPressed = false), // 클릭 종료
        onTapCancel: () => setState(() => isPressed = false), // 클릭 취소
        child: TextButton(
          onPressed: widget.onPressed,
          style: TextButton.styleFrom(
            backgroundColor: isPressed
                ? Color(0xFFCECECE) // 클릭 시 배경색 변경
                : (isHovered ? Color(0xFFE0E0E0) : Colors.transparent), // Hover 시 배경색 변경
            splashFactory: NoSplash.splashFactory, // 클릭 시 효과 제거
            //highlightColor: Colors.transparent, // 클릭 시 효과 제거
          ),
          child: Text(
            widget.text,
            style: TextStyle(
              color: widget.textColor, // 텍스트 색상은 변하지 않음
            ),
          ),
        ),
      ),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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
