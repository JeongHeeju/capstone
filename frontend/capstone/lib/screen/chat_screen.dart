import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:linkify/linkify.dart';
import 'chatserve_screen.dart';


/// 채팅 항목 타입 구분용
enum ChatItemType { userText, botText, image, map }

/// 채팅 화면에서 렌더링할 각 항목 모델
class ChatItem {
  final ChatItemType type;
  final String content;
  ChatItem(this.type, this.content);
}

class ChatScreen extends StatefulWidget {
  final List<String> selectedFoods;
  final List<String> allergies;
  final String userToken;

  const ChatScreen({
    Key? key,
    this.selectedFoods = const [],
    this.allergies = const [],
    required this.userToken,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final WebViewController _mapController;

  bool _isMessageVisible = true;
  bool _showNoDataMessage = false;

  List<ChatItem> _items = [];
  Set<String> bookmarkedRecipes = {};
  Map<String, List<String>> groupedRecipes = {};

  @override
  void initState() {
    super.initState();
    // 지도용 WebView 컨트롤러 초기화
    _mapController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            final url = request.url;
            if (url.startsWith('kakaomap://')) {
              launchUrl(
                Uri.parse(url),
                mode: LaunchMode.externalApplication,
              );
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );
    _loadBookmarkedRecipes();
      _fetchChatHistory();
  }

  Future<void> openUrlWithChrome(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print("URL launch 실패: $url");
    }
  }

  List<TextSpan> _buildLinkifiedTextSpans(String text) {
    final elements = linkify(text, options: LinkifyOptions(humanize: false));
    return elements.map((element) {
      if (element is LinkableElement) {
        return TextSpan(
          text: element.text,
          style: TextStyle(color: Colors.yellowAccent),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              await openUrlWithChrome(element.url);
            },
        );
      } else {
        return TextSpan(text: element.text);
      }
    }).toList();
  }

  Future<void> _loadBookmarkedRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final rawJson = prefs.getString(_groupedKey) ?? '{}';
    final decoded = json.decode(rawJson) as Map<String, dynamic>;
    final loaded = decoded.map((k, v) => MapEntry(k, List<String>.from(v)));
    setState(() {
      groupedRecipes = loaded;
      bookmarkedRecipes = loaded.values.expand((e) => e).toSet();
    });
  }

  String get _groupedKey => 'grouped_recipes_${widget.userToken}';
  String get _recentKey => 'recent_recipes_${widget.userToken}';

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

String extractMainDishAuto(String message) {
  // 0) 먼저 "푸렌즈가 알려드릴게요!" 같은 접두부를 제거
  var body = message
    .replaceFirst(
      RegExp(r'^.*?알려드릴게요[!~]?\s*'), '')
    .replaceAll('\n', ' ')
    .trim();

  // 1) 맨 앞에 "X은" 또는 "X는" 이 있으면 X만 잡아낸다
  final intro = RegExp(r'^([\uAC00-\uD7A3][\uAC00-\uD7A3\s]+?)\s*(?:은|는)')
    .firstMatch(body);
  if (intro != null) {
    return intro.group(1)!.trim();
  }

  // 2) "X 레시피" 형태로 나오는 부분만 잡기 (불필요한 '있는' 같은 건 배제)
  final recipeMatch = RegExp(r'([\uAC00-\uD7A3]{2,}?)\s+레시피')
    .firstMatch(body);
  if (recipeMatch != null) {
    return recipeMatch.group(1)!;
  }

  // 3) 그 외엔 첫 두 글자 이상의 명사
  final fallback = RegExp(r'([\uAC00-\uD7A3]{2,})').firstMatch(body);
  if (fallback != null) {
    final candidate = fallback.group(1)!;
    const invalid = [
      '집','오늘','내일','우리','내','네','가족','엄마','아빠',
      '학교','친구','간단한','맛있는','쉬운','맛있게','쉽게',
      '간단하게','기본적인','있는'
    ];
    if (invalid.any((w) => candidate.startsWith(w))) {
      return '기타';
    }
    return candidate;
  }

  return '기타';
}


  bool isRecipe(String message) {
    return message.contains('레시피') ||
      message.contains('만드는 법') ||
      (message.contains('재료') && message.contains('조리'));
  }

  Future<void> addToRecentRecipes(String text) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_recentKey) ?? [];
    if (!list.contains(text)) {
      list.add(text);
      await prefs.setStringList(_recentKey, list);
    }
  }

  Future<void> toggleRecipeBookmark(String recipeText) async {
    final prefs = await SharedPreferences.getInstance();
    final mainDish = extractMainDishAuto(recipeText);
    final existing = groupedRecipes[mainDish] ?? [];
    setState(() {
      if (existing.contains(recipeText)) {
        existing.remove(recipeText);
        bookmarkedRecipes.remove(recipeText);
        if (existing.isEmpty) groupedRecipes.remove(mainDish);
        else groupedRecipes[mainDish] = existing;
      } else {
        existing.add(recipeText);
        bookmarkedRecipes.add(recipeText);
        groupedRecipes[mainDish] = existing;
      }
    });
    await prefs.setString(_groupedKey, json.encode(groupedRecipes));
  }

  Future<void> _fetchChatHistory({String? date}) async {
    final uri = date != null
      ? Uri.parse('http://10.0.2.2:8000/api/chat/history/?date=$date')
      : Uri.parse('http://10.0.2.2:8000/api/chat/history/');
    try {
      final res = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token ${widget.userToken}',
      });
      if (res.statusCode == 200) {
        final data = json.decode(utf8.decode(res.bodyBytes)) as List;
        setState(() {
          _items = data.map<ChatItem>((item) {
            final sender = item['sender'] as String;
            final type = item['type'] as String;
            switch (type) {
              case 'map':
                return ChatItem(ChatItemType.map, item['map_url'] as String);
              case 'image':
                return ChatItem(ChatItemType.image, item['image_url'] as String);
              case 'text':
              default:
                final msg = item['message'] as String;
                if (sender == 'bot' && isRecipe(msg)) {
                  bookmarkedRecipes.add(msg);
                }
                return ChatItem(
                  sender == 'user' ? ChatItemType.userText : ChatItemType.botText,
                  msg,
                );
            }
          }).toList();
          _showNoDataMessage = _items.isEmpty;
          _isMessageVisible = _items.isEmpty;
        });
        if (_showNoDataMessage) {
          Future.delayed(const Duration(seconds: 2), (){
            if (mounted) setState(() => _showNoDataMessage = false);
          });
        }
        _scrollToBottom();
      } else {
        print("채팅 내역 불러오기 실패: ${res.body}");
      }
    } catch (e) {
      print("에러 발생: $e");
    }
  }

  Future<void> sendMessage(String message) async {
    setState(() {
      _items.add(ChatItem(ChatItemType.userText, message));
      _isMessageVisible = false;
    });
    _controller.clear();
    _scrollToBottom();

    try {
      final res = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/chat/'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token ${widget.userToken}',
        },
        body: json.encode({'message': message}),
      );

      if (res.statusCode == 200) {
        final data = json.decode(utf8.decode(res.bodyBytes));
        final botText = data['response'] as String? ?? '';
        final rawImg = data['recipe_image_url'] as String?;
        final lat = data['map_lat'];
        final lng = data['map_lng'];


        // 봇 텍스트
        setState(() => _items.add(ChatItem(ChatItemType.botText, botText)));
        if (isRecipe(botText)) addToRecentRecipes(botText);

        // 이미지
        if (rawImg!=null && rawImg.isNotEmpty) {
          setState(() => _items.add(ChatItem(ChatItemType.image, rawImg)));
        }

        // 지도
        if (lat!=null && lng!=null) {
          final mapUrl = 'https://map.kakao.com/link/map/$lat,$lng';
          _mapController.loadRequest(Uri.parse(mapUrl));
          setState(() => _items.add(ChatItem(ChatItemType.map, mapUrl)));
        }
      } else {
        setState(() => _items.add(
          ChatItem(ChatItemType.botText, '오류: ${res.statusCode}')
        ));
      }
    } catch (e) {
      setState(() => _items.add(
        ChatItem(ChatItemType.botText, '에러 발생: $e')
      ));
    }

    _scrollToBottom();
  }

  void startNewChat() {
    setState(() {
      _items.clear();
      _isMessageVisible = true;
      _showNoDataMessage = false;
    });
    _scrollToBottom();
  }

  void _showDrawerWithDateFilter(BuildContext context) {
    Navigator.push(context, PageRouteBuilder(
      opaque: false,
      pageBuilder: (_, __, ___) => ChatserveScreen(
        onStartNewChat: startNewChat,
        onDateSelected: (date) => _fetchChatHistory(date: date.toIso8601String().split("T")[0]),
      ),
    ));
  }

  void _showLeftDrawer(BuildContext context) {
    Navigator.push(context, PageRouteBuilder(
      opaque: false,
      pageBuilder: (_, __, ___) => Stack(
        children: [
          GestureDetector(onTap: ()=>Navigator.pop(context), child: Container(color: Colors.black54)),
          Align(
            alignment: Alignment.centerLeft,
            child: Material(
              color: Color(0xFFFBFBFB),
              child: SizedBox(
                width: MediaQuery.of(context).size.width*0.8,
                child: Column(
                  children: [
                    SizedBox(height:40),
                    IconButton(icon: Icon(Icons.close), onPressed: ()=>Navigator.pop(context)),
                    ListTile(title: Text('사진/동영상'), onTap: ()=>Navigator.pop(context)),
                    ListTile(title: Text('파일'), onTap: ()=>Navigator.pop(context)),
                    ListTile(title: Text('링크'), onTap: ()=>Navigator.pop(context)),
                    ListTile(
                      title: Text('마이페이지'),
                      onTap: (){
                        Navigator.pop(context);
                        Navigator.pushNamed(context,'/mypage');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildItem(BuildContext context, int index) {
    final item = _items[index];
    switch (item.type) {
      case ChatItemType.userText:
        return Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(vertical:5,horizontal:24),
            decoration: BoxDecoration(
              color: Color(0xFFFF5833),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(item.content, style: TextStyle(color:Colors.white)),
          ),
        );
      case ChatItemType.botText:
        final isRec = isRecipe(item.content);
        return Align(
          alignment: Alignment.centerLeft,
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(vertical:5,horizontal:24),
                decoration: BoxDecoration(
                  color: Color(0xFF9F9F9F),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SelectableText.rich(
                  TextSpan(
                    children: _buildLinkifiedTextSpans(item.content),
                    style: TextStyle(color:Colors.white),
                  ),
                ),
              ),
              if (isRec)
                Positioned(
                  bottom:4,right:16,
                  child: IconButton(
                    icon: Icon(
                      bookmarkedRecipes.contains(item.content)
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                      color: bookmarkedRecipes.contains(item.content)
                        ? Color(0xFFFF5833)
                        : Colors.white,
                    ),
                    onPressed: ()=>toggleRecipeBookmark(item.content),
                  ),
                ),
            ],
          ),
        );
      case ChatItemType.image:
        return Padding(
          padding: EdgeInsets.symmetric(vertical:8,horizontal:24),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(item.content),
          ),
        );
      case ChatItemType.map:
  // 매번 새 WebViewController를 만들면서 navigationDelegate도 설정
      final mapController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onNavigationRequest: (NavigationRequest request) {
              final url = request.url;
              if (url.startsWith('kakaomap://')) {
            // kakaomap:// 스킴은 외부 앱으로 열기
                launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                return NavigationDecision.prevent;
              }
          // 일반 https 링크는 WebView 내에서 처리
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(item.content));

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        child: SizedBox(
          height: 300,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: WebViewWidget(controller: mapController),
          ),
        ),
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFBFBFB),
        title: Text('푸렌즈', style: TextStyle(color:Color(0xFF2F2F2F))),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.account_circle, color:Color(0xFF2F2F2F)),
          onPressed: ()=>_showLeftDrawer(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color:Color(0xFF2F2F2F)),
            onPressed: ()=>_showDrawerWithDateFilter(context),
          ),
        ],
        flexibleSpace: Container(decoration: BoxDecoration(color: Color(0xFFFBFBFB))),
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(statusBarColor: Color(0xFFFBFBFB)),
      ),
      body: Column(
        children: [
          if (_isMessageVisible)
            Padding(
              padding: EdgeInsets.all(24),
              child: Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text:'오늘 뭐 먹을지, 고민일 때\n', style: TextStyle(fontSize:20,color:Color(0xFF2F2F2F))),
                      TextSpan(text:'내 옆의 푸렌즈\n\n', style: TextStyle(fontSize:24,fontWeight:FontWeight.bold,color:Color(0xFF2F2F2F))),
                      TextSpan(text:"푸렌즈는 음식 고민 해결 전문가예요!\n'오늘 점심 메뉴 추천해줘'라고 말해보세요",
                        style: TextStyle(fontSize:17,color:Color(0xFF2F2F2F))),
                    ],
                  ),
                ),
              ),
            ),
          if (_showNoDataMessage)
            Padding(
              padding: EdgeInsets.only(bottom:10),
              child: Center(child: Text('대화기록이 없어요!', style: TextStyle(fontSize:16,color:Colors.grey))),
            ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _items.length,
              itemBuilder: _buildItem,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: '메시지를 입력하세요...',
                      hintStyle: TextStyle(color:Color(0xFFE0E0E0)),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Color(0xFFFBFBFB),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.send, color:Color(0xFF2F2F2F)),
                        onPressed: (){
                          final txt = _controller.text.trim();
                          if (txt.isNotEmpty) sendMessage(txt);
                        },
                      ),
                    ),
                    onSubmitted: (t){
                      final txt = t.trim();
                      if (txt.isNotEmpty) sendMessage(txt);
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


