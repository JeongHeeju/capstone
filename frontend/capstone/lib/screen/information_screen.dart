import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screen/food_provider.dart';
import '../screen/allergy_provider.dart';
import 'food_select.dart';
import 'allergy_screen.dart';

class InformationScreen extends StatelessWidget {
  const InformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final foodProvider = Provider.of<FoodProvider>(context);
    final allergyProvider = Provider.of<AllergyProvider>(context);

    final List<String> informationItems = [
      '기본정보 변경',
      '기본 설문',
      '음식 선호도',
      '식품 알레르기',
      '로그아웃',
      '회원탈퇴',
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBFBFB),
        title: const Text('회원정보', style: TextStyle(color: Color(0xFF2F2F2F))),
        centerTitle: true,
        foregroundColor: const Color(0xFF2F2F2F),
      ),
      body: ListView.builder(
        itemCount: informationItems.length,
        itemBuilder: (context, index) {
          final item = informationItems[index];
          return ListTile(
            title: Text(item),
            onTap: () {
              if (item == '음식 선호도') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FoodSelectScreen(),
                  ),
                );
              }

              if (item == '식품 알레르기') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AllergyScreen(selectedFoods: foodProvider.selectedFoods),
                  ),
                );
              }

              // TODO: 필요 시 다른 항목도 여기에 추가
            },
          );
        },
      ),
    );
  }
}
