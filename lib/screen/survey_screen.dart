import 'package:flutter/material.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                '간단한 설문 조사를 통해\n나만의 푸렌즈를 만나보세요',
                style: TextStyle(fontSize: 24)
            ),
            SizedBox(height: 20),
            TextButton(onPressed: () {
              //Navigator.pushNamed(context, '/signup');//다음으로 어디화면 갈지
            }, child: Text('건너뛰기', style: TextStyle(color: Color(0xFFFF5833))),
            ),
            TextButton(onPressed: () {
              Navigator.pushNamed(context, '/health');
            }, child: Text('설문조사 하러 가기', style: TextStyle(color: Color(0xFFFF5833))),
            ),
          ],
        ),
      ),
    );
  }
}