import 'package:flutter/material.dart';
import 'chatserve_screen.dart'; // ChatserveScreen을 import

class ChatScreen extends StatefulWidget {
  final List<String> selectedFoods;
  final List<String> allergies;

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
  final List<String> menuItems = ['사진/동영상', '파일', '링크'];
  List<bool> chatBookmarks = [];

  void startNewChat() {
    setState(() {
      messages.clear(); // 메시지 초기화
      _isMessageVisible = true; // 첫 번째 메시지 다시 표시
    });
    _scrollToBottom();
  }

  // 메시지 전송 함수
  void sendMessage(String message) {
    setState(() {
      messages.add({'sender': 'user', 'message': message}); // 사용자 메시지 추가
      messages.add({'sender': 'bot', 'message': '응답: $message'}); // 모델 응답 (예시)
      // 사용자 메시지는 북마크 없음
      chatBookmarks.add(false);
      // 봇 메시지는 북마크 기본값 false로 추가
      chatBookmarks.add(false);
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
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
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
              ), //탭, 더블탭, 드레그 등 제스처감지
              // 오른쪽 드로어
              Align(
                alignment: Alignment.centerLeft,
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
                                icon:
                                    Icon(Icons.close, color: Color(0xFF2F2F2F)),
                                onPressed: () {
                                  Navigator.pop(context); // X 아이콘 클릭 시 드로어 닫기
                                },
                              ),
                              Spacer(),
                              IconButton(
                                icon: Icon(Icons.notifications,
                                    color: Color(0xFF2F2F2F)), // 새 채팅 아이콘
                                onPressed: () {
                                  //widget.onStartNewChat(); // 새 채팅 시작
                                  Navigator.pop(context); // 드로어 닫기
                                },
                              ),
                              SizedBox(width: 8.0),
                              IconButton(
                                icon: Icon(Icons.person,
                                    color: Color(0xFF2F2F2F)), // 새 채팅 아이콘
                                onPressed: () {
                                  //widget.onStartNewChat(); // 새 채팅 시작
                                  Navigator.pushNamed(context, '/mypage'); // 드로어 닫기
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        ...menuItems.map((item) {
                          return ListTile(
                            title: Text(item),
                            onTap: () {
                              Navigator.pop(context); // 메뉴 닫기
                            },
                          );
                        }).toList(),
                        //Divider(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0), // 앱바 높이를 동적으로 설정
        child: AppBar(
          backgroundColor: Color(0xFFFBFBFB),
          title: Text('푸렌즈', style: TextStyle(color: Color(0xFF2F2F2F))),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Color(0xFFFBFBFB), // 배경색 설정
            ),
            /*style: TextStyle(
              fontSize: 24, // 타이틀 크기 조정
              fontWeight: FontWeight.bold, // 타이틀 굵기 조정
            ),*/
          ),
          //automaticallyImplyLeading: false,//뒤로가기 버튼 없애기
          leading: IconButton(
            icon: Icon(Icons.account_circle, color: Color(0xFF2F2F2F)),
            onPressed: () {
              _showProfileMenu(context);
            },
          ),
          centerTitle: true, // 타이틀을 가운데 정렬
          elevation: 8.0, // 그림자 효과 추가
          actions: [
            Builder(
              builder: (context) => Padding(
                padding: const EdgeInsets.all(8.0), // 원하는 패딩
                child: IconButton(
                  icon: Icon(Icons.menu, color: Color(0xFF2F2F2F)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      /*MaterialPageRoute(
                        builder: (context) => ChatserveScreen(),
                      ),*/
                      PageRouteBuilder(
                        opaque: false, // 배경을 투명하게 설정
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            ChatserveScreen(
                                onStartNewChat:
                                    startNewChat), // ChatserveScreen 호출
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          // 첫 번째 메시지 표시 (활성화되면 사라지도록)
          if (_isMessageVisible)
            Padding(
              padding: const EdgeInsets.all(24), // 여백을 설정
              child: Align(
                alignment: Alignment.centerLeft, // 왼쪽 정렬
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '오늘 뭐 먹을지, 고민일 때\n',
                        style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFF2F2F2F)), // 첫 번째 부분 색상 설정
                      ),
                      TextSpan(
                        text: '내 옆의 푸렌즈',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2F2F2F)), // 두 번째 부분 색상 설정
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Expanded(
            /*child: Scrollbar(  // Scrollbar는 ListView.builder를 감쌀 때만 사용
                controller: _scrollController,*/ // ScrollController를 Scrollbar에 추가
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
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 24),
                    decoration: BoxDecoration(
                      color: messages[index]['sender'] == 'user'
                          ? Color(0xFFFF5833) // 사용자 메시지 색상
                          : Color(0xFF9F9F9F), // 봇 메시지 색상
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ConstrainedBox( // 아이콘 오버레이를 위한 최소 크기 확보
                      constraints: BoxConstraints(minWidth: 30),
                      child: Stack(
                          children: [
                            // 메시지 텍스트
                            Padding(
                              padding: messages[index]['sender'] == 'user'
                                  ? const EdgeInsets.all(10)
                                  : const EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 40),
                              // 북마크 아이콘 공간 확보
                              child: Text(
                                messages[index]['message']!,
                                style: TextStyle(color: Color(0xFFFBFBFB)),
                              ),
                            ),
                            if (messages[index]['sender'] !=
                                'user') // 봇 메시지에만 북마크 아이콘
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  //padding: EdgeInsets.zero,
                                  //constraints: BoxConstraints(),
                                  /*icon: Icon(
                            chatBookmarks[index] ? Icons.bookmark : Icons.bookmark_border,
                            color: chatBookmarks[index]
                                ? const Color(0xFFFF5833)
                                : const Color(0xFFE0E0E0),
                          ),
                          onPressed: () {
                            setState(() {
                              chatBookmarks[index] = !chatBookmarks[index];
                            });
                          },*/
                                  icon: Icon(
                                    (index < chatBookmarks.length &&
                                        chatBookmarks[index])
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                    //size: 20,
                                    color: chatBookmarks[index]
                                        ? const Color(0xFFFF5833)
                                        : const Color(0xFFE0E0E0),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (index < chatBookmarks.length) {
                                        chatBookmarks[index] =
                                        !chatBookmarks[index];
                                      }
                                    });
                                  },
                                ),
                              ),
                          ]
                      ),
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
                      focusColor: Colors.transparent, // 포커스 시 색상 변화 없애기
                      hoverColor: Colors.transparent,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.send, color: Color(0xFF2F2F2F)),
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
