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
              style: TextStyle(fontSize: 30)
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF5833),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: Text(
                  '로그인',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,
                    color: Color(0xFFFBFBFB),
                  ),
                ),
              ),
            SizedBox(height: 20),
            TextButton(onPressed: () {
              Navigator.pushNamed(context, '/signup');
            }, child: Text('처음 오신 친구인가요? 회원가입',
                style: TextStyle(color: Color(0xFFFF5833),
                ),
              )
            ),
            TextButton(onPressed: () {
              //Navigator.pushNamed(context, routeName) //다음으로 어디화면 갈지
            }, child: Text('아니요 다음에 할게요',
                style: TextStyle(color: Color(0xFFFF5833),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}