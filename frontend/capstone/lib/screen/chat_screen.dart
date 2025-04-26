import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
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
  bool _showNoDataMessage = false;
  String imageUrl = '';
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  List<Map<String, String>> messages = [];
  Set<String> bookmarkedRecipes = {};
  Map<String, List<String>> groupedRecipes = {};

  @override
  void initState() {
    super.initState();
    _fetchChatHistory();
    _loadBookmarkedRecipes();
  }

  Future<void> _loadBookmarkedRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final rawJson = prefs.getString('grouped_recipes') ?? '{}';
    final Map<String, dynamic> decoded = json.decode(rawJson);
    final Map<String, List<String>> grouped = decoded.map((key, value) => MapEntry(key, List<String>.from(value)));

    setState(() {
      groupedRecipes = grouped;
      bookmarkedRecipes = grouped.values.expand((list) => list).toSet();
      
      for (var recipes in grouped.values){
        for (var recipe in recipes){
          messages.add({'sender': 'bot', 'message': recipe});
        }
      }
    });
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  String extractMainDishAuto(String message) {
    final trimmed = message.replaceAll('\n', ' ').replaceFirst('푸렌즈가', '').trim();
    final regex = RegExp(r'([가-힣]+?)(?:을|를)?\s*(?:레시피|알려|추천|소개|만들)');
    final match = regex.firstMatch(trimmed);
    if (match != null && match.group(1)!.length > 1) return match.group(1)!;

    final fallback = RegExp(r'([가-힣]+?)(?:을|를)?\s*레시피');
    final fbMatch = fallback.firstMatch(trimmed);
    if (fbMatch != null && fbMatch.group(1)!.length > 1) return fbMatch.group(1)!;

    return '기타';
  }

  bool isRecipe(String message) {
    return message.contains('레시피') || message.contains('만드는 법') ||
        (message.contains('재료') && message.contains('조리'));
  }

  Future<void> addToRecentRecipes(String text) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('recent_recipes') ?? [];
    if (!list.contains(text)) {
      list.add(text);
      await prefs.setStringList('recent_recipes', list);
    }
  }

  Future<void> toggleRecipeBookmark(String recipeText) async {
    final prefs = await SharedPreferences.getInstance();
    final mainDish = extractMainDishAuto(recipeText);
    final existingList = groupedRecipes[mainDish] ?? [];

    if (existingList.contains(recipeText)) {
      existingList.remove(recipeText);
      bookmarkedRecipes.remove(recipeText);
      if (existingList.isEmpty) {
        groupedRecipes.remove(mainDish);
      } else {
        groupedRecipes[mainDish] = existingList;
      }
    } else {
      existingList.add(recipeText);
      bookmarkedRecipes.add(recipeText);
      groupedRecipes[mainDish] = existingList;
    }

    await prefs.setString('grouped_recipes', json.encode(groupedRecipes));
    if (mounted){
    setState(() {});
  }
}

  Future<void> _fetchChatHistory({String? date}) async {
    final uri = date != null
        ? Uri.parse('http://127.0.0.1:8000/api/chat/history/?date=$date')
        : Uri.parse('http://127.0.0.1:8000/api/chat/history/');

    try {
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token ${widget.userToken}',
        },
      );

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final data = json.decode(decodedBody) as List;
        setState(() {
          messages = data.map<Map<String, String>>((item) {
            final message = item['message'];
            if (item['sender'] == 'bot' && isRecipe(message!)){
              bookmarkedRecipes.add(message);
            }
            return {
              'sender': item['sender'],
              'message': item['message'],
            };
          }).toList();
          _showNoDataMessage = messages.isEmpty;
        });

        if (_showNoDataMessage) {
          Future.delayed(Duration(seconds: 2), () {
            if (mounted) setState(() => _showNoDataMessage = false);
          });
        }

        _scrollToBottom();
      } else {
        print("채팅 내역 불러오기 실패: ${response.body}");
      }
    } catch (e) {
      print("에러 발생: $e");
    }
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
        final decodedBody = utf8.decode(response.bodyBytes);
        final data = jsonDecode(decodedBody);
        setState(() {
          messages.add({'sender': 'bot', 'message': data['response']});
          imageUrl = data['recipe_image_url'] ?? '';
        });
      } else {
        setState(() {
          messages.add({'sender': 'bot', 'message': '오류: ${response.statusCode}'});
        });
      }
    } catch (e) {
      setState(() {
        messages.add({'sender': 'bot', 'message': '에러 발생: $e'});
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

  void _showDrawerWithDateFilter(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, _, __) {
          return ChatserveScreen(
            onStartNewChat: startNewChat,
            onDateSelected: (selectedDate) {
              final formatted = selectedDate.toIso8601String().split("T")[0];
              _fetchChatHistory(date: formatted);
            },
          );
        },
      ),
    );
  }

  void _showLeftDrawer(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, _) {
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
                        ListTile(title: Text('사진/동영상'), onTap: () => Navigator.pop(context)),
                        ListTile(title: Text('파일'), onTap: () => Navigator.pop(context)),
                        ListTile(title: Text('링크'), onTap: () => Navigator.pop(context)),
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
      appBar: AppBar(
        backgroundColor: Color(0xFFFBFBFB),
        title: Text('푸렌즈', style: TextStyle(color: Color(0xFF2F2F2F))),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.account_circle, color: Color(0xFF2F2F2F)),
          onPressed: () => _showLeftDrawer(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: Color(0xFF2F2F2F)),
            onPressed: () => _showDrawerWithDateFilter(context),
          ),
        ],
        flexibleSpace: Container(decoration: BoxDecoration(color: Color(0XFFFBFBFB))),
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(statusBarColor: Color(0xFFFBFBFB)),
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
                        style: TextStyle(fontSize: 20, color: Color(0xFF2F2F2F)),
                      ),
                      TextSpan(
                        text: '내 옆의 푸렌즈',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2F2F2F),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (_showNoDataMessage)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Center(
                child: Text("대화기록이 없어요!", style: TextStyle(fontSize: 16, color: Colors.grey)),
              ),
            ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final isUser = messages[index]['sender'] == 'user';
                final text = messages[index]['message']!;
                final recipe = isRecipe(text);

                if (!isUser && recipe) addToRecentRecipes(text);

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 24),
                        decoration: BoxDecoration(
                          color: isUser ? Color(0xFFFF5833) : Color(0xFF9F9F9F),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(text, style: TextStyle(color: Colors.white)),
                      ),
                      if (!isUser && recipe)
                        Positioned(
                          bottom: 4,
                          right: 16,
                          child: IconButton(
                            icon: Icon(
                              bookmarkedRecipes.contains(text)
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              color: bookmarkedRecipes.contains(text)
                                  ? Color(0xFFFF5833)
                                  : Colors.white,
                            ),
                            onPressed: () => toggleRecipeBookmark(text),
                          ),
                        ),
                    ],
                  ),
                );
              },
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
