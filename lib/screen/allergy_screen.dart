import 'package:flutter/material.dart';
import 'chat_screen.dart';

class AllergyScreen extends StatefulWidget {
  final List<String> selectedFoods;

  AllergyScreen({required this.selectedFoods});

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

  /*void toggleAllergy(String allergy) {
    setState(() {
      if (allergies.contains(allergy)) {
        allergies.remove(allergy);
      } else {
        allergies.add(allergy);
      }
    });
  }*/

  @override
  Widget build(BuildContext context) {
    if (showResult) {
      // 결과 화면을 표시
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFBFBFB),
          title: Text('결과 화면', style: TextStyle(
              color: Color(0xFF2F2F2F)),
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
              Spacer(), // 남은 공간을 채워서 버튼을 하단에 배치
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // ChatScreen으로 selectedFoods와 allergies를 전달
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          selectedFoods: widget.selectedFoods, // 전달
                          allergies: allergies, // 전달
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF5833),
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text(
                    '채팅하러 가기',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,
                      color: Color(0xFFFBFBFB),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
/*class AllergyScreen extends StatefulWidget {
  const AllergyScreen({super.key});

  @override
  State<AllergyScreen> createState() => _AllergyScreenState();
}

class _AllergyScreenState extends State<AllergyScreen> {
  final List<String> items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ]; // 선택 가능한 항목들
  final Set<String> selectedItems = {};
  final List<String> selectedAllergies = [];

  // 알레르기 항목 리스트
  final List<String> allergyItems = [
    '고등어', '새우', '오징어', '게',
    '조개류', '난류 (가금류)', '소고기', '우유',
    '돼지고기', '땅콩', '닭고기', '호두',
    '잣', '대두', '복숭아', '밀',
    '아황산류', '토마토',
  ];

  // 항목 선택/해제
  void toggleSelection(String item) {
    setState(() {
      if (selectedAllergies.contains(item)) {
        selectedAllergies.remove(item); // 이미 선택된 항목은 제거
      } else {
        selectedAllergies.add(item); // 선택되지 않은 항목은 추가
      }
    });
  }*/

  return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFBFBFB),
        title: Text('식품 알레르기 체크', style: TextStyle(
            color: Color(0xFF2F2F2F)),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            /*Align(
              alignment: Alignment.center,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '알레르기가 있는 음식을 모두 선택해 주세요\n',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2F2F2F)), // 첫 번째 부분 색상 설정
                    ),
                    TextSpan(
                      text: '푸렌즈가 알레르기 음식을 기억할게요!',
                      style: TextStyle(fontSize: 12, color: Color(0xFF2F2F2F)), // 두 번째 부분 색상 설정
                    ),
                  ],
                ),
              ),
            ),*/
            SizedBox(height: 50),
            // 알레르기 항목 버튼 리스트
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 10, // 버튼 간격
                  runSpacing: 10, // 줄 간격
                  children: [
                    '고등어', '새우', '오징어', '게',
                    '조개류', '난류 (가금류)', '소고기', '우유',
                    '돼지고기', '땅콩', '닭고기', '호두',
                    '잣', '대두', '복숭아', '밀',
                    '아황산류', '토마토',
                  ].map((allergy) {
                    final isSelected = allergies.contains(allergy);
                    return GestureDetector(
                      onTap: () => toggleAllergy(allergy),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: allergies.contains(allergy)
                              ? Color(0xFFFF5833)
                              : Color(0xFFE0E0E0),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          allergy,
                          style: TextStyle(
                            color: allergies.contains(allergy)
                                ? Color(0xFFFBFBFB)
                                : Color(0xFF2F2F2F),
                            //color: isSelected ? Color(0xFFFBFBFB) : Color(0xFF323232),
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
            //SizedBox(height: 100),
            // 완료 버튼
            //완료 버튼(가운데 정렬)
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
            ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          selectedFoods: widget.selectedFoods, // 전달
                          allergies: allergies, // 전달
                        ),
                      ),
                    );
                  },
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
          ],
        ),
      ),
    );
  }
}

/*class ResultScreen extends StatefulWidget {
  final List<String> selectedAllergies;
  final List<String> preferences;

  const ResultScreen({
    super.key,
    required this.selectedAllergies,
    required this.preferences,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late List<String> selectedAllergies; // 상태로 관리되는 알레르기
  late List<String> preferences;      // 상태로 관리되는 선호 음식 데이터

  @override
  void initState() {
    super.initState();
    // 초기 상태 설정
    selectedAllergies = widget.selectedAllergies;
    preferences = widget.preferences;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('결과 화면'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '선호한 음식 목록:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: preferences.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(preferences[index]),
                  );
                },
              ),
            ),
            Text(
              '선택된 알레르기: ${widget.selectedAllergies.join(", ")}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        ),
      ),
    );
  }
}*/
  /*@override
  Widget build(BuildContext context) {
    final preferences = ModalRoute.of(context)?.settings.arguments as List<String>;

    return Scaffold(
      appBar: AppBar(
        title: Text('결과 화면'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(
          '선호한 음식 목록:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: selectedAllergies.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(selectedAllergies[index]),
              );
            },
          ),
        ),
        SizedBox(height: 20),
        Text(
          '선택된 알레르기: ${selectedAllergies.join(", ")}',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
    );
  }
}*/