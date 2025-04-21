import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../health_provider.dart'; // 이 줄 반드시 있어야 함

class HealthScreen extends StatefulWidget {
  final bool fromInformationScreen;

  const HealthScreen({super.key, this.fromInformationScreen = false});


  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class HealthInfo {
  final String gender;
  final DateTime? birthdate;
  final double height;
  final double weight;
  final List<String> conditions;

  HealthInfo({
    required this.gender,
    required this.birthdate,
    required this.height,
    required this.weight,
    required this.conditions,
  });
}

class _HealthScreenState extends State<HealthScreen> {
  final List<String> _medicalConditions = [
    '고혈압', '저혈압', '당뇨', '심장병', '천식', '암', '비만', '저체중', '갑상선 질환', '간 질환', '신장 질환', '고지혈증', '통풍'
  ];
  List<String> _selectedConditions = [];
  // ScrollController
  ScrollController _scrollController = ScrollController();

  bool _isMalePressed = false;
  bool _isFemalePressed = false;

  int? _selectedYear;
  int? _selectedMonth;
  int? _selectedDay;

  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  final List<int> _years = List.generate(100, (index) => 2023 - index); // 예시로 1923년부터 2023년까지 생성
  final List<int> _months = List.generate(12, (index) => index + 1);
  final List<int> _days = List.generate(31, (index) => index + 1);


  // 남성 버튼 클릭 시, 여성 버튼을 비활성화하고 남성만 활성화
  void _toggleGenderSelection(String gender) {
    setState(() {
      if (gender == 'male') {
        _isMalePressed = !_isMalePressed;
        if (_isMalePressed) {
          _isFemalePressed = false; // 여성 선택 취소
        }
      } else if (gender == 'female') {
        _isFemalePressed = !_isFemalePressed;
        if (_isFemalePressed) {
          _isMalePressed = false; // 남성 선택 취소
        }
      }
    });
  }

  void _toggleCondition(String condition) {
    setState(() {
      if (_selectedConditions.contains(condition)) {
        _selectedConditions.remove(condition);
      } else {
        _selectedConditions.add(condition);
      }
    });
  }

  @override
  void initState() {
    /*super.initState();
    _scrollController.addListener(() {
      setState(() {});
    });*/
    super.initState();

    final info = context.read<HealthProvider>().info;

    _isMalePressed = info.gender == 'male';
    _isFemalePressed = info.gender == 'female';
    _selectedYear = info.birthdate?.year;
    _selectedMonth = info.birthdate?.month;
    _selectedDay = info.birthdate?.day;
    _selectedConditions = List.from(info.conditions);

    _heightController.text = info.height > 0 ? info.height.toString() : '';
    _weightController.text = info.weight > 0 ? info.weight.toString() : '';
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: AppBar(
            backgroundColor: Color(0xFFFBFBFB),
            /*backgroundColor: _scrollController.hasClients && _scrollController.offset > 3
                ? Color(0xFFE0E0E0) // 스크롤 시 색상 변경
                : Color(0xFFFBFBFB),*/ // 기본색
            title: Text('기본 설문', style: TextStyle(color: Color(0xFF2F2F2F))),
            centerTitle: true,
            automaticallyImplyLeading: widget.fromInformationScreen,
            //automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: BoxDecoration(
            color: Color(0xFFFBFBFB), // 배경색 설정
            ),
          ),
            ),
        ),
      body: SingleChildScrollView(
        controller: _scrollController, // ScrollController를 SingleChildScrollView에 설정
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('성별', style: TextStyle(fontSize: 16, color: Color(0xFF2F2F2F))),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      _toggleGenderSelection('male');
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      decoration: BoxDecoration(
                        color: _isMalePressed ? Color(0xFFFBFBFB) : Color(0xFFFBFBFB),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: _isMalePressed ? Color(0xFF2F2F2F) : Color(0xFFE0E0E0),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '남성',
                        style: TextStyle(fontSize: 12, color: _isMalePressed ? Color(0xFF2F2F2F) : Color(0xFFE0E0E0)),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _toggleGenderSelection('female');
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      decoration: BoxDecoration(
                        color: _isFemalePressed ? Color(0xFFFBFBFB) : Color(0xFFFBFBFB),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: _isFemalePressed ? Color(0xFF2F2F2F) : Color(0xFFE0E0E0),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '여성',
                        style: TextStyle(color: _isFemalePressed ? Color(0xFF2F2F2F) : Color(0xFFE0E0E0), fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
              Text('생년월일', style: TextStyle(fontSize: 16, color: Color(0xFF2F2F2F))),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // 년도 선택
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                    decoration: BoxDecoration(
                      color: Color(0xFFFBFBFB),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: _selectedYear != null ? Color(0xFF2F2F2F) : Color(0xFFE0E0E0),
                        width: 1,
                      ),
                    ),
                    child: DropdownButton<int>(
                      value: _selectedYear,
                      hint: Text('년도', style: TextStyle(fontSize: 12, color: _selectedYear != null ? Color(0xFF2F2F2F) : Color(0xFFE0E0E0),)),
                      items: _years.map((year) {
                        return DropdownMenuItem<int>(
                          value: year,
                          child: Text(year.toString(), style: TextStyle(fontSize: 12, color: Color(0xFF2F2F2F))),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedYear = value;
                        });
                      },
                      dropdownColor: Color(0xFFFBFBFB),
                      style: TextStyle(fontSize: 12, color: Color(0xFF2F2F2F)),
                    ),
                  ),
                  // 월 선택
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                    decoration: BoxDecoration(
                      color: Color(0xFFFBFBFB),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: _selectedMonth != null ? Color(0xFF2F2F2F) : Color(0xFFE0E0E0),
                        width: 1,
                      ),
                    ),
                    child: DropdownButton<int>(
                      value: _selectedMonth,
                      hint: Text('월', style: TextStyle(fontSize: 12, color: _selectedMonth != null ? Color(0xFF2F2F2F) : Color(0xFFE0E0E0))),
                      items: _months.map((month) {
                        return DropdownMenuItem<int>(
                          value: month,
                          child: Text(month.toString().padLeft(2, '0'), style: TextStyle(fontSize: 12, color: Color(0xFF2F2F2F))),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedMonth = value;
                        });
                      },
                      dropdownColor: Color(0xFFFBFBFB),
                      style: TextStyle(fontSize: 12, color: Color(0xFF2F2F2F)),
                    ),
                  ),
                  // 일 선택
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                    decoration: BoxDecoration(
                      color: Color(0xFFFBFBFB),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: _selectedDay != null ? Color(0xFF2F2F2F) : Color(0xFFE0E0E0),
                        width: 1,
                      ),
                    ),
                    child: DropdownButton<int>(
                      value: _selectedDay,
                      hint: Text('일', style: TextStyle(fontSize: 12, color: _selectedDay != null ? Color(0xFF2F2F2F) : Color(0xFFE0E0E0))),
                      items: _days.map((day) {
                        return DropdownMenuItem<int>(
                          value: day,
                          child: Text(day.toString().padLeft(2, '0'), style: TextStyle(fontSize: 12, color: Color(0xFF2F2F2F))),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedDay = value;
                        });
                      },
                      dropdownColor: Color(0xFFFBFBFB),
                      style: TextStyle(fontSize: 12, color: Color(0xFF2F2F2F)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
              TextField(
                controller: _heightController, // ✅ 추가
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: '신장 (cm)',
                  labelStyle: TextStyle(color: Color(0xFF2F2F2F)),
                  hintText: '소수점 첫 번째까지 가능',
                  hintStyle: TextStyle(color: Color(0xFFE0E0E0)),
                ),
              ),
              SizedBox(height: 50),
              TextField(
                controller: _weightController, // ✅ 추가
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: '몸무게 (kg)',
                  labelStyle: TextStyle(color: Color(0xFF2F2F2F)),
                  hintText: '소수점 첫 번째까지 가능',
                  hintStyle: TextStyle(color: Color(0xFFE0E0E0)),
                ),
              ),
              SizedBox(height: 50),
              Text('진단받은 질환', style: TextStyle(fontSize: 16, color: Color(0xFF2F2F2F))),
              SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _medicalConditions.map((condition) {
                  final isSelected = _selectedConditions.contains(condition);
                  /*return ElevatedButton(
                    onPressed: () => _toggleCondition(condition),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected ? Color(0xFFFBFBFB) : Color(0xFFFBFBFB),
                      foregroundColor: isSelected ? Color(0xFF2F2F2F) : Color(0xFFE0E0E0),
                      splashFactory: NoSplash.splashFactory,
                      shadowColor: Colors.transparent,
                      animationDuration: Duration.zero,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    child: Text(
                      condition,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  );*/
                  return GestureDetector(
                    onTap: () => _toggleCondition(condition),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFFBFBFB) : const Color(0xFFFBFBFB),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: isSelected ? Color(0xFF2F2F2F) : Color(0xFFE0E0E0),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        condition,
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? const Color(0xFF2F2F2F) : const Color(0xFFE0E0E0),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 50),
              //다음 버튼(가운데 정렬)
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      final gender = _isMalePressed ? 'male' : _isFemalePressed ? 'female' : '';
                      final birthdate = (_selectedYear != null && _selectedMonth != null && _selectedDay != null)
                          ? DateTime(_selectedYear!, _selectedMonth!, _selectedDay!)
                          : null;

                      final healthInfo = HealthInfo(
                        gender: gender,
                        birthdate: birthdate,
                        height: double.tryParse(_heightController.text) ?? 0,
                        weight: double.tryParse(_weightController.text) ?? 0,
                        conditions: _selectedConditions,
                      );

                      context.read<HealthProvider>().setInfo(healthInfo); // 상태 저장

                      if (widget.fromInformationScreen) {
                        Navigator.pop(context); // 정보 화면에서 왔으면 저장 후 복귀
                      } else {
                        Navigator.pushNamed(context, '/food');// 아니면 다음 화면으로
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF5833),
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                    ),
                    child: Text(
                      widget.fromInformationScreen ? '저장' : '다음',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFFBFBFB)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}