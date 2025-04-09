import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'chatserve_screen.dart';

class ChatScreen extends StatefulWidget {
  final List<String> selectedFoods;
  final List<String> allergies;
  final String userToken;

  ChatScreen({
    this.selectedFoods = const [],
    this.allergies = const [],
    required this.userToken,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isMessageVisible = true;
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  List<Map<String, String>> messages = [];
  String imageUrl = '';
  bool isExpanded = false;

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  Future<void> sendMessage(String message) async {
    setState(() {
      messages.add({'sender': 'user', 'message': message});
    });

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/chat/'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token ${widget.userToken}',
        },
        body: jsonEncode({'message': message}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          messages.add({'sender': 'bot', 'message': data['response']});
          imageUrl = data['recipe_image_url'] ?? '';
        });
      } else {
        setState(() {
          messages.add({'sender': 'bot', 'message': 'Error: ${response.statusCode}'});
          imageUrl = '';
        });
      }
    } catch (e) {
      setState(() {
        messages.add({'sender': 'bot', 'message': 'Error: $e'});
        imageUrl = '';
      });
    }

    _controller.clear();
    _scrollToBottom();
  }

  void startNewChat() {
    setState(() {
      messages.clear();
      imageUrl = '';
      _isMessageVisible = true;
    });
    _scrollToBottom();
  }

  void _showLeftDrawer(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) {
          return Stack(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(color: Colors.black.withOpacity(0.5)),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Material(
                  color: Color(0xFFFBFBFB),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Column(
                      children: [
                        SizedBox(height: 40),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                        ListTile(
                          title: Text('사진/동영상'),
                          onTap: () => Navigator.pop(context),
                        ),
                        ListTile(
                          title: Text('파일'),
                          onTap: () => Navigator.pop(context),
                        ),
                        ListTile(
                          title: Text('링크'),
                          onTap: () => Navigator.pop(context),
                        ),
                        ListTile(
                          title: Text('마이페이지'),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/mypage');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isExpanded ? 250 : 105),
        child: AppBar(
          backgroundColor: Color(0xFFFBFBFB),
          title: Text('푸렌즈', style: TextStyle(color: Color(0xFF2F2F2F))),
          centerTitle: true,
          elevation: 8.0,
          leading: IconButton(
            icon: Icon(Icons.account_circle, color: Color(0xFF2F2F2F)),
            onPressed: () => _showLeftDrawer(context),
          ),
          actions: [
            Builder(
              builder: (context) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: Icon(Icons.menu, color: Color(0xFF2F2F2F)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            ChatserveScreen(onStartNewChat: startNewChat),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
          flexibleSpace: Container(
            decoration: BoxDecoration(color: Color(0xFFFBFBFB)),
            child: Column(
              children: [
                Visibility(
                  visible: !isExpanded,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: IconButton(
                      icon: Icon(Icons.arrow_drop_down, size: 30, color: Color(0xFF2F2F2F)),
                      onPressed: () => setState(() => isExpanded = true),
                    ),
                  ),
                ),
                if (isExpanded)
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                        child: Wrap(
                          spacing: 10.0,
                          runSpacing: 10.0,
                          alignment: WrapAlignment.center,
                          children: [
                            ...widget.selectedFoods.map((food) => Chip(
                                  label: Text(food),
                                  backgroundColor: Color(0xFFFF5833),
                                  labelStyle: TextStyle(color: Colors.white),
                                )),
                            ...widget.allergies.map((allergy) => Chip(
                                  label: Text(allergy),
                                  backgroundColor: Color(0xFFFF5833),
                                  labelStyle: TextStyle(color: Colors.white),
                                )),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_drop_up, size: 30, color: Color(0xFF2F2F2F)),
                        onPressed: () => setState(() => isExpanded = false),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          if (_isMessageVisible)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: '오늘 뭐 먹을지, 고민일 때\n',
                          style: TextStyle(fontSize: 20, color: Color(0xFF2F2F2F))),
                      TextSpan(
                          text: '내 옆의 푸렌즈',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2F2F2F))),
                    ],
                  ),
                ),
              ),
            ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) => Align(
                alignment: messages[index]['sender'] == 'user'
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 24),
                  decoration: BoxDecoration(
                    color: messages[index]['sender'] == 'user'
                        ? Color(0xFFFF5833)
                        : Color(0xFF9F9F9F),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(messages[index]['message']!,
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ),
          if (imageUrl.isNotEmpty)
            Padding(
              padding: EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(imageUrl),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: '메시지를 입력하세요...',
                      hintStyle: TextStyle(color: Color(0xFFE0E0E0)),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Color(0xFFFBFBFB),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.send, color: Color(0xFF2F2F2F)),
                        onPressed: () {
                          if (_controller.text.isNotEmpty) {
                            sendMessage(_controller.text);
                            setState(() => _isMessageVisible = false);
                          }
                        },
                      ),
                    ),
                    onSubmitted: (text) {
                      if (text.isNotEmpty) {
                        sendMessage(text);
                        setState(() => _isMessageVisible = false);
                      }
                    },
                    onTap: () => setState(() => _isMessageVisible = false),
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
