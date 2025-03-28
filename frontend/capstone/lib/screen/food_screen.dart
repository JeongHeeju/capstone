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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: AppBar(
          backgroundColor: Color(0xFFFBFBFB),
          title: Text('음식 선호도 체크', style: TextStyle(color: Color(0xFF2F2F2F))),
          flexibleSpace: Container(
            decoration: BoxDecoration(color: Color(0xFFFBFBFB)),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text('선호하는 음식을 3개 이상 선택해 주세요',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text('선호에 맞는 음식을 추천해드려요',
                        style: TextStyle(fontSize: 12)),
                    SizedBox(height: 50),
                    Text('(${currentIndex + 1}/${_foodChoices.length})',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text(currentFood,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        currentImagePath,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () => selectFood(true),
                  icon: Icon(Icons.thumb_up, color: selectedButtonIndex == 0 ? Color(0xFFFBFBFB) : Color(0xFF2F2F2F)),
                  label: Text('선호', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  style: getButtonStyle(0),
                ),
                ElevatedButton.icon(
                  onPressed: () => selectFood(false),
                  icon: Icon(Icons.thumb_down, color: selectedButtonIndex == 1 ? Color(0xFFFBFBFB) : Color(0xFF2F2F2F)),
                  label: Text('비선호', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
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
