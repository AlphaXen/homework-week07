import 'package:myapp/week07/calendar_scheduler/component/main_calendar.dart';
import 'package:flutter/material.dart';
import 'package:myapp/week07/calendar_scheduler/component/schedule_card.dart';
import 'package:myapp/week07/calendar_scheduler/component/today_banner.dart';
import 'package:myapp/week07/calendar_scheduler/component/schedule_bottom_sheet.dart';
import 'package:myapp/week07/calendar_scheduler/const/color.dart';
import 'package:get_it/get_it.dart';
import 'package:myapp/week07/calendar_scheduler/database/drift_database.dart';
import 'package:myapp/week07/calendar_scheduler/component/today_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  DateTime selectedDate = DateTime.utc(
    // 선택된 날짜를 관리할 변수
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        // 새 일정 버튼
        backgroundColor: PRIMARY_COLOR,
        onPressed: () {
          showModalBottomSheet(
            // BottomSheet 열기
            context: context,
            isDismissible: true, // 배경 탭했을 때 BottomSheet 닫기
            builder: (_) => ScheduleBottomSheet(
              selectedDate: selectedDate, // 선택된 날짜 (selectedDate) 넘겨주기
            ),
            // BottomSheet의 높이를 화면의 최대 높이로
            // 정의하고 스크롤 가능하게 변경
            isScrollControlled: true,
          );
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        // 시스템 UI 피해서 UI 구현하기
        child: Column(
          // 달력과 리스트를 세로로 배치
          children: [
            // 미리 작업해둔 달력 위젯 보여주기
            MainCalendar(
              selectedDate: selectedDate, // 선택된 날짜 전달하기
              // 날짜가 선택되었을 때 실행할 함수
              onDaySelected: onDaySelected, // 선택된 날짜
            ),
            SizedBox(height: 8.0),
            StreamBuilder<List<
            SizedBox(height: 8.0),
            Expanded(
              // 남는 공간을 모두 차지하기
              // 일정 정보가 Stream으로 제공되기 때문에 StreamBuilder 사용
              child: StreamBuilder<List<Schedule>>(
                stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    // 데이터가 없을 때
                    return Container();
                  }
                  // 화면에 보이는 값들만 렌더링하는 리스트
                  return ListView.builder(
                    // 리스트에 입력할 값들의 총 개수
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      // 현재 index에 해당되는 일정
                      final schedule = snapshot.data![index];

                      return Dismissible(
                        key: ObjectKey(schedule.id), // 유니크한 키값
                        direction: DismissDirection.startToEnd,
                        // 밀기 방향(왼쪽에서 오른쪽으로)
                        onDismissed: (DismissDirection direction) {
                          // 밀기 했을 때 실행할 함수
                          GetIt.I<LocalDatabase>().removeSchedule(schedule.id);
                        },
                        child: Padding(
                          // 좌우로 패딩을 추가해서 UI 개선
                          padding: const EdgeInsets.only(
                            bottom: 8.0,
                            left: 8.0,
                            right: 8.0,
                          ),
                          child: ScheduleCard(
                            startTime: schedule.startTime,
                            endTime: schedule.endTime,
                            content: schedule.content,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            TodayBanner(
              // 배너 추가하기
              selectedDate: selectedDate,
              count: 0,
            ),
            SizedBox(height: 8.0),
            ScheduleCard(
              // 구현해둔 일정 카드
              startTime: 12,
              endTime: 14,
              content: '프로그래밍 공부',
            ),
          ],
        ),
      ),
    );
  }

  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    // 날짜가 선택될 때마다 실행할 함수
    setState(() {
      this.selectedDate = selectedDate;
    });
  }
}
