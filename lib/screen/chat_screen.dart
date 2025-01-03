import 'package:flutter/material.dart';
import 'chatserve_screen.dart';  // ChatserveScreen을 import

class ChatScreen extends StatefulWidget {
  final List<String> selectedFoods;
  final List<String> allergies;

  /*@override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // AppBar 스타일 추가
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFFBFBFB), // AppBar 배경색
          foregroundColor: Color(0xFF2F2F2F), // 변경된 색상
          elevation: 0, // 그림자 제거
          ),
        ),
      );
    }*/

    @override
  ChatScreen({required this.selectedFoods, required this.allergies});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isMessageVisible = true;
  TextEditingController _controller = TextEditingController(); // 입력 텍스트 컨트롤러
  ScrollController _scrollController = ScrollController();
  List<Map<String, String>> messages = []; // 메시지 목록 (사용자 및 모델)
  bool isExpanded = false; // 음식과 알레르기 목록이 펼쳐졌는지 확인하는 변수

  /*@override
  void initState() {
    super.initState();
    // 처음에 화면을 아래로 자동 스크롤
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }*/

  // 메시지 전송 함수
  void sendMessage(String message) {
    setState(() {
      messages.add({'sender': 'user', 'message': message}); // 사용자 메시지 추가
      messages.add({'sender': 'bot', 'message': '응답: $message'}); // 모델 응답 (예시)
    });
    _controller.clear(); // 입력 필드 초기화
    _scrollToBottom();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    // ListView의 마지막으로 자동 스크롤
    Future.delayed(Duration(milliseconds: 100), () {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
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
            children: [
              Text("오늘"),
              Text("3일 전"),
              Text("5일 전"),
              Text("7일 전"),
              Text("한 달 전"),
            ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isExpanded ? 250 : 105), // 앱바 높이를 동적으로 설정
        child: AppBar(
          backgroundColor: Color(0xFFFBFBFB),
          title: Text(
            '푸렌즈',
            /*style: TextStyle(
              fontSize: 24, // 타이틀 크기 조정
              fontWeight: FontWeight.bold, // 타이틀 굵기 조정
            ),*/
          ),
          centerTitle: true, // 타이틀을 가운데 정렬
          elevation: 8.0, // 그림자 효과 추가
          actions: [
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                _showProfileMenu(context);
              },
            ),
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatserveScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Color(0xFFFBFBFB), // 배경색 설정
            ),
            child: Column(
              children: [
                Visibility(
                  visible: !isExpanded,  // isExpanded가 false일 때만 아래 화살표(▼) 보이게 설정
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_drop_down, // 아래 화살표(▼)
                        size: 30,
                        color: Color(0xFF2F2F2F),
                      ),
                      onPressed: () {
                        setState(() {
                          isExpanded = true; // 아래 화살표 클릭 시 앱바 확장
                        });
                      },
                    ),
                  ),
                ),
                if (isExpanded) ...[
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 70.0, left: 20.0, right: 20.0),
                        child: Wrap(
                          spacing: 10.0,
                          runSpacing: 10.0,
                          alignment: WrapAlignment.center,
                          children: [
                            ...widget.selectedFoods.map((food) {
                              return Container(
                                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFF5833),
                                  borderRadius: BorderRadius.circular(50.0),
                                  //border: Border.all(color: Color(0xFF9F9F9F), width: 1),
                                  /*boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 0,
                                      blurRadius: 0,
                                    ),
                                  ],*/
                                ),
                                child: Text(
                                  food,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFBFBFB),
                                  ),
                                ),
                              );
                            }).toList(),
                            ...widget.allergies.map((allergy) {
                              return Container(
                                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFF5833),
                                  borderRadius: BorderRadius.circular(50.0),
                                  /*border: Border.all(color: Color(0xFF9F9F9F), width: 1),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 0,
                                      blurRadius: 0,
                                    ),
                                  ],*/
                                ),
                                child: Text(
                                  allergy,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFBFBFB),
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_drop_up, // 위쪽 화살표(▲)
                            size: 30,
                            color: Color(0xFF2F2F2F),
                          ),
                          onPressed: () {
                            setState(() {
                              isExpanded = false; // 위쪽 화살표 클릭 시 앱바를 원래 크기로 축소
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
          /*body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // 채팅 UI (채팅 메시지 영역)
                    Expanded(
                      child: ListView.builder(
                        reverse: true, // 최신 메시지가 맨 아래에 표시되도록 설정
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          return Align(
                            alignment: messages[index]['sender'] == 'user'
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: messages[index]['sender'] == 'user'
                                    ? Color(0xFFFF5833) // 사용자 메시지 색상
                                    : Color(0xFF9F9F9F), // 봇 메시지 색상
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                messages[index]['message']!,
                                style: TextStyle(color: Color(0xFFFBFBFB)),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // 입력창과 전송 버튼
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                hintText: '메시지를 입력하세요...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                filled: true,
                                fillColor: Color(0xFFE0E0E0),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () {
                              if (_controller.text.isNotEmpty) {
                                sendMessage(_controller.text); // 메시지 전송
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),*/
      body: Column(
        children: [
            // 첫 번째 메시지 표시 (활성화되면 사라지도록)
            if (_isMessageVisible)
              Padding(
                padding: const EdgeInsets.all(24),// 여백을 설정
                child :Align(
                 alignment: Alignment.centerLeft, // 왼쪽 정렬
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '오늘 뭐 먹을지, 고민일 때\n',
                          style: TextStyle(fontSize: 20, color: Color(0xFF2F2F2F)), // 첫 번째 부분 색상 설정
                        ),
                        TextSpan(
                          text: '내 옆의 푸렌즈',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2F2F2F)), // 두 번째 부분 색상 설정
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            Expanded(
                /*child: Scrollbar(  // Scrollbar는 ListView.builder를 감쌀 때만 사용
                controller: _scrollController,*/  // ScrollController를 Scrollbar에 추가
                child: ListView.builder(
                  controller: _scrollController, // ScrollController 추가
                  reverse: false,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return Align(
                      alignment: messages[index]['sender'] == 'user'
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 24),
                        decoration: BoxDecoration(
                          color: messages[index]['sender'] == 'user'
                              ? Color(0xFFFF5833) // 사용자 메시지 색상
                              : Color(0xFF9F9F9F), // 봇 메시지 색상
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          messages[index]['message']!,
                          style: TextStyle(color: Color(0xFFFBFBFB)),
                        ),
                      ),
                    );
                  },
                ),
                ),
              // 입력창과 전송 버튼
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  /*Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: '메시지를 입력하세요...',
                        hintStyle: TextStyle(color: Color(0xFFE0E0E0)),
                        border: OutlineInputBorder(
                          //borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Color(0xFFFBFBFB),
                      ),
                    ),
                  ),*/
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: '메시지를 입력하세요...',
                        hintStyle: TextStyle(color: Color(0xFFE0E0E0)),
                        border: OutlineInputBorder(
                          //borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Color(0xFFFBFBFB), // 기본 배경색 설정
                        focusColor: Colors.transparent,  // 포커스 시 색상 변화 없애기
                        hoverColor: Colors.transparent,
                        suffixIcon: IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () {
                            if (_controller.text.isNotEmpty) {
                              sendMessage(_controller.text); // 메시지 전송
                            }
                          },
                        ),
                      ),
                      onSubmitted: (text) {
                        if (text.isNotEmpty) {
                          sendMessage(text); // 엔터키로 메시지 전송
                        }
                      },
                      onTap: () {
                        setState(() {
                          _isMessageVisible = false; // 입력창을 클릭하면 기본 메시지 숨기기
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }
}