import 'package:flutter/material.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '새로운 밥친구를\n사귀어 봐요!',
              style: TextStyle(fontSize: 36)
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () {
              Navigator.pushNamed(context, '/signup');
            }, child: Text('가입하기')),
            TextButton(onPressed: () {
              //Navigator.pushNamed(context, routeName) //다음으로 어디화면 갈지
            }, child: Text('아니요 다음에 할게요')),
          ],
        ),
      ),
    );
  }
}