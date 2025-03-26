import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key});

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  bool _isMalePressed = false;
  bool _isFemalePressed = false;

  int? _selectedYear;
  int? _selectedMonth;
  int? _selectedDay;

  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _medicalConditionsController = TextEditingController();

  final List<int> _years = List.generate(100, (index) => 2023 - index);
  final List<int> _months = List.generate(12, (index) => index + 1);
  final List<int> _days = List.generate(31, (index) => index + 1);

  ScrollController _scrollController = ScrollController();

  void _toggleGenderSelection(String gender) {
    setState(() {
      if (gender == 'male') {
        _isMalePressed = true;
        _isFemalePressed = false;
      } else {
        _isMalePressed = false;
        _isFemalePressed = true;
      }
    });
  }

  Future<void> savePersonalInfo() async {
    final gender = _isMalePressed
        ? '남성'
        : _isFemalePressed
            ? '여성'
            : null;

    if (gender == null ||
        _selectedYear == null ||
        _selectedMonth == null ||
        _selectedDay == null ||
        _heightController.text.isEmpty ||
        _weightController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('모든 항목을 입력해 주세요.')),
      );
      return;
    }

    final birthDate =
        '${_selectedYear.toString()}-${_selectedMonth.toString().padLeft(2, '0')}-${_selectedDay.toString().padLeft(2, '0')}';

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인이 필요합니다. 다시 로그인해주세요.')),
      );
      return;
    }

    final url = Uri.parse('http://127.0.0.1:8000/users/save_personal_info/');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
        body: json.encode({
          'gender': gender,
          'birth_date': birthDate,
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
        Navigator.pushNamed(context, '/food');
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
  void dispose() {
    _scrollController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _medicalConditionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: AppBar(
          backgroundColor: Color(0xFFFBFBFB),
          title: Text('기본 설문', style: TextStyle(color: Color(0xFF2F2F2F))),
          flexibleSpace: Container(
            decoration: BoxDecoration(color: Color(0xFFFBFBFB)),
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('성별', style: TextStyle(fontSize: 16)),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildGenderButton('남성', _isMalePressed, () => _toggleGenderSelection('male')),
                  _buildGenderButton('여성', _isFemalePressed, () => _toggleGenderSelection('female')),
                ],
              ),
              SizedBox(height: 50),
              Text('생년월일', style: TextStyle(fontSize: 16, color: Color(0xFF2F2F2F))),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildDropdown('년도', _selectedYear, _years, (val) => setState(() => _selectedYear = val)),
                  _buildDropdown('월', _selectedMonth, _months, (val) => setState(() => _selectedMonth = val)),
                  _buildDropdown('일', _selectedDay, _days, (val) => setState(() => _selectedDay = val)),
                ],
              ),
              SizedBox(height: 30),
              TextField(
                controller: _heightController,
                decoration: InputDecoration(labelText: '신장 (cm)', hintText: '소수점 첫 번째까지 가능'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 30),
              TextField(
                controller: _weightController,
                decoration: InputDecoration(labelText: '몸무게 (kg)', hintText: '소수점 첫 번째까지 가능'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 30),
              TextField(
                controller: _medicalConditionsController,
                decoration: InputDecoration(labelText: '진단받은 질환 (없으면 생략 가능)'),
              ),
              SizedBox(height: 50),
              Center(
                child: ElevatedButton(
                  onPressed: savePersonalInfo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF5833),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  ),
                  child: Text(
                    '다음',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFFBFBFB)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderButton(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
        decoration: BoxDecoration(
          color: Color(0xFFFBFBFB),
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: isSelected ? Color(0xFF2F2F2F) : Color(0xFFE0E0E0), width: 1),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 12, color: Color(0xFF2F2F2F)),
        ),
      ),
    );
  }

  Widget _buildDropdown(String hint, int? value, List<int> items, void Function(int?) onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Color(0xFFFBFBFB),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Color(0xFFE0E0E0), width: 1),
      ),
      child: DropdownButton<int>(
        value: value,
        hint: Text(hint, style: TextStyle(fontSize: 12, color: Color(0xFF2F2F2F))),
        items: items.map((item) {
          return DropdownMenuItem<int>(
            value: item,
            child: Text(item.toString().padLeft(2, '0'), style: TextStyle(fontSize: 12, color: Color(0xFF2F2F2F))),
          );
        }).toList(),
        onChanged: onChanged,
        dropdownColor: Color(0xFFFBFBFB),
        style: TextStyle(fontSize: 12, color: Color(0xFF2F2F2F)),
      ),
    );
  }
}


