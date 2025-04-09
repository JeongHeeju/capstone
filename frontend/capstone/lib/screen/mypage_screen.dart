import 'package:flutter/material.dart';

class MypageScreen extends StatefulWidget {
  const MypageScreen({Key? key}) : super(key: key);

  @override
  State<MypageScreen> createState() => _MypageScreenState();
}

class _MypageScreenState extends State<MypageScreen> {
  int selectedTab = 0;

  //최근 본 레시피 리스트 추가
  final recentRecipes = [
    'assets/bulgogi.png',
    'assets/tteokbokki.png',
    'assets/cake.png',
  ];

  //저장한 레시피 리스트 추가
  final savedRecipes = [
    'assets/sushi.png',
    'assets/cake.png',
  ];

  // 북마크 상태를 리스트로 관리 (false: 해제, true: 저장됨)
  late List<bool> recentBookmarks;
  late List<bool> savedBookmarks;

  @override
  void initState() {
    super.initState();
    recentBookmarks = List<bool>.filled(recentRecipes.length, false); //북마크 다 해제여서 false
    savedBookmarks = List<bool>.filled(savedRecipes.length, true); //북마크 다 선택이여서 true
  }

  @override
  Widget build(BuildContext context) {
    final currentList = selectedTab == 0 ? recentRecipes : savedRecipes;
    final currentBookmarks = selectedTab == 0 ? recentBookmarks : savedBookmarks;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: AppBar(
          backgroundColor: const Color(0xFFFBFBFB),
          title: const Text('마이페이지', style: TextStyle(color: Color(0xFF2F2F2F))),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Color(0xFFFBFBFB), // 배경색 설정
            ),
            /*style: TextStyle(
              fontSize: 24, // 타이틀 크기 조정
              fontWeight: FontWeight.bold, // 타이틀 굵기 조정
            ),*/
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(Icons.settings, color: Color(0xFF2F2F2F)),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        insetPadding: const EdgeInsets.only(top: 60, right: 16),
                        alignment: Alignment.topRight,
                        /*shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),*/
                        child: Container(
                          width: 100,
                          //padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF2F2F2F).withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFFFBFBFB),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                  alignment: Alignment.centerLeft,
                                  foregroundColor: Color(0xFF2F2F2F),
                                  shape: RoundedRectangleBorder( // ← 이게 핵심!
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                                child: const Text('회원정보'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                  alignment: Alignment.centerLeft,
                                  foregroundColor: Color(0xFF2F2F2F),
                                  shape: RoundedRectangleBorder( // ← 이게 핵심!
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                                child: const Text('공지사항'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                  alignment: Alignment.centerLeft,
                                  foregroundColor: Color(0xFF2F2F2F),
                                  shape: RoundedRectangleBorder( // ← 이게 핵심!
                                    borderRadius: BorderRadius.zero,
                                  ),
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
            ),
          ],
        ),
      ),

      // 프로필
      body : Column(
        children: [
          const SizedBox(height: 16),
          const Icon(Icons.account_circle, size: 50),
          const SizedBox(height: 8),
          const Text('USER', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), //회원가입할 때 설정한 사용자이름
          const SizedBox(height: 20),
          /*const SizedBox(height: 20),
            const Icon(Icons.account_circle, size: 80),
            const SizedBox(height: 8),
            const Text('USER', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            const SizedBox(height: 24),*/

          // 탭 메뉴
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => setState(() => selectedTab = 0),
                child: Column(
                  children: [
                    Icon(Icons.history, color: selectedTab == 0 ? Color(0xFFFF5833) : Color(0xFFE0E0E0)),
                    SizedBox(height: 5),
                    Text(
                      '최근 본 레시피',
                      style: TextStyle(
                        color: selectedTab == 0 ? Color(0xFFFF5833) : Color(0xFFE0E0E0),
                        fontSize: 16,
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
                    Icon(Icons.bookmark, color: selectedTab == 1 ? Color(0xFFFF5833) : Color(0xFFE0E0E0)),
                    SizedBox(height: 5),
                    Text(
                      '저장한 레시피',
                      style: TextStyle(
                        color: selectedTab == 1 ? Color(0xFFFF5833) : Color(0xFFE0E0E0),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 레시피 리스트 (GridView)
          Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: currentList.length, // 선택된 리스트 사용
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
                          currentList[index], // 선택된 리스트 사용
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
                                ? Color(0xFFFF5833)   // 선택됨: 오렌지
                                : Color(0xFFE0E0E0),  // 선택 안됨: 회색
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
