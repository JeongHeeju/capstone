import 'package:flutter/material.dart';
import 'chat_screen.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chat_screen.dart';

class HoverTextButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final VoidCallback onPressed;

  const HoverTextButton({required this.text, required this.textColor, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(text, style: TextStyle(color: textColor)),
    );
  }
}

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  List<String> allergies = [];
  bool showResult = false;

  Future<void> skipSurvey() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('토큰이 없습니다. 다시 로그인 해주세요.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          userToken: token,
          // selectedFoods: [], // 필요한 경우 넘기기
          // allergies: [],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '간단한 설문 조사를 통해\n',
                    style: TextStyle(fontSize: 24, color: Color(0xFF2F2F2F)),
                  ),
                  TextSpan(
                    text: '나만의 푸렌즈를 만나보세요',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF2F2F2F)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/health');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF5833),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              ),
              child: Text(
                '설문조사 하러 가기',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFFBFBFB)),
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: skipSurvey,
              child: Text(
                '건너뛰기',
                style: TextStyle(color: Color(0xFF9F9F9F), fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
