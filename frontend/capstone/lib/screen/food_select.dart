import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FoodSelectScreen extends StatefulWidget {
  final bool fromInformationScreen;

  FoodSelectScreen({this.fromInformationScreen = false});

  @override
  _FoodSelectScreenState createState() => _FoodSelectScreenState();
}

class _FoodSelectScreenState extends State<FoodSelectScreen> {
  final List<Map<String, String>> foodItems = const [
    {"name": "불고기", "image": "assets/bulgogi.png"},
    {"name": "김치찌개", "image": "assets/kimchi.png"},
    {"name": "비빔밥", "image": "assets/bibimbap.png"},
    {"name": "떡볶이",  "image": "assets/tteokbokki.png"},
    {"name": "삼겹살", "image": "assets/samgyeopsal.png"},
    {"name": "초밥",  "image": "assets/sushi.png"},
    {"name": "햄버거", "image": "assets/burger.png"},
    {"name": "쌀국수", "image": "assets/pho.png"},
    {"name": "샐러드", "image": "assets/salad.png"},
    {"name": "케이크", "image": "assets/cake.png"},
  ];

  final Map<String, List<String>> foodTags = {
    "불고기": ["양념고기", "익힌고기", "소고기", "달짝지근한 맛"],
    "김치찌개": ["매운맛", "국물요리", "김치"],
    "비빔밥": ["야채", "밥", "고추장", "비벼먹는"],
    "떡볶이": ["맵고단", "떡", "매운맛", "분식"],
    "삼겹살": ["구이", "돼지고기", "고기"],
    "초밥": ["생선", "밥", "일식", "회"],
    "햄버거": ["패스트푸드", "고기", "빵", "양상추"],
    "쌀국수": ["베트남", "국물요리", "쌀면"],
    "샐러드": ["야채", "건강식", "가벼운식사"],
    "케이크": ["디저트", "달콤한", "베이커리"],
  };

  final Set<String> selectedFoods = {};

  Future<void> _submitSelectedFoods() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인이 필요합니다.')),
      );
      return;
    }

    final requestBody = selectedFoods.map((name) {
      return {
        "food_name": name,
        "is_liked": true,
        "tags": foodTags[name] ?? [],
      };
    }).toList();

    final url = Uri.parse('http://127.0.0.1:8000/users/save_food_preferences/');
    try {
      final response = await http.post( 
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('음식 선호도가 저장되었습니다.')),
        );
        Navigator.pop(context);
      } else {
        final decoded = jsonDecode(response.body);
        final errorMsg = decoded['message'] ?? '오류 발생';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('저장 실패: $errorMsg')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('네트워크 오류: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('음식 선호도'),
        backgroundColor: const Color(0xFFFBFBFB),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFBFBFB),
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Color(0xFFFBFBFB)
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: const [
                Text(
                  '선호하는 음식을 선택해 주세요',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  '푸렌즈가 선호에 맞는 음식을 추천해 드려요!',
                  style: TextStyle(fontSize: 12, color: Color(0xFF2F2F2F)),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1,
              children: foodItems.map((item) {
                final name = item['name']!;
                final image = item['image']!;
                final isSelected = selectedFoods.contains(name);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedFoods.remove(name);
                      } else {
                        selectedFoods.add(name);
                      }
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            image,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Color(0xFFFF5833) : Color(0xFFE0E0E0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _submitSelectedFoods,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5833),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
            ),
            child: const Text(
              '저장',
              style: TextStyle(fontSize: 16, color: Color(0xFFFBFBFB)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
