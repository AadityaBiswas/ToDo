import 'package:flutter/material.dart';
import 'package:todo/theme/app_theme.dart';
import 'dart:math' as math;
import 'package:flutter_svg/flutter_svg.dart';

class DateAllocation extends StatefulWidget {
  final String finalDay;
  final String finalMonth;
  final String finalYear;
  const DateAllocation({
    super.key,
    required this.finalDay,
    required this.finalMonth,
    required this.finalYear,
  });

  @override
  State<DateAllocation> createState() => _DateAllocationState();
}

class _DateAllocationState extends State<DateAllocation> {
  late final DateTime today;
  late String fixedMonth;
  late String fixedYear;
  @override
  void initState() {
    super.initState();
    today = DateTime.now();
    fixedMonth = widget.finalMonth;
    fixedYear = widget.finalYear;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    const weekdays = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"];

    final weekDates = ["30", "31", "1", "2", "3", "4", "5"];
    final scale = math.min(size.width / 440, size.height / 956);
    return Container(
      height: 174 * scale,
      width: 440 * scale,
      padding: EdgeInsets.only(
        top: 8 * scale,
        right: 12 * scale,
        left: 12 * scale,
        bottom: 12 * scale,
      ),
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 12 * scale),
                child: Row(
                  children: [
                    Text(
                      monthNames[today.month - 1],
                      style: TextStyle(
                        fontFamily: 'Hanken_Grotesk',
                        fontSize: 20 * scale,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/icon/collapseIconDown.svg',
                      width: 24 * scale,
                      height: 24 * scale,
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10 * scale),
                child: Row(
                  children: [
                    Container(
                      width: 28 * scale,
                      height: 28 * scale,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border(
                          top: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                          right: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                          left: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                          bottom: BorderSide(
                            color: Color(0xFFE0E0E0),
                            width: 3,
                          ),
                        ),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icon/rightArrow.svg',
                          width: 5 * scale,
                          height: 10 * scale,
                        ),
                      ),
                    ),
                    SizedBox(width: 8 * scale),
                    Container(
                      width: 28 * scale,
                      height: 28 * scale,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border(
                          top: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                          right: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                          left: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                          bottom: BorderSide(
                            color: Color(0xFFE0E0E0),
                            width: 3,
                          ),
                        ),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icon/leftArrow.svg',
                          width: 5 * scale,
                          height: 10 * scale,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: List.generate(weekDates.length, (index) {
              return Expanded(
                child: calendarDay(
                  weekday: weekdays[index],
                  day: weekDates[index],
                  isSelected: false,
                  isToday: index == 2,
                  dateOfPreviousMonth: index < 2,
                  scale: scale,
                ),
              );
            }),
          ),

          SizedBox(height: 4 * scale),

          Divider(
            color: Color(0xFFCFCFCF).withValues(alpha: 0.30),
            thickness: 1.5 * scale,
          ),

          SizedBox(height: 2 * scale),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6 * scale),
                      width: 72 * scale,
                      height: 36 * scale,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border(
                          top: BorderSide(color: Color(0xFFE0E0E0), width: 2),
                          right: BorderSide(color: Color(0xFFE0E0E0), width: 2),
                          left: BorderSide(color: Color(0xFFE0E0E0), width: 2),
                          bottom: BorderSide(
                            color: Color(0xFFE0E0E0),
                            width: 6,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icon/todayCalendarUnselected.svg',
                            width: 20 * scale,
                            height: 20 * scale,
                          ),
                          Text(
                            "Today",
                            style: TextStyle(
                              fontFamily: "Hanken_Grotesk",
                              fontSize: 12 * scale,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF808080),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8 * scale),

                    Container(
                      padding: EdgeInsets.all(5 * scale),
                      width: 100 * scale,
                      height: 36 * scale,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border(
                          top: BorderSide(color: Color(0xFFE0E0E0), width: 2),
                          right: BorderSide(color: Color(0xFFE0E0E0), width: 2),
                          left: BorderSide(color: Color(0xFFE0E0E0), width: 2),
                          bottom: BorderSide(
                            color: Color(0xFFE0E0E0),
                            width: 6,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icon/tommorowCalendarUnselected.svg',
                            width: 20 * scale,
                            height: 20 * scale,
                          ),
                          Text(
                            "Tommorow",
                            style: TextStyle(
                              fontFamily: "Hanken_Grotesk",
                              fontSize: 12 * scale,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF808080),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 8 * scale),

                    Container(
                      padding: EdgeInsets.all(5 * scale),
                      width: 100 * scale,
                      height: 36 * scale,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border(
                          top: BorderSide(color: Color(0xFFE0E0E0), width: 2),
                          right: BorderSide(color: Color(0xFFE0E0E0), width: 2),
                          left: BorderSide(color: Color(0xFFE0E0E0), width: 2),
                          bottom: BorderSide(
                            color: Color(0xFFE0E0E0),
                            width: 6,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icon/nextWeekCalendarUnselected.svg',
                            width: 20 * scale,
                            height: 20 * scale,
                          ),
                          Text(
                            "Next week",
                            style: TextStyle(
                              fontFamily: "Hanken_Grotesk",
                              fontSize: 12 * scale,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF808080),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.all(5 * scale),
                width: 100 * scale,
                height: 36 * scale,
                decoration: BoxDecoration(
                  color: const Color(0xFF333333),
                  borderRadius: BorderRadius.circular(12),
                  border: Border(
                    top: BorderSide(color: Color(0xFF242424), width: 2),
                    right: BorderSide(color: Color(0xFF242424), width: 2),
                    left: BorderSide(color: Color(0xFF242424), width: 2),
                    bottom: BorderSide(color: Color(0xFF242424), width: 6),
                  ),
                ),
                child: Center(
                  child: Text(
                    "Add date",
                    style: TextStyle(
                      fontFamily: "Hanken_Grotesk",
                      fontSize: 14 * scale,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF2F2F2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget calendarDay({
    required String weekday,
    required String day,
    required bool isSelected,
    required bool isToday,
    required double scale,
    bool dateOfPreviousMonth = false,
  }) {
    return Column(
      children: [
        Text(
          weekday,
          style: TextStyle(
            fontFamily: "Hanken_Grotesk",
            fontSize: 15 * scale,
            color: Color(0xFF6F7C8E),
            fontWeight: FontWeight.normal,
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: 30 * scale,
          height: 20 * scale,
          decoration: BoxDecoration(
            color: isSelected ? Color(0xFF595959) : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
            border: isSelected
                ? Border(
                    top: BorderSide(color: Color(0xFF404040), width: 1),
                    right: BorderSide(color: Color(0xFF404040), width: 1),
                    left: BorderSide(color: Color(0xFF404040), width: 1),
                    bottom: BorderSide(color: Color(0xFF404040), width: 3),
                  )
                : null,
          ),
          child: Center(
            child: Text(
              day.toString(),
              style: TextStyle(
                fontFamily: "Hanken_Grotesk",
                fontSize: 18 * scale,
                fontWeight: FontWeight.w600,
                color: dateOfPreviousMonth
                    ? Color(0xFF6F7C8E)
                    : isToday
                    ? Colors.red
                    : Color(0xFF0D0D0D),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
