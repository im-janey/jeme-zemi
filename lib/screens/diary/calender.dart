import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:table_calendar/table_calendar.dart';

import '../home/setting.dart';
import 'diary.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime? _selectedDate;
  DateTime _focusedDay = DateTime.now();
  Map<DateTime, Map<String, dynamic>> _dateEntries = {};

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _loadDiaryEntries();
  }

  Future<void> _loadDiaryEntries() async {
    final entries = await loadDiaryEntries("dummy_user_id");
    if (mounted) {
      setState(() {
        _dateEntries = entries;
      });
    }
  }

  void _selectDate(DateTime date) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DiaryModal(
        date: date,
        initialNote: _dateEntries[date]?['note'],
        onSave: (note) {
          setState(() {
            _dateEntries[date] = {'note': note};
          });
        },
        onDelete: () {
          setState(() {
            _dateEntries.remove(date);
          });
        },
      ),
    ).then((_) => _loadDiaryEntries());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;

    final DateFormat yearMonthFormat = DateFormat('yyyy MMMM');
    String formattedYearMonth = yearMonthFormat.format(_focusedDay);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.calendar_today_outlined, color: textColor),
          onPressed: () {
            setState(() {
              _focusedDay = DateTime.now();
            });
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 30),
          Row(
            children: [
              SizedBox(width: 15),
              Text(
                formattedYearMonth,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.arrow_back_ios, color: textColor),
                onPressed: () {
                  setState(() {
                    _focusedDay = DateTime(
                      _focusedDay.year,
                      _focusedDay.month - 1,
                      1,
                    );
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward_ios, color: textColor),
                onPressed: () {
                  setState(() {
                    _focusedDay = DateTime(
                      _focusedDay.year,
                      _focusedDay.month + 1,
                      1,
                    );
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 50),
          Expanded(
            child: Stack(
              children: [
                // Lottie Animation Background
                Positioned(
                  bottom: 0, // 달력 아래와 맞추기 위해 바닥에 배치
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: 580, // Lottie 파일의 크기 조정
                    child: Opacity(
                      opacity: 0.5, // 배경 효과로 적당히 투명하게 설정
                      child: Lottie.asset(
                        'assets/tree.json',
                      ),
                    ),
                  ),
                ),
                // Calendar
                TableCalendar(
                  firstDay: DateTime(2000),
                  lastDay: DateTime(2100),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDate, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDate = selectedDay;
                      _focusedDay = focusedDay;
                    });
                    _selectDate(selectedDay);
                  },
                  calendarFormat: CalendarFormat.month,
                  onFormatChanged: (format) {
                    // 사용자 입력 무시
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                  },
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: theme.colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    defaultTextStyle: TextStyle(
                        color: textColor, fontWeight: FontWeight.bold),
                    weekendTextStyle: TextStyle(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.bold),
                    cellMargin: const EdgeInsets.all(8.0), // 셀 간격 조정
                  ),
                  headerVisible: false,
                ),
              ],
            ),
          ),
          if (_selectedDate != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '선택된 날짜: ${DateFormat('yyyy.MM.dd').format(_selectedDate!)}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectDate(_selectedDate!),
                    child: Text("기록하기"),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// Firebase 없이 작동하는 시뮬레이션 데이터 로드 함수
Future<Map<DateTime, Map<String, dynamic>>> loadDiaryEntries(String uid) async {
  return {
    DateTime.now(): {'note': 'Simulated note'},
  };
}
