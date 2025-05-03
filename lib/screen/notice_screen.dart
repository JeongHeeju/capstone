import 'package:flutter/material.dart';

class NoticeScreen extends StatelessWidget {
  const NoticeScreen({super.key});

  final List<Map<String, String>> notices = const [
    {'title': '근로자의 날 고객센터 운영안내', 'date': '2025. 04. 24.'},
    {'title': '4/18 서비스 일시 중단 안내', 'date': '2025. 04. 12.'},
    {'title': '개인정보 처리방침 변경 안내', 'date': '2025. 03. 26.'},
    {'title': '3/20 서비스 일시 중단 안내', 'date': '2025. 03. 15.'},
    {'title': '고객센터 답변 지연 안내', 'date': '2025. 02. 24.'},
    {'title': '2/17 서비스 정기 점검 안내', 'date': '2025. 02. 11.'},
    {'title': '설 연휴 고객센터 운영 안내', 'date': '2025. 01. 22.'},
    {'title': '이용약관 개정 안내', 'date': '2025. 12. 3.'},
    {'title': '개인정보 처리방침 개정 안내', 'date': '2025. 11. 29.'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: AppBar(
          backgroundColor: Color(0xFFFBFBFB),
          title: const Text('공지사항', style: TextStyle(color: Color(0xFF2F2F2F))),
          centerTitle: true,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Color(0xFFFBFBFB), // 배경색 설정
            ),
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: notices.length,
        separatorBuilder: (_, __) => const Align(
          alignment: Alignment.center,
          child: FractionallySizedBox(
            widthFactor: 1.12, // 1보다 크면 padding을 뚫고 나옴 (16px 기준 약 1.12)
            child: Divider(
              color: Color(0xFFE0E0E0), // 원하는 색
            ),
          ),
        ),
        itemBuilder: (context, index) {
          final notice = notices[index];
          return ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              notice['title'] ?? '',
              style: const TextStyle(color: Color(0xFF2F2F2F)),
            ),
            subtitle: Text(
              notice['date'] ?? '',
              style: const TextStyle(color: Color(0xFFE0E0E0)),
            ),
            onTap: () {
              // TODO: 상세보기 연결
            },
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            tileColor: Colors.transparent,
          );
        },
      ),
    );
  }
}
