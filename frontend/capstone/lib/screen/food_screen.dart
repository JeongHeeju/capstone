// food_screen.dart
import 'package:flutter/material.dart';
import 'allergy_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class FoodScreen extends StatefulWidget {
  @override
  _FoodScreenState createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  final List<Map<String, dynamic>> _foodChoices = [
    {"food_name": "불고기", "is_liked": null, "image": "assets/bulgogi.png"},
    {"food_name": "김치찌개", "is_liked": null, "image": "assets/kimchi.png"},
    {"food_name": "비빔밥", "is_liked": null, "image": "assets/bibimbap.png"},
    {"food_name": "떡볶이", "is_liked": null, "image": "assets/tteokbokki.png"},
    {"food_name": "삼겹살", "is_liked": null, "image": "assets/samgyeopsal.png"},
    {"food_name": "초밥", "is_liked": null, "image": "assets/sushi.png"},
    {"food_name": "햄버거", "is_liked": null, "image": "assets/burger.png"},
    {"food_name": "쌀국수", "is_liked": null, "image": "assets/pho.png"},
    {"food_name": "샐러드", "is_liked": null, "image": "assets/salad.png"},
    {"food_name": "케이크", "is_liked": null, "image": "assets/cake.png"},
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

  int currentIndex = 0;
  int? selectedButtonIndex;
  Timer? _timer;
  final List<String> selectedFoods = [];

  void selectFood(bool liked) {
    _foodChoices[currentIndex]["is_liked"] = liked;
    if (liked) {
      selectedFoods.add(_foodChoices[currentIndex]["food_name"]);
    }

    setState(() {
      selectedButtonIndex = liked ? 0 : 1;
    });

    _startNextFoodTimer();
  }

  void goToNextFood() {
    if (currentIndex < _foodChoices.length - 1) {
      setState(() {
        currentIndex++;
        selectedButtonIndex = null;
      });
    } else {
      _submitFoodPreferences().then((success) {
        if (success) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AllergyScreen(selectedFoods: selectedFoods),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('음식 선호도 전송 실패')),
          );
        }
      });
    }
  }

  void _startNextFoodTimer() {
    _timer?.cancel();
    _timer = Timer(Duration(seconds: 1), goToNextFood);
  }

  Future<bool> _submitFoodPreferences() async {
    final url = Uri.parse('http://127.0.0.1:8000/users/save_food_preferences/');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final requestBody = _foodChoices.map((f) {
      return {
        "food_name": f["food_name"],
        "is_liked": f["is_liked"] ?? false,
        "tags": foodTags[f["food_name"]] ?? [],
      };
    }).toList();

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Token $token",
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 201) {
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

  ButtonStyle getButtonStyle(int buttonIndex) {
    bool isSelected = selectedButtonIndex == buttonIndex;
    return ElevatedButton.styleFrom(
      backgroundColor: isSelected ? Color(0xFFFF5833) : Color(0xFFE0E0E0),
      foregroundColor: isSelected ? Color(0xFFFBFBFB) : Color(0xFF2F2F2F),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentFood = _foodChoices[currentIndex]["food_name"];
    final currentImagePath = _foodChoices[currentIndex]["image"];

    return Scaffold(
      appBar: AppBar(
        title: Text('음식 선호도 체크'),
        backgroundColor: Color(0xFFFBFBFB),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text('선호하는 음식을 선택해 주세요'),
                  SizedBox(height: 30),
                  Text('(${currentIndex + 1}/${_foodChoices.length})'),
                  Text(currentFood, style: TextStyle(fontSize: 24)),
                  SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      currentImagePath,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () => selectFood(true),
                  icon: Icon(Icons.thumb_up),
                  label: Text('선호'),
                  style: getButtonStyle(0),
                ),
                ElevatedButton.icon(
                  onPressed: () => selectFood(false),
                  icon: Icon(Icons.thumb_down),
                  label: Text('비선호'),
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

