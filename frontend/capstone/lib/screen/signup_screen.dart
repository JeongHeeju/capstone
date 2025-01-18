import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _usernameController = TextEditingController();
  final _userIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  Future<void> signupUser() async {
    if (_passwordController.text != _passwordConfirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    final url = Uri.parse('http://127.0.0.1:8000/users/signup/');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': _usernameController.text,
          'user_id': _userIdController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입 성공! 로그인 화면으로 이동합니다.')),
        );
        Navigator.pushNamed(context, '/login');
      } else {
        final error = json.decode(response.body)['error'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입 실패: $error')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회원가입 중 오류 발생: $e')),
      );
    }
  }

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
              controller: _usernameController, // 컨트롤러 연결
              decoration: InputDecoration(labelText: '사용자 이름 입력'),
            ),
            TextField(
              controller: _userIdController, // 컨트롤러 연결
              decoration: InputDecoration(labelText: '아이디 입력'),
            ),
            TextField(
              controller: _passwordController, // 컨트롤러 연결
              decoration: InputDecoration(labelText: '비밀번호 입력'),
              obscureText: true, // 비밀번호 가림 처리
            ),
            TextField(
              controller: _passwordConfirmController, // 컨트롤러 연결
              decoration: InputDecoration(labelText: '비밀번호 확인'),
              obscureText: true, // 비밀번호 가림 처리
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: signupUser, // 회원가입 API 호출 함수 연결
              child: Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }
}
