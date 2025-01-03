import 'package:flutter/material.dart';
import 'chat_screen.dart';
import '../main.dart';

class SurveyScreen extends StatefulWidget {
  final List<String> selectedFoods;

  SurveyScreen({required this.selectedFoods});

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  List<String> allergies = [];
  bool showResult = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '간단한 설문 조사를 통해\n',
                    style: TextStyle(fontSize: 24, color: Color(0xFF2F2F2F)), // 첫 번째 부분 색상 설정
                  ),
                  TextSpan(
                    text: '나만의 푸렌즈를 만나보세요',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF2F2F2F)), // 두 번째 부분 색상 설정
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () {
              Navigator.pushNamed(context, '/health');
            },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF5833),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              ),
              child: Text(
                '설문조사 하러 가기',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                  color: Color(0xFFFBFBFB),
                ),
              ),
            ),
            SizedBox(height: 16),
            /*HoverTextButton(onPressed: () {
              //Navigator.pushNamed(context, '/signup');//다음으로 어디화면 갈지
            }, child: Text('건너뛰기', style: TextStyle(color: Color(0xFF9F9F9F))),
            ),*/
            HoverTextButton(
              text: '건너뛰기',
              textColor: Color(0xFF9F9F9F),
              onPressed: () {
                Navigator.push(context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      selectedFoods: widget.selectedFoods, // 전달
                      allergies: allergies, // 전달
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}