import 'package:flutter/material.dart';
import 'chat_screen.dart';
import '../main.dart';

/*class HoverTextButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color textColor;// 텍스트 색상을 외부에서 설정할 수 있도록 추가

  HoverTextButton({
    required this.text,
    required this.onPressed,
    this.textColor = const Color(0xFFFF5833), // 기본 텍스트 색상은 오렌지
  });

  @override
  _HoverTextButtonState createState() => _HoverTextButtonState();
}

class _HoverTextButtonState extends State<HoverTextButton> {
  bool isHovered = false; // Hover 상태
  bool isPressed = false; // 클릭 상태

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true), // Hover 시작
      onExit: (_) => setState(() => isHovered = false), // Hover 종료
      child: GestureDetector(
        onTapDown: (_) => setState(() => isPressed = true), // 클릭 시작
        onTapUp: (_) => setState(() => isPressed = false), // 클릭 종료
        onTapCancel: () => setState(() => isPressed = false), // 클릭 취소
        child: TextButton(
          onPressed: widget.onPressed,
          style: TextButton.styleFrom(
            backgroundColor: isPressed
                ? Color(0xFFCECECE) // 클릭 시 배경색 변경
                : (isHovered ? Color(0xFFE0E0E0) : Colors.transparent),
            // Hover 시 배경색 변경
            //splashFactory: NoSplash.splashFactory, // 효과 제거
          ),
          child: InkWell(
            onTap: widget.onPressed, // 클릭 시 이벤트 실행
            splashColor: Color(0xFFE0E0E0), // 클릭 시 반응 색상
            highlightColor: Color(0xFFE0E0E0), // 클릭 시 효과 색상
            child: Text(
              widget.text,
              style: TextStyle(
                color: widget.textColor, // 외부에서 전달된 텍스트 색상 사용
              ),
            ),
          ),
        ),
      ),
    );
  }
}*/




  class StartScreen extends StatefulWidget {
    final List<String> selectedFoods;

    StartScreen({required this.selectedFoods});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  List<String> allergies = [];
  bool showResult = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '새로운 밥 친구를\n사귀어 봐요!',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold, // 예: 얇은 글꼴 (300)
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF5833),
                padding: EdgeInsets.symmetric(horizontal: 70, vertical: 20),
              ),
              child: Text(
                '로그인',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFFBFBFB)),
              ),
            ),
            SizedBox(height: 16),
            // HoverTextButton을 사용하여 색상 변화 적용
            HoverTextButton(
              text: '처음 오신 친구인가요? 회원가입',
              textColor: Color(0xFFFF5833),
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
            ),
            HoverTextButton(
              text: '아니요 다음에 할게요',
              textColor: Color(0xFF9F9F9F),
              onPressed: () {
                Navigator.push(context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      selectedFoods: widget.selectedFoods, // 전달
                      allergies: allergies, // 전달
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}