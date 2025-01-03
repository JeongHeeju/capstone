import 'package:flutter/material.dart';
import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  final List<String> selectedFoods;

  LoginScreen({required this.selectedFoods});


  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  List<String> allergies = [];
  bool showResult = false;
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
      appBar: AppBar(
        backgroundColor: Color(0xFFFBFBFB),
        title: Text('로그인', style: TextStyle(color: Color(0xFF2F2F2F))),
      ),
      body: Column(
        children: [
          Expanded( // 화면을 채우고 남는 공간을 차지하는 부분
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20),
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
          ),
        ],
      ),
    );
  }

}
