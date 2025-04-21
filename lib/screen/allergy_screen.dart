import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chat_screen.dart';
import 'allergy_provider.dart';
import 'food_provider.dart';
import 'food_screen.dart';

class AllergyScreen extends StatefulWidget {
  final bool fromInformationScreen;

  const AllergyScreen({super.key, this.fromInformationScreen = false});

  @override
  State<AllergyScreen> createState() => _AllergyScreenState();
}

class _AllergyScreenState extends State<AllergyScreen> {
  bool showResult = false;
  late List<String> _tempAllergies;

  @override
  void initState() {
    super.initState();
    final allergyProvider = Provider.of<AllergyProvider>(context, listen: false);
    _tempAllergies = List.from(allergyProvider.allergies);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ModalRoute.of(context)?.addScopedWillPopCallback(_onWillPop);
    });
  }

  Future<bool> _onWillPop() async {
    final allergyProvider = Provider.of<AllergyProvider>(context, listen: false);
    allergyProvider.setAllergies(_tempAllergies);
    return true;
  }

  @override
  void dispose() {
    ModalRoute.of(context)?.removeScopedWillPopCallback(_onWillPop);
    super.dispose();
  }

  void goToChat(List<String> allergies) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ChatScreen(
            selectedFoods: const [],
            allergies: allergies,
          ),
        ),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    final allergyProvider = Provider.of<AllergyProvider>(context);
    final foodProvider = Provider.of<FoodProvider>(context);
    final allergies = allergyProvider.allergies;
    final selectedFoods = foodProvider.selectedFoods;

    if (showResult) {
      // 결과 화면을 표시
      return Scaffold(
        /*appBar: AppBar(
          backgroundColor: Color(0xFFFBFBFB),
          title: Text('결과 화면', style: TextStyle(
              color: Color(0xFF2F2F2F)),
          ),
        ),*/
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.0),
          child: AppBar(
            backgroundColor: Color(0xFFFBFBFB),
            /*backgroundColor: _scrollController.hasClients && _scrollController.offset > 3
                ? Color(0xFFE0E0E0) // 스크롤 시 색상 변경
                : Color(0xFFFBFBFB),*/ // 기본색
            title: Text('결과 화면', style: TextStyle(color: Color(0xFF2F2F2F))),
            centerTitle: true,
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                color: Color(0xFFFBFBFB), // 배경색 설정
              ),
            ),
          ),
        ),
        body: Center(
          child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('선호하는 음식', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(
                selectedFoods.isNotEmpty ? selectedFoods.join(', ') : '없음',
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 50),
              const Text('알레르기 음식', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(
                allergies.isNotEmpty ? allergies.join(', ') : '없음',
                style: const TextStyle(fontSize: 12),
              ),
              const Spacer(),
              if (!widget.fromInformationScreen)// 남은 공간을 채워서 버튼을 하단에 배치
              SizedBox(
                child: ElevatedButton(
                  onPressed: () {
                    // ChatScreen으로 selectedFoods와 allergies를 전달
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          selectedFoods: const [],
                          allergies: allergies,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF5833),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  ),
                  child: const Text(
                    '채팅 시작하기',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,
                      color: Color(0xFFFBFBFB),
                    ),
                  ),
                ),
              )
            else
                SizedBox(
                  child: ElevatedButton(
                    onPressed: () {
                      // ChatScreen으로 selectedFoods와 allergies를 전달
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF5833),
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                    ),
                    child: const Text(
                      '저장',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,
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

  return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFBFBFB),
        title: Text('식품 알레르기', style: TextStyle(
            color: Color(0xFF2F2F2F)),
        ),
        centerTitle: true,
        automaticallyImplyLeading: widget.fromInformationScreen,
        //automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '알레르기 음식을 모두 선택해 주세요',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              '푸렌즈가 알레르기 음식을 기억할게요!',
              style: TextStyle(fontSize: 12),
            ),
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
                  ].map((item) {
                    final isSelected = allergies.contains(item);
                    return ElevatedButton(
                      onPressed: () => allergyProvider.toggleAllergy(item),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected
                            ? const Color(0xFFFF5833)
                            : const Color(0xFFE0E0E0),
                        foregroundColor: isSelected
                            ? const Color(0xFFFBFBFB)
                            : const Color(0xFF323232),
                        splashFactory: NoSplash.splashFactory, // 클릭 시 효과 제거
                        shadowColor: Colors.transparent,
                        animationDuration: Duration.zero, // 색상 변경 애니메이션 제거
                        elevation: 0,
                        //highlightColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      child: Text(
                        item,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
                    if (widget.fromInformationScreen) {
                      Navigator.pop(context); // 바로 되돌아가기
                    } else {
                      setState(() {
                        showResult = true;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF5833),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  ),
                  child: Text(
                    //'완료',
                    widget.fromInformationScreen ? '저장' : '완료',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFFBFBFB)),
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