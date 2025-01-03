import 'package:flutter/material.dart';
import 'allergy_screen.dart';
import 'dart:async';

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
  int? selectedButtonIndex; // 선택된 버튼의 인덱스 (0: 선호, 1: 비선호)
  Timer? _timer;  // 타이머 변수 추가

  // 선택된 음식 처리 함수
  void selectFood(bool isLiked) {
    if (isLiked) {
      selectedFoods.add(foodList[currentIndex]); // 선호 음식 추가
    }

    setState(() {
      selectedButtonIndex = isLiked ? 0 : 1; // 선호는 0, 비선호는 1로 설정
    });

    // 타이머를 시작하여 일정 시간 후 음식이 자동으로 바뀌게 함
    _startNextFoodTimer();
  }

  // 음식 자동으로 넘기기
  void goToNextFood() {
    // 음식이 바뀔 때마다 상태를 초기화하고 다음 음식으로 이동
    setState(() {
      if (currentIndex < foodList.length - 1) {
        currentIndex++; // 다음 음식으로 이동
        selectedButtonIndex = null; // 버튼 상태 초기화
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

  // 일정 시간이 지난 후에 자동으로 음식이 넘어가게 타이머 시작
  void _startNextFoodTimer() {
    if (_timer?.isActive ?? false) {
      _timer?.cancel(); // 이전 타이머가 이미 있으면 취소
    }
    _timer = Timer(Duration(seconds: 1), goToNextFood); // 1초 후 goToNextFood 실행
  }

  // 버튼의 스타일을 반환하는 함수
  ButtonStyle getButtonStyle(int buttonIndex) {
    bool isSelected = selectedButtonIndex == buttonIndex;
    return ElevatedButton.styleFrom(
      backgroundColor: isSelected ? Color(0xFFFF5833) : Color(0xFFE0E0E0),
      foregroundColor: isSelected ? Color(0xFFFBFBFB) : Color(0xFF2F2F2F),
      padding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); // 화면이 사라질 때 타이머 취소
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFBFBFB),
        title: Text('음식 선호도 체크', style: TextStyle(
            color: Color(0xFF2F2F2F)),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded( // 화면을 차지하는 스크롤 가능한 부분
              child: SingleChildScrollView( // 스크롤 가능한 영역
                child: Column(
                  children: [
                    Text(
                      '선호하는 음식을 3개 이상 선택해 주세요',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                        '선호에 맞는 음식을 추천해드려요',
                        style: TextStyle(fontSize: 12)),
                    SizedBox(height: 50),
                    Text(
                      '(${currentIndex + 1}/${foodList.length})',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
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
                    SizedBox(height: 50), // 필요한 여백
                  ],
                ),
              ),
            ),
            //Spacer(),
            // 버튼 영역은 Expanded 밖으로 배치되어 항상 화면 하단에 고정됩니다.
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => selectFood(true),
                    icon: Icon(Icons.thumb_up, color: selectedButtonIndex == 0 ? Color(0xFFFBFBFB) : Color(0xFF2F2F2F)),
                    label: Text('선호',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                    style: getButtonStyle(0),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => selectFood(false), // 비선호 버튼
                    icon: Icon(Icons.thumb_down, color: selectedButtonIndex == 1 ? Color(0xFFFBFBFB) : Color(0xFF2F2F2F)),
                    label: Text('비선호',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                    style: getButtonStyle(1),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}