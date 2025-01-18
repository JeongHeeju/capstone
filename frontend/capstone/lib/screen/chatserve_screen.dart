import 'package:flutter/material.dart';

class ChatserveScreen extends StatelessWidget {
  final List<String> menuItems = ['사진/동영상', '파일', '링크'];
  final List<String> sideMenuItems = [
    '오늘',
    '3일 전',
    '5일 전',
    '7일 전',
    '한 달 전',
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);  // Drawer 닫기
      },
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.5), // 반투명 배경
        body: Center(
          child: Material(
            color: Colors.white, // Drawer 배경 색상
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8, // Drawer 크기
              height: double.infinity,
              child: Column(
                children: [
                  // Drawer의 상단 메뉴
                  DrawerHeader(
                    decoration: BoxDecoration(color: Colors.blue),
                    child: Text(
                      "메뉴",
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                  // 왼쪽 메뉴 아이템들 (사진, 파일, 링크 등)
                  ...menuItems.map((item) {
                    return ListTile(
                      title: Text(item),
                      onTap: () {
                        Navigator.pop(context); // 메뉴 닫기
                        // 선택된 항목에 대한 동작을 이곳에 구현
                      },
                    );
                  }).toList(),
                  Divider(),
                  // 오른쪽 메뉴 아이템들 (프로필, 일정 등)
                  ListTile(
                    title: Text("프로필"),
                    onTap: () {
                      Navigator.pop(context); // 메뉴 닫기
                      _showProfileMenu(context); // 오른쪽 메뉴 (프로필) 표시
                    },
                  ),
                  Divider(),
                  ...sideMenuItems.map((item) {
                    return ListTile(
                      title: Text(item),
                      onTap: () {
                        Navigator.pop(context); // 메뉴 닫기
                      },
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 오른쪽 상단 아이콘을 클릭 시 프로필 메뉴가 나타나도록 하는 함수
  void _showProfileMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("프로필 메뉴"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: sideMenuItems.map((item) {
              return Text(item);
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("닫기"),
            ),
          ],
        );
      },
    );
  }
}