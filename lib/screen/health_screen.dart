import 'package:flutter/material.dart';

class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key});

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFBFBFB),
        title: Text('기본 설문', style: TextStyle(
            color: Color(0xFF323232)),
        ),
      ),
      body: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('1. 성별을 선택해주세요'),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    '남성',
                    style: TextStyle(
                      color: Color(0xFF323232)  // 글자색을 검정색으로 설정
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFBFBFB),  // 배경색을 흰색으로 설정
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    '여성',
                    style: TextStyle(
                        color: Color(0xFF323232)  // 글자색을 검정색으로 설정
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFBFBFB),  // 배경색을 흰색으로 설정
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    ),
                  ),
                ],
              ),
            SizedBox(height: 30),
            TextField(
              decoration: InputDecoration(labelText: '2. 생년월일을 입력해주세요'),
            ),
            SizedBox(height: 50),
            TextField(
              decoration: InputDecoration(labelText: '3. 신장을 입력해주세요\n(소수점 첫번째까지 가능)'),
            ),
            SizedBox(height: 50),
            TextField(
              decoration: InputDecoration(labelText: '4. 몸무게를 입력해주세요\n(소수점 첫번째까지 가능)'),
            ),
            SizedBox(height: 50),
            TextField(
              decoration: InputDecoration(labelText: '5. 진단받은 질환이 있다면\n모두 입력해주세요'),
            ),
            SizedBox(height: 100),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () {
              Navigator.pushNamed(context, '/food');
              },
              style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFF5833),
              padding: EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text(
                  '다음',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,
                  color: Color(0xFFFBFBFB),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}