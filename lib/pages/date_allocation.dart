import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todo/theme/app_theme.dart';
import 'dart:math' as math;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dotted_border/dotted_border.dart';

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
  late DateTime selectedDate;
  late DateTime visibleDate;
  late final DateTime today;
  late String fixedMonth;
  late String fixedYear;
  bool clickedToday = false;
  bool tapToday = false;
  bool clickedTommorow = false;
  bool tapTommorow = false;
  bool clickedNextWeek = false;
  bool tapNextWeek = false;
  bool addDate = false;
  bool isExpanded = false;
  bool showExpandedBoxColourForMonth = false;
  bool clickedLeftArrow = false;
  bool clickedRightArrow = false;
  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    today = DateTime.now();
    visibleDate = DateTime.now();
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

    final weekDates = getWeekDays();
    final scale = math.min(size.width / 440, size.height / 956);
    return AnimatedContainer(
      duration: Duration(milliseconds: 120),
      curve: Curves.easeInOutCubic,
      height: isExpanded ? 360 * scale : 180 * scale,
      width: 440 * scale,
      padding: EdgeInsets.only(
        top: 8 * scale,
        right: 12 * scale,
        left: 12 * scale,
        bottom: 22 * scale,
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
              GestureDetector(
                onTap: () async {
                  setState(() {
                    showExpandedBoxColourForMonth = true;
                  });
                  await Future.delayed(Duration(milliseconds: 120));
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                  await Future.delayed(Duration(milliseconds: 120));
                  setState(() {
                    showExpandedBoxColourForMonth = false;
                  });
                },
                child: Transform.translate(
                  offset: Offset(0, showExpandedBoxColourForMonth ? 0.5 : 0),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10 * scale),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: showExpandedBoxColourForMonth
                          ? Color.fromARGB(255, 247, 247, 247)
                          : Colors.transparent,
                    ),
                    child: Row(
                      children: [
                        Text(
                          monthNames[visibleDate.month - 1],
                          style: TextStyle(
                            fontFamily: 'Hanken_Grotesk',
                            fontSize: 20 * scale,
                            fontWeight: FontWeight.w900,
                          ),
                        ),

                        Transform.rotate(
                          angle: isExpanded ? 0 : 180 * (math.pi / 180),
                          child: SvgPicture.asset(
                            'assets/icon/collapseIconDown.svg',
                            width: 24 * scale,
                            height: 24 * scale,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.only(bottom: 10 * scale),
                child: Row(
                  children: [
                    if (canGoToPreviousWeek())
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            clickedLeftArrow = true;
                          });
                          await Future.delayed(Duration(milliseconds: 80));
                          setState(() {
                            visibleDate = previousWeekStart(visibleDate);
                          });
                          await Future.delayed(Duration(milliseconds: 80));
                          setState(() {
                            clickedLeftArrow = false;
                          });
                        },
                        child: Transform.translate(
                          offset: Offset(0, clickedLeftArrow ? 2 : 0),
                          child: Container(
                            width: 28 * scale,
                            height: 28 * scale,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F2F2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border(
                                top: BorderSide(
                                  color: clickedLeftArrow
                                      ? Color(0xFFC0C0C0)
                                      : Color(0xFFE0E0E0),
                                  width: 1,
                                ),
                                right: BorderSide(
                                  color: clickedLeftArrow
                                      ? Color(0xFFC0C0C0)
                                      : Color(0xFFE0E0E0),
                                  width: 1,
                                ),
                                left: BorderSide(
                                  color: clickedLeftArrow
                                      ? Color(0xFFC0C0C0)
                                      : Color(0xFFE0E0E0),
                                  width: 1,
                                ),
                                bottom: BorderSide(
                                  color: clickedLeftArrow
                                      ? Color(0xFFC0C0C0)
                                      : Color(0xFFE0E0E0),
                                  width: clickedLeftArrow ? 1 : 3,
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
                        ),
                      ),

                    SizedBox(width: 8 * scale),

                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          clickedRightArrow = true;
                        });
                        await Future.delayed(Duration(milliseconds: 80));
                        setState(() {
                          visibleDate = nextWeekStart(visibleDate);
                        });
                        await Future.delayed(Duration(milliseconds: 80));
                        setState(() {
                          clickedRightArrow = false;
                        });
                      },
                      child: Transform.translate(
                        offset: Offset(0, clickedRightArrow ? 2 : 0),
                        child: Container(
                          width: 28 * scale,
                          height: 28 * scale,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F2F2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border(
                              top: BorderSide(
                                color: clickedRightArrow
                                    ? Color(0xFFC0C0C0)
                                    : Color(0xFFE0E0E0),
                                width: 1,
                              ),
                              right: BorderSide(
                                color: clickedRightArrow
                                    ? Color(0xFFC0C0C0)
                                    : Color(0xFFE0E0E0),
                                width: 1,
                              ),
                              left: BorderSide(
                                color: clickedRightArrow
                                    ? Color(0xFFC0C0C0)
                                    : Color(0xFFE0E0E0),
                                width: 1,
                              ),
                              bottom: BorderSide(
                                color: clickedRightArrow
                                    ? Color(0xFFC0C0C0)
                                    : Color(0xFFE0E0E0),
                                width: clickedRightArrow ? 1 : 3,
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
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: Row(
              children: List.generate(weekDates.length, (index) {
                final date = weekDates[index];
                return Expanded(
                  child: calendarDay(
                    weekday: weekdays[date.weekday - 1],
                    date: date,
                    isToday:
                        date.day == today.day &&
                        date.month == today.month &&
                        date.year == today.year,
                    dateOfPreviousMonth:
                        date.month != visibleDate.month ||
                        date.year != visibleDate.year,
                    scale: scale,
                  ),
                );
              }),
            ),
          ),

          Divider(
            color: Color(0xFFCFCFCF).withValues(alpha: 0.30),
            thickness: 1.5 * scale,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Row(
                  children: [
                    //Today Quick action button
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          tapToday = true;
                        });
                        await Future.delayed(Duration(milliseconds: 80));
                        setState(() {
                          clickedToday = !clickedToday;
                          clickedNextWeek = false;
                          clickedTommorow = false;
                        });
                        await Future.delayed(Duration(milliseconds: 80));
                        if (clickedToday) {
                          setState(() {
                            final now = DateTime.now();
                            selectedDate = DateTime(
                              now.year,
                              now.month,
                              now.day,
                            );
                            visibleDate = selectedDate;
                          });
                          await Future.delayed(Duration(milliseconds: 80));
                        }
                        setState(() {
                          tapToday = false;
                        });
                      },
                      child: Transform.translate(
                        offset: Offset(0, tapToday ? 4 : 0),
                        child: Container(
                          padding: EdgeInsets.all(6 * scale),
                          width: 72 * scale,
                          height: 38 * scale,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F2F2),
                            borderRadius: BorderRadius.circular(10),
                            border: Border(
                              top: BorderSide(
                                color: clickedToday
                                    ? Color(0xFFC0C0C0)
                                    : Color(0xFFE0E0E0),
                                width: 2,
                              ),
                              right: BorderSide(
                                color: clickedToday
                                    ? Color(0xFFC0C0C0)
                                    : Color(0xFFE0E0E0),
                                width: 2,
                              ),
                              left: BorderSide(
                                color: clickedToday
                                    ? Color(0xFFC0C0C0)
                                    : Color(0xFFE0E0E0),
                                width: 2,
                              ),
                              bottom: BorderSide(
                                color: clickedToday
                                    ? Color(0xFFC0C0C0)
                                    : Color(0xFFE0E0E0),
                                width: tapToday ? 2 : 6,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (clickedToday)
                                SvgPicture.asset(
                                  'assets/icon/todayCalendarSelected.svg',
                                  width: 20 * scale,
                                  height: 20 * scale,
                                ),
                              if (!clickedToday)
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
                                  color: clickedToday
                                      ? Color(0xFF333333)
                                      : Color(0xFF808080),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 8 * scale),

                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          tapTommorow = true;
                        });
                        await Future.delayed(Duration(milliseconds: 80));
                        setState(() {
                          clickedTommorow = !clickedTommorow;
                          clickedToday = false;
                          clickedNextWeek = false;
                        });
                        await Future.delayed(Duration(milliseconds: 80));
                        if (clickedTommorow) {
                          setState(() {
                            final tommorow = DateTime.now().add(
                              Duration(days: 1),
                            );
                            selectedDate = DateTime(
                              tommorow.year,
                              tommorow.month,
                              tommorow.day,
                            );
                            visibleDate = selectedDate;
                          });
                          await Future.delayed(Duration(milliseconds: 80));
                        } else {
                          selectedDate = today;
                        }
                        setState(() {
                          tapTommorow = false;
                        });
                      },
                      child: Transform.translate(
                        offset: Offset(0, tapTommorow ? 4 : 0),
                        child: Container(
                          padding: EdgeInsets.all(5 * scale),
                          width: 100 * scale,
                          height: 38 * scale,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F2F2),
                            borderRadius: BorderRadius.circular(10),
                            border: Border(
                              top: BorderSide(
                                color: clickedTommorow
                                    ? Color(0xFFC0C0C0)
                                    : Color(0xFFE0E0E0),
                                width: 2,
                              ),
                              right: BorderSide(
                                color: clickedTommorow
                                    ? Color(0xFFC0C0C0)
                                    : Color(0xFFE0E0E0),
                                width: 2,
                              ),
                              left: BorderSide(
                                color: clickedTommorow
                                    ? Color(0xFFC0C0C0)
                                    : Color(0xFFE0E0E0),
                                width: 2,
                              ),
                              bottom: BorderSide(
                                color: clickedTommorow
                                    ? Color(0xFFC0C0C0)
                                    : Color(0xFFE0E0E0),
                                width: tapTommorow ? 2 : 6,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (clickedTommorow)
                                SvgPicture.asset(
                                  'assets/icon/tommorowCalendarSelected.svg',
                                  width: 20 * scale,
                                  height: 20 * scale,
                                ),
                              if (!clickedTommorow)
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
                                  color: clickedTommorow
                                      ? Color(0xFF333333)
                                      : Color(0xFF808080),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 8 * scale),

                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          tapNextWeek = true;
                        });
                        await Future.delayed(Duration(milliseconds: 80));
                        setState(() {
                          clickedNextWeek = !clickedNextWeek;
                          clickedToday = false;
                          clickedTommorow = false;
                        });
                        await Future.delayed(Duration(milliseconds: 80));
                        if (clickedNextWeek) {
                          setState(() {
                            final currentMonday = today.subtract(
                              Duration(days: today.weekday - 1),
                            );

                            final nextWeekMonday = currentMonday.add(
                              const Duration(days: 7),
                            );
                            selectedDate = nextWeekMonday;
                            visibleDate = selectedDate;
                          });
                          await Future.delayed(Duration(milliseconds: 80));
                        } else {
                          selectedDate = today;
                        }
                        setState(() {
                          tapNextWeek = false;
                        });
                      },
                      child: Transform.translate(
                        offset: Offset(0, tapNextWeek ? 4 : 0),
                        child: Container(
                          padding: EdgeInsets.all(5 * scale),
                          width: 100 * scale,
                          height: 38 * scale,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F2F2),
                            borderRadius: BorderRadius.circular(10),
                            border: Border(
                              top: BorderSide(
                                color: clickedNextWeek
                                    ? Color(0xFFC0C0C0)
                                    : Color(0xFFE0E0E0),
                                width: 2,
                              ),
                              right: BorderSide(
                                color: clickedNextWeek
                                    ? Color(0xFFC0C0C0)
                                    : Color(0xFFE0E0E0),
                                width: 2,
                              ),
                              left: BorderSide(
                                color: clickedNextWeek
                                    ? Color(0xFFC0C0C0)
                                    : Color(0xFFE0E0E0),
                                width: 2,
                              ),
                              bottom: BorderSide(
                                color: clickedNextWeek
                                    ? Color(0xFFC0C0C0)
                                    : Color(0xFFE0E0E0),
                                width: tapNextWeek ? 2 : 6,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (clickedNextWeek)
                                SvgPicture.asset(
                                  'assets/icon/nextWeekCalendarSelected.svg',
                                  width: 20 * scale,
                                  height: 20 * scale,
                                ),
                              if (!clickedNextWeek)
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
                                  color: clickedNextWeek
                                      ? Color(0xFF333333)
                                      : Color(0xFF808080),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              GestureDetector(
                onTap: () {
                  setState(() {
                    addDate = !addDate;
                  });
                },
                child: Transform.translate(
                  offset: Offset(0, addDate ? 4 : 0),
                  child: Container(
                    padding: EdgeInsets.all(5 * scale),
                    width: 100 * scale,
                    height: 38 * scale,
                    decoration: BoxDecoration(
                      color: const Color(0xFF333333),
                      borderRadius: BorderRadius.circular(12),
                      border: Border(
                        top: BorderSide(color: Color(0xFF242424), width: 2),
                        right: BorderSide(color: Color(0xFF242424), width: 2),
                        left: BorderSide(color: Color(0xFF242424), width: 2),
                        bottom: BorderSide(
                          color: Color(0xFF242424),
                          width: addDate ? 2 : 6,
                        ),
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
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool canGoToPreviousWeek() {
    final today = DateTime.now();

    // Remove the time component
    final todayOnly = DateTime(today.year, today.month, today.day);

    // Monday of the currently visible week
    final visibleMonday = visibleDate.subtract(
      Duration(days: visibleDate.weekday - 1),
    );

    // Monday of the previous week
    final previousMonday = visibleMonday.subtract(const Duration(days: 7));

    // Don't allow navigation if the previous week starts before today's week
    return !previousMonday.isBefore(
      todayOnly.subtract(Duration(days: todayOnly.weekday - 1)),
    );
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  DateTime nextWeekStart(DateTime date) {
    return date.add(const Duration(days: 7));
  }

  DateTime previousWeekStart(DateTime date) {
    return date.subtract(const Duration(days: 7));
  }

  List<DateTime> getWeekDays() {
    final DateTime monday = visibleDate.subtract(
      Duration(days: visibleDate.weekday - 1),
    );
    return List.generate(7, (index) => monday.add(Duration(days: index)));
  }

  Widget calendarDay({
    required String weekday,
    required DateTime date,
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
        SizedBox(height: 6),
        GestureDetector(
          onTap: () {
            setState(() {
              selectedDate = date;
            });
          },
          child: DottedBorder(
            options: RoundedRectDottedBorderOptions(
              radius: Radius.circular(4),
              color: isSameDay(selectedDate, date)
                  ? Color(0xFF555555)
                  : Colors.transparent,
              strokeCap: StrokeCap.round,
              strokeWidth: 2,
              dashPattern: [3, 4],
            ),
            child: Container(
              width: 30 * scale,
              height: 24 * scale,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
              child: Center(
                child: Text(
                  date.day.toString(),
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
          ),
        ),
      ],
    );
  }
}
