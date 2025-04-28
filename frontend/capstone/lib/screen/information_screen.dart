import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screen/food_provider.dart';
import '../screen/allergy_provider.dart';
import 'food_select.dart';
import 'allergy_screen.dart';
import 'signup_screen.dart';
import 'health_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


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
          onTap: () async {
            if (item == '기본정보 변경') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SignupScreen()),
            );
          }

           if (item == '기본 설문') {
              Navigator.push(
               context,
                MaterialPageRoute(
                  builder: (_) => HealthScreen(fromInformationScreen: true),
              ),
            );
          }

          if (item == '음식 선호도') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => FoodSelectScreen()),
            );
          }

          if (item == '식품 알레르기') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AllergyScreen(selectedFoods: foodProvider.selectedFoods)),
            );
          }

          if (item == '로그아웃') {
            final prefs = await SharedPreferences.getInstance(); 
            await prefs.remove('token'); // 토큰 제거
            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            }
          }
          if (item == '회원탈퇴') {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: Colors.white,
                title: Text("회원탈퇴"),
                content: Text("정말 탈퇴하시겠습니까?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false), // 아니요
                    child: Text("아니요"),
                 ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true), // 예
                    child: Text("예"),
                  ),
                ],
              ),
            );

            if (confirm == true) {
              final prefs = await SharedPreferences.getInstance();
              final token = prefs.getString('token');

              if (token != null) {
                final url = Uri.parse('http://127.0.0.1:8000/users/delete_account/'); 
                final response = await http.delete(
                  url,
                  headers: {
                    'Authorization': 'Token $token',
                    'Content-Type': 'application/json',
                  },
                );

                if (response.statusCode == 204 || response.statusCode == 200) {
                  await prefs.remove('token');
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('회원탈퇴가 완료되었습니다.')),
                    );
                    Navigator.pushNamedAndRemoveUntil(context, '/start', (route) => false);
                 }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('회원탈퇴에 실패했습니다. 다시 시도해주세요.')),
                  );
                }
              }
           }
          }
        }
        
          );
        },
      ),
    );
  }
}
