import 'package:flutter/material.dart';

class ServiceScreen extends StatelessWidget {
  const ServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> serviceItems = [
      '자주하는 질문',
      '1:1 문의하기',
      '나의 문의내역',
      '개인정보 처리방침',
      '이용약관',
    ];


    return Scaffold(
      appBar: AppBar(
        title: const Text('고객센터', style: TextStyle(color: Color(0xFF2F2F2F))),
        centerTitle: true,
        //elevation: 0,
      ),
      body: ListView.builder(
        itemCount: serviceItems.length,
        itemBuilder: (context, index) {
          final item = serviceItems[index];
          return ListTile(
            title: Text(item),
            onTap: () {
              // TODO: 각 항목별 상세 페이지로 이동
            },
          );
        },
      ),
    );
  }
}