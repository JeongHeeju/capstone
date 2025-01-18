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

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FoodScreen extends StatefulWidget {
  @override
  _FoodScreenState createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  final List<Map<String, dynamic>> _foodChoices = [
    {"food_name": "불고기", "is_liked": null},
    {"food_name": "김치찌개", "is_liked": null},
    {"food_name": "비빔밥", "is_liked": null},
    {"food_name": "떡볶이", "is_liked": null},
    {"food_name": "삼겹살", "is_liked": null},
  ];
  int currentIndex = 0;

  // 사용자가 음식에 대한 선호/비선호 버튼 클릭 시
  void selectFood(bool liked) {
    // liked == true -> 선호, false -> 비선호
    _foodChoices[currentIndex]["is_liked"] = liked;

    setState(() {
      if (currentIndex < _foodChoices.length - 1) {
        currentIndex++;
      } else {
        // 마지막 음식까지 선택 완료 → 서버로 전송 or 다음 화면 이동
        _submitFoodPreferences().then((success) {
          if (success) {
            // 전송 성공 시 알러지 화면으로 이동
            Navigator.pushNamed(context, '/allergy');
          } else {
            // 실패 시 메시지 표시 등
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('음식 선호도 전송 실패')),
            );
          }
        });
      }
    });
  }

  // 서버로 음식 선호도 전송하는 함수
  Future<bool> _submitFoodPreferences() async {
    // 1) POST 요청할 URL
    final url = Uri.parse('http://127.0.0.1:8000/users/save_food_preferences/');

    // 2) body에 들어갈 JSON 데이터 만들기
    //    [{"food_name":"불고기","is_liked":true}, ...]
    //    null인 애들은 제외하거나, 일단 false로 처리 가능
    final requestBody = _foodChoices.map((f) {
      return {
        "food_name": f["food_name"],
        "is_liked": f["is_liked"] ?? false, // null일 경우 false 처리
      };
    }).toList();

    try {
      // 3) http POST 요청
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );

      // 4) 응답 확인
      if (response.statusCode == 201) {
        // 정상적으로 저장됨
        print("Food preferences saved successfully!");
        return true;
      } else {
        print("Failed to save: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error occurred: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // 현재 음식 이름, 이미지 등 가져오기
    final currentFoodName = _foodChoices[currentIndex]["food_name"];

    return Scaffold(
      appBar: AppBar(
        title: Text('음식 선호도 체크'),
        backgroundColor: Color(0xFFFBFBFB),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Text(
              '(${currentIndex + 1}/${_foodChoices.length})',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              currentFoodName, // 현재 음식 표시
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            // 이미지 표시
            SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/food${currentIndex + 1}.png', 
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
                  icon: Icon(Icons.thumb_up),
                  label: Text('선호'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
                ElevatedButton.icon(
                  onPressed: () => selectFood(false),
                  icon: Icon(Icons.thumb_down),
                  label: Text('비선호'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
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
