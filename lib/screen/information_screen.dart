import 'package:flutter/material.dart';
import 'package:flutter_projects/screen/signup_screen.dart';
import 'package:provider/provider.dart';
import 'allergy_provider.dart';
import 'food_provider.dart';
import 'food_select.dart';
import 'allergy_screen.dart';
import 'provider/food_provider.dart';
import 'provider/allergy_provider.dart';

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
        foregroundColor: Color(0xFF2F2F2F),
      ),
      body: ListView.builder(
        itemCount: informationItems.length,
        itemBuilder: (context, index) {
          final item = informationItems[index];
          return ListTile(
            /*title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item),
                if (item == '음식 선호도' && foodProvider.selectedFoods.isNotEmpty)
                  Flexible(
                    child: Text(
                      foodProvider.selectedFoods.join(', '),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                if (item == '식품 알레르기' && allergyProvider.allergies.isNotEmpty)
                  Flexible(
                    child: Text(
                      allergyProvider.allergies.join(', '),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
              ],
            ),*/
            title: Text(item),
            onTap: () {
              if (item == '기본정보 변경') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SignupScreen(fromInformationScreen: true),
                  ),
                );
              }

              if (item == '음식 선호도') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FoodSelectScreen(),
                  ),
                );
              }

              if (item == '식품 알레르기') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AllergyScreen(fromInformationScreen: true),
                  ),
                );
              }

              // ✨ 필요 시 다른 항목도 여기에 추가
            },
          );
        },
      ),
    );
  }
}