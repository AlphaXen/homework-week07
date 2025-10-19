import 'package:myapp/week07/calendar_scheduler/const/color.dart';
import 'package:flutter/material.dart';

class TodayBanner extends StatelessWidget {
  final DateTime selectedDate;
  final int count;

  const TodayBanner({
    required this.selectedDate,
    required this.count,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      // 기본으로 사용할 글꼴
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );

    return Container(
      color: PRIMARY_COLOR,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          // "년 월 일" 형태로 표시
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일',
              style: textStyle,
            ),
            Text(
              '$count개', // 일정 개수 표시
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}
