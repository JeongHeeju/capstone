import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userIdController = TextEditingController();
  final _passwordController = TextEditingController();

  // 로그인 API 호출
  Future<void> loginUser() async {
    // 서버 URL
    final url = Uri.parse('http://127.0.0.1:8000/users/login/'); // 백엔드 주소

    // POST 요청 보내기
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json', // JSON 형식으로 데이터를 보냄
      },
      body: json.encode({
        'user_id': _userIdController.text,  // 사용자 아이디
        'password': _passwordController.text, // 비밀번호
      }),
    );

    // 서버 응답 처리
    if (response.statusCode == 200) {
      // 로그인 성공
      final data = json.decode(response.body);
      print('Login successful: ${data['message']}');
      // 여기에서 로그인이 성공하면 다른 화면으로 이동하거나 토큰을 저장할 수 있습니다.
      Navigator.pushNamed(context, '/survey');
    } else {
      // 로그인 실패
      final error = json.decode(response.body)['error'];
      print('Login failed: $error');
      // 에러 메시지를 사용자에게 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인 실패: $error')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인'),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              controller: _userIdController,
              decoration: InputDecoration(labelText: '아이디 입력'),
            ),
            TextField(
              controller: _passwordController, 
              decoration: InputDecoration(labelText: '비밀번호 입력'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: loginUser, 
              child: Text('로그인')),
          ],
        ),
      ),
    );
  }
}