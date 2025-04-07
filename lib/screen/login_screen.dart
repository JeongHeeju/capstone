import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  final List<String> selectedFoods;

  LoginScreen({required this.selectedFoods});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  List<String> allergies = [];
  bool showResult = false;
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
        'user_id': _userIdController.text, // 사용자 아이디
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

  // 비밀번호 보이기/숨기기 상태
  bool _isPasswordVisible = false;

  // 비밀번호 입력 필드 클릭 여부
  bool _isPasswordFieldTapped = false;

  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFBFBFB),
        title: Text('로그인', style: TextStyle(color: Color(0xFF2F2F2F))),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            // 아이디 입력 필드
            TextField(
              controller: _idController,
              decoration: InputDecoration(
                  labelText: '아이디 입력',
              ),
            ),
            SizedBox(height: 50),
            // 비밀번호 입력 필드
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible, // 비밀번호 보이기/숨기기 설정
              decoration: InputDecoration(
                labelText: '비밀번호 입력',
                suffixIcon: _isPasswordFieldTapped
                    ? IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Color(0xFF2F2F2F),
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible; // 비밀번호 보이기/숨기기 토글
                    });
                  },
                )
                    : null, // 클릭 시 아이콘이 보이도록 설정
              ),
              onTap: () {
                setState(() {
                  _isPasswordFieldTapped = true; // 텍스트 필드 클릭 시 아이콘 보이기
                });
              },
            ),
            SizedBox(height: 100),
            // 로그인 버튼
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/survey');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF5833),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
              ),
              child: Text(
                '로그인',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFFBFBFB)),
              ),
            ),
          ],
        ),
      ),
    );
  }*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        backgroundColor: Color(0xFFFBFBFB),
        title: Text('로그인', style: TextStyle(color: Color(0xFF2F2F2F))),
      ),*/
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: AppBar(
          backgroundColor: Color(0xFFFBFBFB),
          /*backgroundColor: _scrollController.hasClients && _scrollController.offset > 3
                ? Color(0xFFE0E0E0) // 스크롤 시 색상 변경
                : Color(0xFFFBFBFB),*/ // 기본색
          title: Text('로그인', style: TextStyle(color: Color(0xFF2F2F2F))),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Color(0xFFFBFBFB), // 배경색 설정
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            // 화면을 채우고 남는 공간을 차지하는 부분
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    // 아이디 입력 필드
                    TextField(
                      controller: _userIdController,
                      decoration: InputDecoration(
                        labelText: '아이디 입력',
                      ),
                    ),
                    SizedBox(height: 50),
                    // 비밀번호 입력 필드
                    TextField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible, // 비밀번호 보이기/숨기기 설정
                      decoration: InputDecoration(
                        labelText: '비밀번호 입력',
                        suffixIcon: _isPasswordFieldTapped
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0), // 패딩 값 추가
                                child: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Color(0xFF2F2F2F),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible =
                                          !_isPasswordVisible; // 비밀번호 보이기/숨기기 토글
                                    });
                                  },
                                ),
                              )
                            : null, // 클릭 시 아이콘이 보이도록 설정
                      ),
                      onTap: () {
                        setState(() {
                          _isPasswordFieldTapped = true; // 텍스트 필드 클릭 시 아이콘 보이기
                        });
                      },
                    ),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
          // 하단 고정된 버튼
          Padding(
            padding: const EdgeInsets.all(20),
            //padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              /*onPressed: () {
                Navigator.pushNamed(context, '/survey');
              },*/
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
                    color: Color(0xFFFBFBFB)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
