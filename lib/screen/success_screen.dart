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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '밥 친구가 된 걸\n환영해요!',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold, // 예: 얇은 글꼴 (300)
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF5833),
                padding: EdgeInsets.symmetric(horizontal: 70, vertical: 20),
              ),
              child: Text(
                '로그인',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                  color: Color(0xFFFBFBFB),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}