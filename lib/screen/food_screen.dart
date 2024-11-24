import 'package:flutter/material.dart';
import 'allergy_screen.dart';

/*class FoodScreen extends StatefulWidget {
  const FoodScreen({super.key});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

  class _FoodScreenState extends State<FoodScreen> {
  int currentIndex = 0; // 현재 음식의 인덱스
  List<String> preferences = []; // 선호 목록

  final List<Map<String, String>> foodData = [
    {"name": "불고기", "image": "https://example.com/bulgogi.jpg"}, // 여기에 실제 이미지 URL 사용
    {"name": "피자", "image": "https://example.com/kimchi.jpg"},
    {"name": "떡볶이", "image": "https://example.com/bibimbap.jpg"},
    {"name": "짜장면", "image": "https://example.com/bibimbap.jpg"},
    {"name": "케이크", "image": "https://example.com/bibimbap.jpg"},
  ];

  void _selectPreference(bool isLiked) {
    setState(() {
      if (isLiked) {
        preferences.add(foodData[currentIndex]["name"]!);
      }
      if (currentIndex < foodData.length - 1) {
        currentIndex++;
      } else {
        // 모든 음식이 끝났을 때 알레르기 페이지 이동)
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              preferences: preferences, selectedAllergies: [],// 선호 음식 데이터 전달
            ),
          ),
        );
      }
    });
  }

  void _nextFood() {
    setState(() {
      if (currentIndex < foodData.length - 1) {
        currentIndex++; // 다음 음식으로 이동
      } else {
        // 모든 음식이 끝났을 때 처리 (결과 화면 이동)Navigator.pushNamed(context, '/allergy');
        Navigator.pushNamed(context, '/allergy');
      }
    });
  }*/

class FoodScreen extends StatefulWidget {
  @override
  _FoodScreenState createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  final List<String> foodList = ['불고기', '김치찌개', '비빔밥', '떡볶이', '삼겹살'];
  final List<String> selectedFoods = [];
  int currentIndex = 0; // 현재 음식 인덱스

  void selectFood(bool isLiked) {
    if (isLiked) {
      selectedFoods.add(foodList[currentIndex]); // 선호 음식 추가
    }

    setState(() {
      if (currentIndex < foodList.length - 1) {
        currentIndex++; // 다음 음식으로 이동
      } else {
        // 모든 음식에 대한 선택이 끝난 경우
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AllergyScreen(selectedFoods: selectedFoods),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFBFBFB),
        title: Text('음식 선호도 체크', style: TextStyle(
            color: Color(0xFF323232)),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '선호하는 음식을 3개 이상 선택해 주세요',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
                '선호에 맞는 음식을 추천해드려요',
                style: TextStyle(fontSize: 12)),
            SizedBox(height: 20),
            Text(
              '(${currentIndex + 1}/${foodList.length})',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              foodList[currentIndex], // 현재 음식 표시
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/food${currentIndex + 1}.png', // 음식 이미지 경로 (예제용)
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () => selectFood(true),
                  icon: Icon(Icons.thumb_up, color: Color(0xFFFBFBFB)),
                  label: Text(
                    '선호',
                    style: TextStyle(
                      color: Color(0xFFFBFBFB),  // 글자 색상을 지정
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => selectFood(false),
                  icon: Icon(Icons.thumb_down, color: Color(0xFFFBFBFB)),
                  label: Text(
                    '비선호',
                    style: TextStyle(
                      color: Color(0xFFFBFBFB),  // 글자 색상을 지정
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}