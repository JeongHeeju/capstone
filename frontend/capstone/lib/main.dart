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
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFFBFBFB),
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Color(0xFF323232)),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color(0xFF323232),
          selectionColor: Color(0xFFFF5833),
          selectionHandleColor: Color(0xFFFF5833),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Color(0xFF323232)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFF5833)),
          ),
        ),
      ),
      initialRoute: '/start',
      routes: {
        '/start': (context) => StartScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/success': (context) => SuccessScreen(),
        '/survey': (context) => SurveyScreen(),
        '/health': (context) => HealthScreen(),
        '/food': (context) => FoodScreen(),
        '/allergy': (context) => AllergyScreen(),
        '/chatserve': (context) => ChatserveScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/chat') {
          return MaterialPageRoute(builder: (context) => FutureBuilder(
              future: SharedPreferences.getInstance(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                  final prefs = snapshot.data!;
                  final userToken = prefs.getString('token') ?? '';
                  return ChatScreen(userToken: userToken);
                }
                return Scaffold(body: Center(child: CircularProgressIndicator()));
              }
          ));
        }
        return null;
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
  bool isHovered = false;
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hover & Click Button Example')),
      body: Center(
        child: MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: GestureDetector(
            onTapDown: (_) => setState(() => isPressed = true),
            onTapUp: (_) => setState(() => isPressed = false),
            onTapCancel: () => setState(() => isPressed = false),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: 150,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isPressed || isHovered ? Color(0xFFFF5833) : Color(0xFFFBFBFB),
                borderRadius: BorderRadius.circular(20),
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
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
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
      ),
    );
  }
}
