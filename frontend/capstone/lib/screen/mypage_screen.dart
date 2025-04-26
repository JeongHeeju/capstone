import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'information_screen.dart';

class MypageScreen extends StatefulWidget {
  const MypageScreen({Key? key}) : super(key: key);

  @override
  State<MypageScreen> createState() => _MypageScreenState();
}

class _MypageScreenState extends State<MypageScreen> {
  int selectedTab = 0;
  Map<String, List<String>> groupedRecipes = {};
  List<String> recentRecipes = [];

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadRecipes(); // 마이페이지로 돌아올 때마다 최신 상태 반영
  }

  Future<void> _loadRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final groupedRaw = prefs.getString('grouped_recipes') ?? '{}';
    final recentRaw = prefs.getStringList('recent_recipes') ?? [];

    setState(() {
      groupedRecipes = (json.decode(groupedRaw) as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, List<String>.from(value)),
      );
      recentRecipes = List<String>.from(recentRaw.reversed);
    });
  }

  Future<void> _removeRecipe(String mainDish, String recipe) async {
    final prefs = await SharedPreferences.getInstance();
    final rawJson = prefs.getString('grouped_recipes') ?? '{}';
    final Map<String, dynamic> decoded = json.decode(rawJson);
    final Map<String, List<String>> grouped = decoded.map((key, value) => MapEntry(key, List<String>.from(value)));

    if (grouped[mainDish]?.contains(recipe) ?? false) {
      grouped[mainDish]?.remove(recipe);
      if (grouped[mainDish]?.isEmpty ?? false) grouped.remove(mainDish);

      await prefs.setString('grouped_recipes', json.encode(grouped));
      _loadRecipes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBFBFB),
        foregroundColor: const Color(0xFF2F2F2F),
        elevation: 0,
        centerTitle: true,
        title: const Text('마이페이지', style: TextStyle(color: Color(0xFF2F2F2F))),
        iconTheme: const IconThemeData(color: Color(0xFF2F2F2F)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: Color(0xFFFBFBFB)),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Color(0xFFFBFBFB),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Color(0xFF2F2F2F)),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    insetPadding: const EdgeInsets.only(top: 60, right: 16),
                    alignment: Alignment.topRight,
                    child: Container(
                      width: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF2F2F2F).withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFFFBFBFB),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const InformationScreen()),
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              alignment: Alignment.centerLeft,
                              foregroundColor: const Color(0xFF2F2F2F),
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                            ),
                            child: const Text('회원정보'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              alignment: Alignment.centerLeft,
                              foregroundColor: const Color(0xFF2F2F2F),
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                            ),
                            child: const Text('공지사항'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              alignment: Alignment.centerLeft,
                              foregroundColor: const Color(0xFF2F2F2F),
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                            ),
                            child: const Text('고객센터'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          const Icon(Icons.account_circle, size: 50),
          const SizedBox(height: 8),
          const Text('USER', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => setState(() => selectedTab = 0),
                child: Column(
                  children: [
                    Icon(Icons.history,
                        color: selectedTab == 0 ? Color(0xFFFF5833) : Color(0xFFE0E0E0)),
                    const SizedBox(height: 5),
                    Text(
                      '최근 본 레시피',
                      style: TextStyle(
                        color: selectedTab == 0 ? Color(0xFFFF5833) : Color(0xFFE0E0E0),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 100),
              GestureDetector(
                onTap: () => setState(() => selectedTab = 1),
                child: Column(
                  children: [
                    Icon(Icons.bookmark,
                        color: selectedTab == 1 ? Color(0xFFFF5833) : Color(0xFFE0E0E0)),
                    const SizedBox(height: 5),
                    Text(
                      '저장한 레시피',
                      style: TextStyle(
                        color: selectedTab == 1 ? Color(0xFFFF5833) : Color(0xFFE0E0E0),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: selectedTab == 0
                ? ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: recentRecipes.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(recentRecipes[index]),
                        ),
                      );
                    },
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: groupedRecipes.entries.map((entry) {
                      return ExpansionTile(
                        title: Text(entry.key, style: TextStyle(fontWeight: FontWeight.bold)),
                        children: entry.value.map((recipe) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)],
                            ),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 40),
                                    child: Text(recipe),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: IconButton(
                                    icon: Icon(Icons.delete, color: Colors.grey),
                                    onPressed: () => _removeRecipe(entry.key, recipe),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
