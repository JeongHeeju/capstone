import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/food_provider.dart';
import 'food_provider.dart';

class FoodSelectScreen extends StatelessWidget {
  const FoodSelectScreen({super.key});

  final List<Map<String, String>> foodItems = const [
    {'name': '김치찌개', 'image': 'assets/food1.png'},
    {'name': '비빔밥', 'image': 'assets/food2.png'},
    {'name': '떡볶이', 'image': 'assets/food3.png'},
    {'name': '짜장면', 'image': 'assets/food4.png'},
    {'name': '초밥', 'image': 'assets/food5.png'},
    {'name': '햄버거', 'image': 'assets/food6.png'},
    {'name': '삼겹살', 'image': 'assets/food7.png'},
    {'name': '쌀국수', 'image': 'assets/food8.png'},
    {'name': '샐러드', 'image': 'assets/food9.png'},
    {'name': '케이크', 'image': 'assets/food10.png'},
  ];

  @override
  Widget build(BuildContext context) {
    final foodProvider = Provider.of<FoodProvider>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: AppBar(
          backgroundColor: Color(0xFFFBFBFB),
          /*backgroundColor: _scrollController.hasClients && _scrollController.offset > 3
                ? Color(0xFFE0E0E0) // 스크롤 시 색상 변경
                : Color(0xFFFBFBFB),*/ // 기본색
          title: Text('음식 선호도', style: TextStyle(color: Color(0xFF2F2F2F))),
          centerTitle: true,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Color(0xFFFBFBFB), // 배경색 설정
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  '선호하는 음식을 선택해 주세요',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                const Text(
                  '푸렌즈가 선호에 맞는 음식을 추천해 드려요!',
                  style: TextStyle(fontSize: 12, color: Color(0xFF2F2F2F)),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.symmetric(horizontal: 24), // 원하는 곳만 padding
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1,
              children: foodItems.map((item) {
                final name = item['name']!;
                final image = item['image']!;
                final isSelected = foodProvider.selectedFoods.contains(name);

                return GestureDetector(
                  onTap: () => foodProvider.toggleFood(name),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          image,
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? const Color(0xFFFF5833) : Color(0xFFE0E0E0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5833),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
              ),
              child: const Text(
                '저장',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFFBFBFB)),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/food_provider.dart';
import 'food_provider.dart';

class FoodSelectScreen extends StatelessWidget {
  const FoodSelectScreen({super.key});

  final List<Map<String, String>> foodItems = const [
    {'name': '김치찌개', 'image': 'assets/food1.png'},
    {'name': '비빔밥', 'image': 'assets/food2.png'},
    {'name': '떡볶이', 'image': 'assets/food3.png'},
    {'name': '짜장면', 'image': 'assets/food4.png'},
    {'name': '초밥', 'image': 'assets/food5.png'},
    {'name': '햄버거', 'image': 'assets/food6.png'},
    {'name': '삼겹살', 'image': 'assets/food7.png'},
    {'name': '쌀국수', 'image': 'assets/food8.png'},
    {'name': '샐러드', 'image': 'assets/food9.png'},
    {'name': '케이크', 'image': 'assets/food10.png'},
  ];

  @override
  Widget build(BuildContext context) {
    final foodProvider = Provider.of<FoodProvider>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: AppBar(
          backgroundColor: Color(0xFFFBFBFB),
          /*backgroundColor: _scrollController.hasClients && _scrollController.offset > 3
                ? Color(0xFFE0E0E0) // 스크롤 시 색상 변경
                : Color(0xFFFBFBFB),*/ // 기본색
          title: Text('음식 선호도', style: TextStyle(color: Color(0xFF2F2F2F))),
          centerTitle: true,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Color(0xFFFBFBFB), // 배경색 설정
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '선호하는 음식을 선택해 주세요',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              '푸렌즈가 선호에 맞는 음식을 추천해 드려요!',
              style: TextStyle(fontSize: 12, color: Color(0xFF2F2F2F)),
            ),
            const SizedBox(height: 50),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1,
                children: foodItems.map((item) {
                  final name = item['name']!;
                  final image = item['image']!;
                  final isSelected = foodProvider.selectedFoods.contains(name);

                  return GestureDetector(
                    onTap: () => foodProvider.toggleFood(name),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            image,
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          name,
                          style: TextStyle(
                            color: isSelected ? const Color(0xFFFF5833) : Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              //width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5833),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                ),
                child: const Text(
                  '완료',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFFBFBFB)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/