import 'package:flutter/material.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBFBFB),
      body: Stack(
        children: [
          Positioned(
            top: 200, 
            left: 460, 
            child: Image.asset(
              'assets/icon2.png',
              height: 120,
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20), // 텍스트를 조금 더 아래로 내리기 위해 추가
                Text(
                  '밥 친구가 된 걸\n환영해요!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2F2F2F),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
