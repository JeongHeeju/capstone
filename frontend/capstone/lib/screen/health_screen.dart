import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key});

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  String? _selectedGender; // 성별 선택
  final _birthDateController = TextEditingController(); // 생년월일 입력
  final _heightController = TextEditingController(); // 신장 입력
  final _weightController = TextEditingController(); // 몸무게 입력
  final _medicalConditionsController = TextEditingController(); // 진단받은 질환 입력

  // Django 서버에 데이터 저장
  Future<void> savePersonalInfo() async {
    if (_selectedGender == null || _birthDateController.text.isEmpty ||
        _heightController.text.isEmpty || _weightController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('모든 항목을 입력해 주세요.')),
      );
      return;
    }

    // 날짜 형식 유효성 검사
    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(_birthDateController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('생년월일을 YYYY-MM-DD 형식으로 입력해주세요.')),
      );
      return;
    }

    final url = Uri.parse('http://127.0.0.1:8000/users/save_personal_info/'); 
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'gender': _selectedGender,
          'birth_date': _birthDateController.text,
          'height': double.tryParse(_heightController.text),
          'weight': double.tryParse(_weightController.text),
          'medical_conditions': _medicalConditionsController.text,
        }),
      );

      if (response.statusCode == 201) {
        print('Personal info saved successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('정보가 저장되었습니다.')),
        );
        Navigator.pushNamed(context, '/food'); // 음식 선호도 화면으로 이동
      } else {
        print('Failed to save personal info: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('정보 저장에 실패했습니다. 다시 시도해주세요.')),
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFBFBFB),
        title: Text(
          '기본 설문',
          style: TextStyle(color: Color(0xFF323232)),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('1. 성별을 선택해주세요'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedGender = '남성';
                      });
                    },
                    child: Text(
                      '남성',
                      style: TextStyle(
                        color: _selectedGender == '남성' ? Colors.white : Color(0xFF323232),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _selectedGender == '남성' ? Colors.blue : Color(0xFFFBFBFB),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedGender = '여성';
                      });
                    },
                    child: Text(
                      '여성',
                      style: TextStyle(
                        color: _selectedGender == '여성' ? Colors.white : Color(0xFF323232),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _selectedGender == '여성' ? Colors.pink : Color(0xFFFBFBFB),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              TextField(
                controller: _birthDateController,
                decoration: InputDecoration(labelText: '2. 생년월일을 입력해주세요 (YYYY-MM-DD)'),
              ),
              SizedBox(height: 30),
              TextField(
                controller: _heightController,
                decoration: InputDecoration(labelText: '3. 신장을 입력해주세요\n(소수점 첫번째까지 가능)'),
              ),
              SizedBox(height: 30),
              TextField(
                controller: _weightController,
                decoration: InputDecoration(labelText: '4. 몸무게를 입력해주세요\n(소수점 첫번째까지 가능)'),
              ),
              SizedBox(height: 30),
              TextField(
                controller: _medicalConditionsController,
                decoration: InputDecoration(labelText: '5. 진단받은 질환이 있다면\n모두 입력해주세요'),
              ),
              SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: savePersonalInfo, // Django 서버로 데이터 저장
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF5833),
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text(
                    '다음',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
