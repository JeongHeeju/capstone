import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userIdController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isPasswordFieldTapped = false;

  Future<void> loginUser() async {
    final url = Uri.parse('http://127.0.0.1:8000/users/login/');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'user_id': _userIdController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']); // ✅ 토큰 저장

      print('Login successful. Token: ${data['token']}');
      Navigator.pushNamed(context, '/survey');
    } else {
      final error = json.decode(response.body)['error'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인 실패: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: AppBar(
          backgroundColor: Color(0xFFFBFBFB),
          title: Text('로그인', style: TextStyle(color: Color(0xFF2F2F2F))),
          flexibleSpace: Container(
            decoration: BoxDecoration(color: Color(0xFFFBFBFB)),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextField(
                      controller: _userIdController,
                      decoration: InputDecoration(labelText: '아이디 입력'),
                    ),
                    SizedBox(height: 50),
                    TextField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: '비밀번호 입력',
                        suffixIcon: _isPasswordFieldTapped
                            ? Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                    color: Color(0xFF2F2F2F),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                              )
                            : null,
                      ),
                      onTap: () {
                        setState(() {
                          _isPasswordFieldTapped = true;
                        });
                      },
                    ),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: loginUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF5833),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
              ),
              child: Text(
                '로그인',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFBFBFB),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
