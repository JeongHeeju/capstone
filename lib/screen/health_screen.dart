/*import 'package:flutter/material.dart';

class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key});

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  // 성별 선택 상태 변수
  bool _isMalePressed = false;
  bool _isFemalePressed = false;

  int? _selectedYear;
  int? _selectedMonth;
  int? _selectedDay;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFBFBFB),
        title: Text('기본 설문', style: TextStyle(color: Color(0xFF2F2F2F))),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('성별',
              style: TextStyle(
              fontSize: 16,
              ),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      _toggleGenderSelection('male');
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                        color: _isMalePressed ? Color(0xFFFBFBFB) : Color(0xFFFBFBFB),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _isMalePressed ? Color(0xFF2F2F2F) : Color(0xFFE0E0E0),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '남성',
                        style: TextStyle(
                          color: _isMalePressed ? Color(0xFF2F2F2F) : Color(0xFF2F2F2F),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _toggleGenderSelection('female');
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                        color: _isFemalePressed ? Color(0xFFFBFBFB) : Color(0xFFFBFBFB),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _isFemalePressed ? Color(0xFF2F2F2F) : Color(0xFFE0E0E0),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '여성',
                        style: TextStyle(
                          color: _isFemalePressed ? Color(0xFF2F2F2F) : Color(0xFF2F2F2F),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Text('생년월일',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF2F2F2F),
                ),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // 년도 선택
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      color: Color(0xFFFBFBFB),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Color(0xFFE0E0E0), width: 1),
                    ),
                    child: DropdownButton<int>(
                      value: _selectedYear,
                      hint: Text('년도',
                        style: TextStyle(
                        fontSize: 16,
                            color: Color(0xFF2F2F2F),
                      ),
                      ),
                      items: _years.map((year) {
                        return DropdownMenuItem<int>(
                          value: year,
                          child: Text(year.toString()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedYear = value;
                        });
                      },
                    ),
                  ),
                  // 월 선택
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      color: Color(0xFFFBFBFB),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Color(0xFFE0E0E0), width: 1),
                    ),
                    child: DropdownButton<int>(
                      value: _selectedMonth,
                      hint: Text('월',
                        style: TextStyle(
                        fontSize: 16,
                          color: Color(0xFF2F2F2F),
                      ),
                      ),
                      items: _months.map((month) {
                        return DropdownMenuItem<int>(
                          value: month,
                          child: Text(month.toString()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedMonth = value;
                        });
                      },
                    ),
                  ),
                  // 일 선택
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      color: Color(0xFFFBFBFB),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Color(0xFFE0E0E0), width: 1),
                    ),
                    child: DropdownButton<int>(
                      value: _selectedDay,
                      hint: Text('일',
                        style: TextStyle(
                        fontSize: 16,
                          color: Color(0xFF2F2F2F),
                      ),
                      ),
                      items: _days.map((day) {
                        return DropdownMenuItem<int>(
                          value: day,
                          child: Text(day.toString()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedDay = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
              TextField(
                decoration: InputDecoration(labelText: '신장'),
              ),
              SizedBox(height: 50),
              TextField(
                decoration: InputDecoration(labelText: '몸무게'),
              ),
              SizedBox(height: 50),
              TextField(
                decoration: InputDecoration(labelText: '진단받은 질환'),
              ),
              SizedBox(height: 100),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/food');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF5833),
                    padding: EdgeInsets.symmetric(vertical: 15),
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
}
*/

/*import 'package:flutter/material.dart';

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

  final List<int> _years = List.generate(100, (index) => 2024 - index); // 예시로 1923년부터 2024년까지 생성
  final List<int> _months = List.generate(12, (index) => index + 1);
  final List<int> _days = List.generate(31, (index) => index + 1);

  void _toggleGenderSelection(String gender) {
    setState(() {
      if (gender == 'male') {
        _isMalePressed = !_isMalePressed;
        if (_isMalePressed) {
          _isFemalePressed = false;
        }
      } else if (gender == 'female') {
        _isFemalePressed = !_isFemalePressed;
        if (_isFemalePressed) {
          _isMalePressed = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFBFBFB),
        title: Text('기본 설문', style: TextStyle(color: Color(0xFF2F2F2F))),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('성별', style: TextStyle(fontSize: 16)),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      _toggleGenderSelection('male');
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                      decoration: BoxDecoration(
                        color: _isMalePressed ? Color(0xFFFBFBFB) : Color(0xFFFBFBFB),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: _isMalePressed ? Color(0xFF2F2F2F) : Color(0xFFE0E0E0),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '남성',
                        style: TextStyle(fontSize: 12, color: _isMalePressed ? Color(0xFF2F2F2F) : Color(0xFF2F2F2F)),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _toggleGenderSelection('female');
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                      decoration: BoxDecoration(
                        color: _isFemalePressed ? Color(0xFFFBFBFB) : Color(0xFFFBFBFB),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: _isFemalePressed ? Color(0xFF2F2F2F) : Color(0xFFE0E0E0),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '여성',
                        style: TextStyle(color: _isFemalePressed ? Color(0xFF2F2F2F) : Color(0xFF2F2F2F), fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
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
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Color(0xFFE0E0E0), width: 1),
                    ),
                    child: DropdownButton<int>(
                      value: _selectedYear,
                      hint: Text('년도', style: TextStyle(fontSize: 12, color: Color(0xFF2F2F2F))),
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
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Color(0xFFE0E0E0), width: 1),
                    ),
                    child: DropdownButton<int>(
                      value: _selectedMonth,
                      hint: Text('월', style: TextStyle(fontSize: 12, color: Color(0xFF2F2F2F))),
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
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Color(0xFFE0E0E0), width: 1),
                    ),
                    child: DropdownButton<int>(
                      value: _selectedDay,
                      hint: Text('일', style: TextStyle(fontSize: 12, color: Color(0xFF2F2F2F))),
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
                decoration: InputDecoration(
                    labelText: '신장',
                    hintText: '소수점 첫 번째까지 가능', // 초기 메시지
                    hintStyle: TextStyle(color: Color(0xFFE0E0E0)), // hintText 색상 변경
                ),
              ),
              SizedBox(height: 50),
              TextField(
                decoration: InputDecoration(
                  labelText: '몸무게',
                  hintText: '소수점 첫 번째까지 가능', // 초기 메시지
                  hintStyle: TextStyle(color: Color(0xFFE0E0E0)), // hintText 색상 변경
                ),
              ),
              SizedBox(height: 50),
              TextField(
                decoration: InputDecoration(
                  labelText: '진단받은 질환',
                  hintText: '모두 입력해주세요', // 초기 메시지
                  hintStyle: TextStyle(color: Color(0xFFE0E0E0)), // hintText 색상 변경
                ),
              ),
              SizedBox(height: 100),
              //다음 버튼(가운데 정렬)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/food');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF5833),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  ),
                  child: Text(
                    '다음',
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
}*/

import 'package:flutter/material.dart';

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

  final List<int> _years = List.generate(100, (index) => 2023 - index); // 예시로 1923년부터 2023년까지 생성
  final List<int> _months = List.generate(12, (index) => index + 1);
  final List<int> _days = List.generate(31, (index) => index + 1);

  // ScrollController
  ScrollController _scrollController = ScrollController();

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

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Color(0xFFFBFBFB),
        backgroundColor: _scrollController.hasClients && _scrollController.offset > 3
            ? Color(0xFFE0E0E0) // 스크롤 시 색상 변경
            : Color(0xFFFBFBFB), // 기본색
        title: Text('기본 설문', style: TextStyle(color: Color(0xFF2F2F2F))),
      ),
      body: SingleChildScrollView(
        controller: _scrollController, // ScrollController를 SingleChildScrollView에 설정
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
                  GestureDetector(
                    onTap: () {
                      _toggleGenderSelection('male');
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
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
                        style: TextStyle(fontSize: 12, color: _isMalePressed ? Color(0xFF2F2F2F) : Color(0xFF2F2F2F)),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _toggleGenderSelection('female');
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
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
                        style: TextStyle(color: _isFemalePressed ? Color(0xFF2F2F2F) : Color(0xFF2F2F2F), fontSize: 12),
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
                      border: Border.all(color: Color(0xFFE0E0E0), width: 1),
                    ),
                    child: DropdownButton<int>(
                      value: _selectedYear,
                      hint: Text('년도', style: TextStyle(fontSize: 12, color: Color(0xFF2F2F2F))),
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
                      border: Border.all(color: Color(0xFFE0E0E0), width: 1),
                    ),
                    child: DropdownButton<int>(
                      value: _selectedMonth,
                      hint: Text('월', style: TextStyle(fontSize: 12, color: Color(0xFF2F2F2F))),
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
                      border: Border.all(color: Color(0xFFE0E0E0), width: 1),
                    ),
                    child: DropdownButton<int>(
                      value: _selectedDay,
                      hint: Text('일', style: TextStyle(fontSize: 12, color: Color(0xFF2F2F2F))),
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
                decoration: InputDecoration(labelText: '신장', hintText: '소수점 첫 번째까지 가능', hintStyle: TextStyle(color: Color(0xFFE0E0E0))),
              ),
              SizedBox(height: 50),
              TextField(
                decoration: InputDecoration(labelText: '몸무게', hintText: '소수점 첫 번째까지 가능', hintStyle: TextStyle(color: Color(0xFFE0E0E0))),
              ),
              SizedBox(height: 50),
              TextField(
                decoration: InputDecoration(labelText: '진단받은 질환', hintText: '모두 입력해주세요', hintStyle: TextStyle(color: Color(0xFFE0E0E0))),
              ),
              SizedBox(height: 100),
              //다음 버튼(가운데 정렬)
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/food');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF5833),
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                    ),
                    child: Text(
                      '다음',
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


