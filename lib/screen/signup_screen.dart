import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: '사용자 이름 입력'),
            ),
            TextField(
              decoration: InputDecoration(labelText: '아이디 입력'),
            ),
            TextField(
              decoration: InputDecoration(labelText: '비밀번호 입력'),
            ),
            TextField(
              decoration: InputDecoration(labelText: '비밀번호 확인'),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () {
              Navigator.pushNamed(context, '/login');
            }, child: Text('회원가입')),
          ],
        ),
      ),
    );
  }
}