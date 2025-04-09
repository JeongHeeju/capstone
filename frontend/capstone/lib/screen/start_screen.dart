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
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // 텍스트 및 버튼
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40), // 아이콘을 위한 공간 확보
                Text(
                  '새로운 밥 친구를\n사귀어 봐요!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2F2F2F),
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF5833),
                    padding: EdgeInsets.symmetric(horizontal: 70, vertical: 20),
                  ),
                  child: Text(
                    '로그인',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFBFBFB),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: Text(
                    '처음 오신 친구인가요? 회원가입',
                    style: TextStyle(color: Color(0xFFFF5833)),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/chat');
                  },
                  child: Text(
                    '다음에 할게요',
                    style: TextStyle(color: Color(0xFF9F9F9F)),
                  ),
                ),
              ],
            ),

            Positioned(
              top: 210,
              left: -10,
              child: Image.asset(
                'assets/icon1.png',
                height: 60,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
