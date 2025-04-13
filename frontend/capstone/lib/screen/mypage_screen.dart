import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'information_screen.dart';

class MypageScreen extends StatefulWidget {
  const MypageScreen({Key? key}) : super(key: key);

  @override
  State<MypageScreen> createState() => _MypageScreenState();
}

class _MypageScreenState extends State<MypageScreen> {
  int selectedTab = 0;

  final recentRecipes = [
    'assets/bulgogi.png',
    'assets/tteokbokki.png',
    'assets/cake.png',
  ];

  final savedRecipes = [
    'assets/sushi.png',
    'assets/cake.png',
  ];

  late List<bool> recentBookmarks;
  late List<bool> savedBookmarks;

  @override
  void initState() {
    super.initState();
    recentBookmarks = List<bool>.filled(recentRecipes.length, false);
    savedBookmarks = List<bool>.filled(savedRecipes.length, true);
  }

  @override
  Widget build(BuildContext context) {
    final currentList = selectedTab == 0 ? recentRecipes : savedRecipes;
    final currentBookmarks = selectedTab == 0 ? recentBookmarks : savedBookmarks;

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
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: currentList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        currentList[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: Icon(
                          currentBookmarks[index] ? Icons.bookmark : Icons.bookmark_border,
                          color: currentBookmarks[index]
                              ? const Color(0xFFFF5833)
                              : const Color(0xFFE0E0E0),
                        ),
                        onPressed: () {
                          setState(() {
                            currentBookmarks[index] = !currentBookmarks[index];
                          });
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
