import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'chat_screen.dart'; 

class AllergyScreen extends StatefulWidget {
  final List<String> selectedFoods; 

  AllergyScreen({this.selectedFoods = const []});

  @override
  State<AllergyScreen> createState() => _AllergyScreenState();
}

class _AllergyScreenState extends State<AllergyScreen> {
  List<String> allergies = [];

  bool showResult = false;

  void toggleAllergy(String allergy) {
    setState(() {
      if (allergies.contains(allergy)) {
        allergies.remove(allergy);
      } else {
        allergies.add(allergy);
      }
    });
  }

  // 실제 알러지 항목들 (UI 버튼용)
  final List<String> allergyItems = [
    '고등어', '새우', '오징어', '게',
    '조개류', '난류 (가금류)', '소고기', '우유',
    '돼지고기', '땅콩', '닭고기', '호두',
    '잣', '대두', '복숭아', '밀',
    '아황산류', '토마토',
  ];

  // 서버로 알러지 정보 전송
  Future<void> saveAllergyInfo() async {
    final url = Uri.parse('http://127.0.0.1:8000/users/save_allergy_info/');
    try {
      // POST 요청
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(
          allergies.map((allergy) => {'allergy_name': allergy}).toList(),
        ),
      );

      if (response.statusCode == 201) {
        print('Allergy info saved successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('알러지 정보가 저장되었습니다.')),
        );
        // 저장 성공 → "결과 화면"으로 전환
        setState(() {
          showResult = true;
        });
      } else {
        print('Failed to save allergy info: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('알러지 정보 저장 실패: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Error occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('네트워크 오류가 발생했습니다. 다시 시도해주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // showResult == true → 결과 화면
    if (showResult) {
      return _buildResultScreen();
    }
    return _buildAllergySelectionScreen();
  }

  // [A] 알러지 선택 화면 UI
  Widget _buildAllergySelectionScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFBFBFB),
        title: Text(
          '식품 알레르기 체크',
          style: TextStyle(color: Color(0xFF2F2F2F)),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              '알레르기가 있는 음식을 모두 선택해 주세요',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              '푸렌즈가 알레르기 음식을 기억할게요!',
              style: TextStyle(fontSize: 12),
            ),
            SizedBox(height: 20),
            // 알러지 항목 버튼들
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: allergyItems.map((item) {
                    final isSelected = allergies.contains(item);
                    return GestureDetector(
                      onTap: () => toggleAllergy(item),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? Color(0xFFFF5833) : Color(0xFFE0E0E0),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          item,
                          style: TextStyle(
                            color: isSelected ? Color(0xFFFBFBFB) : Color(0xFF2F2F2F),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            // 완료 버튼 → 서버 전송
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: saveAllergyInfo, // 여기서 서버 POST
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF5833),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  ),
                  child: Text(
                    '완료',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFFBFBFB)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // [B] 결과 화면 UI
  Widget _buildResultScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFBFBFB),
        title: Text(
          '결과 화면',
          style: TextStyle(color: Color(0xFF2F2F2F)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('선호하는 음식:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(widget.selectedFoods.join(', ')),
            SizedBox(height: 16),
            Text('알레르기가 있는 음식:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(allergies.isNotEmpty ? allergies.join(', ') : '없음'),
            Spacer(),
            // "채팅하러 가기" 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/chat');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF5833),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  '채팅하러 가기',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFFBFBFB)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
