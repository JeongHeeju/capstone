import 'package:flutter/material.dart';

class ChatserveScreen extends StatefulWidget {
  final VoidCallback onStartNewChat;

  ChatserveScreen({required this.onStartNewChat});

  @override
  _ChatserveScreenState createState() => _ChatserveScreenState();
}

class _ChatserveScreenState extends State<ChatserveScreen> {
  final List<String> menuItems = ['사진/동영상', '파일', '링크'];
  final List<String> sideMenuItems = [
    '오늘',
    '3일 전',
    '5일 전',
    '7일 전',
    '한 달 전',
  ];

  /*void _showMonthPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('2025년 월 선택'),
          content: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: List.generate(12, (index) {
              final month = index + 1; // 1월 ~ 12월
              return GestureDetector(
                onTap: () {
                  print("선택된 날짜: 2025년 $month월");
                  Navigator.pop(context); // 다이얼로그 닫기
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    "$month월",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }*/



@override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 반투명한 배경
        GestureDetector(
          onTap: () {
            Navigator.pop(context); // 배경 클릭 시 드로어 닫기
          },
          child: Container(
            color: Color(0xFF2F2F2F).withOpacity(0.5), // 반투명 배경
          ),
        ),
        // 오른쪽 드로어
        Align(
          alignment: Alignment.centerRight,
          child: Material(
            color: Color(0xFFFBFBFB), // 드로어 배경 색상
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8, // 드로어 너비
              height: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 상단 X 아이콘과 새 채팅 아이콘
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.close, color: Color(0xFF2F2F2F)),
                          onPressed: () {
                            Navigator.pop(context); // X 아이콘 클릭 시 드로어 닫기
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.border_color, color: Color(0xFF2F2F2F)), // 새 채팅 아이콘
                          onPressed: () {
                            widget.onStartNewChat(); // 새 채팅 시작
                            Navigator.pop(context); // 드로어 닫기
                          },
                        ),
                      ],
                    ),
                  ),
                  // 검색창 추가
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      //padding: EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: Color(0xFFE0E0E0), // 검색창 배경 색상
                        borderRadius: BorderRadius.circular(50.0), // 둥근 테두리
                      ),
                      child: Row(
                        children: [
                        Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0), //왼쪽, 위, 오른쪽, 아래
                        child: Icon(Icons.search, color: Color(0xFF2F2F2F)),
                        ),// 돋보기 아이콘
                          //SizedBox(width: 8.0), // 간격
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: '검색어를 입력하세요', // 힌트 텍스트
                                hintStyle: TextStyle(color: Color(0xFF9F9F9F)), // 힌트 텍스트 스타일
                                border: InputBorder.none, // 외곽선 제거
                                enabledBorder: InputBorder.none, // 활성 상태 외곽선 제거
                                focusedBorder: InputBorder.none, // 포커스 상태 외곽선 제거
                              ),
                              cursorColor: Color(0xFF2F2F2F), // 커서 색상 설정
                              onChanged: (value) {
                                // 검색 동작 (필요 시 구현)
                                print('검색어 입력: $value');
                              },
                            ),
                          ),
                        /*Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.calendar_today, color: Color(0xFF2F2F2F)),
                        ),*//// 캘린더 아이콘
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                              icon: Icon(Icons.calendar_today, color: Color(0xFF2F2F2F)),
                              onPressed: () async {
                                DateTime? selectedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(), // 기본 날짜 (현재 날짜)
                                  firstDate: DateTime(2000),  // 선택 가능한 첫 번째 날짜
                                  lastDate: DateTime.now(),   // 선택 가능한 마지막 날짜 (오늘까지 제한)
                                    initialEntryMode: DatePickerEntryMode.calendarOnly, // 캘린더 모드로 강제 설정
                                  locale: const Locale('ko', 'KR'), // 한국어 설정
                                  builder: (BuildContext context, Widget? child) {
                                    if (child == null) return SizedBox.shrink(); // null 확인
                                    return Theme(
                                      data: ThemeData.light().copyWith(
                                        // 헤더 색상 (타이틀 배경)
                                        colorScheme: ColorScheme.light(
                                          primary: Color(0xFFFF5833), // 헤더 배경 및 강조 색상
                                          onPrimary: Color(0xFFFFFFFF), // 헤더 텍스트 색상
                                          surface: Color(0xFFFBFBFB), // 캘린더 배경색
                                          onSurface: Color(0xFF2F2F2F), // 캘린더 텍스트 색상
                                        ),
                                        textButtonTheme: TextButtonThemeData(
                                          style: TextButton.styleFrom(
                                            foregroundColor: Color(0xFF2F2F2F), // 버튼 텍스트 색상 (확인/취소 버튼)
                                          ),
                                        ),
                                        // 날짜 셀 스타일
                                        dialogBackgroundColor: Color(0xFFFBFBFB), // 다이얼로그 배경색
                                        textTheme: TextTheme(
                                          bodyLarge: TextStyle(color: Color(0xFF2F2F2F)), // 기본 텍스트 색상
                                          labelLarge: TextStyle(color: Color(0xFF2F2F2F)), // 날짜 텍스트 색상
                                        ),
                                        datePickerTheme: DatePickerThemeData(
                                          headerBackgroundColor: Color(0xFFFBFBFB), // 헤더 배경색
                                          headerForegroundColor: Color(0xFF2F2F2F), // 헤더 텍스트 색상
                                          backgroundColor: Color(0xFFFBFBFB), // 캘린더 배경색
                                          dayStyle: TextStyle(color: Color(0xFF2F2F2F)), // 날짜 텍스트 색상
                                        ),
                                      ),
                                      child: child,
                                    );
                                  },
                                );
                                if (selectedDate != null) {
                                  // 사용자가 날짜를 선택한 경우
                                  print("선택된 날짜: $selectedDate");
                                  // 선택된 날짜 처리 (추가 동작 가능)
                                } else {
                                  // 사용자가 캘린더를 닫은 경우
                                  print("날짜 선택 취소됨");
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 상단 메뉴
                 /*Text(
                      "메뉴",
                      style: TextStyle(color: Color(0xFF2F2F2F), fontSize: 24),
                  ),
                  // 왼쪽 메뉴 아이템들
                  ...menuItems.map((item) {
                    return ListTile(
                      title: Text(item),
                      onTap: () {
                        Navigator.pop(context); // 메뉴 닫기
                      },
                    );
                  }).toList(),
                  Divider(),
                  // 오른쪽 메뉴 아이템들
                  ListTile(
                    title: Text("프로필"),
                    onTap: () {
                      Navigator.pop(context); // 메뉴 닫기
                      _showProfileMenu(context); // 프로필 메뉴 표시
                    },
                  ),*/
                  SizedBox(height: 20),
                  //Divider(color: Color(0xFF9F9F9F)),
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
      ],
    );
  }

  // 오른쪽 상단 아이콘을 클릭 시 프로필 메뉴가 나타나도록 하는 함수
  /*void _showProfileMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("프로필 메뉴"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: menuItems.map((item) {
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
  }*/
}

