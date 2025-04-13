import 'package:flutter/material.dart';

class ChatserveScreen extends StatefulWidget {
  final VoidCallback onStartNewChat;
  final Function(DateTime) onDateSelected;

  ChatserveScreen({required this.onStartNewChat, required this.onDateSelected});

  @override
  _ChatserveScreenState createState() => _ChatserveScreenState();
}

class _ChatserveScreenState extends State<ChatserveScreen> {
  final List<String> sideMenuItems = ['오늘', '3일 전', '5일 전', '7일 전', '한 달 전'];
  DateTime? selectedDate;

  DateTime _convertLabelToDate(String label) {
    final now = DateTime.now();
    switch (label) {
      case '오늘':
        return now;
      case '3일 전':
        return now.subtract(Duration(days: 3));
      case '5일 전':
        return now.subtract(Duration(days: 5));
      case '7일 전':
        return now.subtract(Duration(days: 7));
      case '한 달 전':
        return now.subtract(Duration(days: 30));
      default:
        return now;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(color: Colors.black.withOpacity(0.5)),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Material(
            color: Color(0xFFFBFBFB),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: double.infinity,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                        IconButton(
                          icon: Icon(Icons.border_color),
                          onPressed: () {
                            widget.onStartNewChat();
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
                            child: Icon(Icons.search),
                          ),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: '검색어를 입력하세요',
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                print('검색어 입력: $value');
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.calendar_today, color: Color(0xFF2F2F2F)),
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now(),
                                builder: (BuildContext context, Widget? child){
                                  return Theme(
                                    data: ThemeData.light().copyWith(
                                      colorScheme: ColorScheme.light(
                                        primary: Color(0xFFFF5833),
                                        onPrimary: Colors.white,
                                        surface: Color(0xFFFBFBFB),
                                        onSurface: Color(0xFF2F2F2F),
                                      ),
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          foregroundColor: Color(0xFF2F2F2F),
                                        ),
                                      ),
                                      dialogBackgroundColor: Color(0xFFFBFBFB),
                                      textTheme: TextTheme(
                                        bodyLarge: TextStyle(color: Color(0xFF2F2F2F)),
                                        labelLarge: TextStyle(color: Color(0xFF2F2F2F)),
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (picked != null) {
                                widget.onDateSelected(picked);
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  ...sideMenuItems.map((label) {
                    return ListTile(
                      title: Text(label),
                      onTap: () {
                        final date = _convertLabelToDate(label);
                        widget.onDateSelected(date);
                        Navigator.pop(context);
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
}
