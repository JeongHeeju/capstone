import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFBFBFB),
        title: Text('로그인', style: TextStyle(
    color: Color(0xFF323232)),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: '아이디 입력'),
            ),
            SizedBox(height: 50),
            TextField(
              decoration: InputDecoration(labelText: '비밀번호 입력'),
            ),
            SizedBox(height: 100),
            ElevatedButton(onPressed: () {
              Navigator.pushNamed(context, '/survey');
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
          ],
        ),
      ),
    );
  }
}