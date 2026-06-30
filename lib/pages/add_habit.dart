import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:hive/hive.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddHabit extends StatefulWidget {
  final String habitName;
  final List<bool> showHabitDays;
  const AddHabit({
    super.key,
    required this.habitName,
    required this.showHabitDays,
  });

  @override
  State<AddHabit> createState() => _AddHabitState();
}

class _AddHabitState extends State<AddHabit> {
  bool createHabit = false;
  late TextEditingController _habitController;
  late List<bool> selectedDays;
  bool everydayClicked = false;
  bool weekdaysClicked = false;
  bool weekendsClicked = false;
  bool customClicked = false;
  bool noTextInTask = false;
  final FocusNode _keyboardFocus = FocusNode();
  @override
  void initState() {
    super.initState();

    selectedDays = List.from(widget.showHabitDays);
    _habitController = TextEditingController(
      text: widget.habitName == "0" ? "" : widget.habitName,
    );
  }

  @override
  void dispose() {
    _keyboardFocus.dispose();
    _habitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = math.min(size.width / 440, size.height / 956);
    final screenWidth = MediaQuery.sizeOf(context).width;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      height: customClicked ? 148 * scale : 116 * scale,
      width: screenWidth,
      padding: EdgeInsets.only(
        top: 12 * scale,
        left: 12 * scale,
        right: 12 * scale,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF000000).withValues(alpha: 0.10),
            blurRadius: 4,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 0,
            child: TextField(
              focusNode: _keyboardFocus,
              autofocus: true,
              showCursor: false,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),

          SizedBox(
            height: 34 * scale,
            child: TextField(
              controller: _habitController,
              maxLines: 1,
              expands: false,
              textAlignVertical: TextAlignVertical.center,
              style: TextStyle(
                color: const Color(0xFF808080),
                fontSize: 22 * scale,
                fontWeight: FontWeight.w800,
                fontFamily: "Hanken_Grotesk",
              ),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                hintText: "What's the habit?",
                hintStyle: TextStyle(
                  color: const Color(0xFF999999),
                  fontSize: 22 * scale,
                  fontWeight: FontWeight.w800,
                  fontFamily: "Hanken_Grotesk",
                ),
              ),
            ),
          ),
          Divider(
            color: Color(0xFFCFCFCF).withValues(alpha: 0.30),
            thickness: 1.5 * scale,
          ),

          SizedBox(height: 2 * scale),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          everydayClicked = !everydayClicked;
                          if (everydayClicked) {
                            weekdaysClicked = false;
                            weekendsClicked = false;
                            customClicked = false;
                          }
                        });
                      },
                      child: Transform.translate(
                        offset: Offset(0, everydayClicked ? 3 : 0),
                        child: Container(
                          width: 76 * scale,
                          height: 40 * scale,
                          margin: EdgeInsets.only(right: 8 * scale),
                          decoration: BoxDecoration(
                            color: everydayClicked
                                ? Color(0xFFE5E5E5)
                                : Color(0xFFF2F2F2),
                            borderRadius: BorderRadius.circular(6 * scale),
                            border: Border(
                              top: BorderSide(
                                color: everydayClicked
                                    ? Color(0xFFBFBFBF)
                                    : Color(0xFFE0E0E0),
                                width: 2,
                              ),
                              right: BorderSide(
                                color: everydayClicked
                                    ? Color(0xFFBFBFBF)
                                    : Color(0xFFE0E0E0),
                                width: 2,
                              ),
                              left: BorderSide(
                                color: everydayClicked
                                    ? Color(0xFFBFBFBF)
                                    : Color(0xFFE0E0E0),
                                width: 2,
                              ),
                              bottom: BorderSide(
                                color: everydayClicked
                                    ? Color(0xFFBFBFBF)
                                    : Color(0xFFE0E0E0),
                                width: everydayClicked ? 2 : 6,
                              ),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Everday",
                              style: TextStyle(
                                color: Color(0xFF808080),
                                fontSize: 14 * scale,
                                fontWeight: FontWeight.w800,
                                fontFamily: "Hanken_Grotesk",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        setState(() {
                          weekdaysClicked = !weekdaysClicked;
                          if (weekdaysClicked) {
                            everydayClicked = false;
                            weekendsClicked = false;
                            customClicked = false;
                          }
                        });
                      },
                      child: Transform.translate(
                        offset: Offset(0, weekdaysClicked ? 3 : 0),
                        child: Container(
                          width: 80 * scale,
                          height: 40 * scale,
                          margin: EdgeInsets.only(right: 8 * scale),
                          decoration: BoxDecoration(
                            color: weekdaysClicked
                                ? Color(0xFFE5E5E5)
                                : Color(0xFFF2F2F2),
                            borderRadius: BorderRadius.circular(6 * scale),
                            border: Border(
                              top: BorderSide(
                                color: weekdaysClicked
                                    ? Color(0xFFBFBFBF)
                                    : Color(0xFFE0E0E0),
                                width: 2,
                              ),
                              right: BorderSide(
                                color: weekdaysClicked
                                    ? Color(0xFFBFBFBF)
                                    : Color(0xFFE0E0E0),
                                width: 2,
                              ),
                              left: BorderSide(
                                color: weekdaysClicked
                                    ? Color(0xFFBFBFBF)
                                    : Color(0xFFE0E0E0),
                                width: 2,
                              ),
                              bottom: BorderSide(
                                color: weekdaysClicked
                                    ? Color(0xFFBFBFBF)
                                    : Color(0xFFE0E0E0),
                                width: weekdaysClicked ? 2 : 6,
                              ),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Weekdays",
                              style: TextStyle(
                                color: Color(0xFF808080),
                                fontSize: 14 * scale,
                                fontWeight: FontWeight.w800,
                                fontFamily: "Hanken_Grotesk",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        setState(() {
                          weekendsClicked = !weekendsClicked;
                          if (weekendsClicked) {
                            everydayClicked = false;
                            weekdaysClicked = false;
                            customClicked = false;
                          }
                        });
                      },
                      child: Transform.translate(
                        offset: Offset(0, weekendsClicked ? 3 : 0),
                        child: Container(
                          width: 80 * scale,
                          height: 40 * scale,
                          margin: EdgeInsets.only(right: 8 * scale),
                          decoration: BoxDecoration(
                            color: weekendsClicked
                                ? Color(0xFFE5E5E5)
                                : Color(0xFFF2F2F2),
                            borderRadius: BorderRadius.circular(6 * scale),
                            border: Border(
                              top: BorderSide(
                                color: weekendsClicked
                                    ? Color(0xFFBFBFBF)
                                    : Color(0xFFE0E0E0),
                                width: 2,
                              ),
                              right: BorderSide(
                                color: weekendsClicked
                                    ? Color(0xFFBFBFBF)
                                    : Color(0xFFE0E0E0),
                                width: 2,
                              ),
                              left: BorderSide(
                                color: weekendsClicked
                                    ? Color(0xFFBFBFBF)
                                    : Color(0xFFE0E0E0),
                                width: 2,
                              ),
                              bottom: BorderSide(
                                color: weekendsClicked
                                    ? Color(0xFFBFBFBF)
                                    : Color(0xFFE0E0E0),
                                width: weekendsClicked ? 2 : 6,
                              ),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Weekends",
                              style: TextStyle(
                                color: Color(0xFF808080),
                                fontSize: 14 * scale,
                                fontWeight: FontWeight.w800,
                                fontFamily: "Hanken_Grotesk",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        setState(() {
                          customClicked = !customClicked;
                          if (customClicked) {
                            everydayClicked = false;
                            weekdaysClicked = false;
                            weekendsClicked = false;
                          }
                        });
                      },
                      child: Transform.translate(
                        offset: Offset(0, customClicked ? 3 : 0),
                        child: Container(
                          width: 40 * scale,
                          height: 40 * scale,
                          margin: EdgeInsets.only(right: 8 * scale),
                          decoration: BoxDecoration(
                            color: customClicked
                                ? Color(0xFFE5E5E5)
                                : Color(0xFFF2F2F2),
                            borderRadius: BorderRadius.circular(6 * scale),
                            border: Border(
                              top: BorderSide(
                                color: customClicked
                                    ? Color(0xFFBFBFBF)
                                    : Color(0xFFE0E0E0),
                                width: 2,
                              ),
                              right: BorderSide(
                                color: customClicked
                                    ? Color(0xFFBFBFBF)
                                    : Color(0xFFE0E0E0),
                                width: 2,
                              ),
                              left: BorderSide(
                                color: customClicked
                                    ? Color(0xFFBFBFBF)
                                    : Color(0xFFE0E0E0),
                                width: 2,
                              ),
                              bottom: BorderSide(
                                color: customClicked
                                    ? Color(0xFFBFBFBF)
                                    : Color(0xFFE0E0E0),
                                width: customClicked ? 2 : 6,
                              ),
                            ),
                          ),
                          child: Center(
                            child: customClicked
                                ? SvgPicture.asset(
                                    'assets/icon/customDatesSelected.svg',
                                    width: 26 * scale,
                                    height: 26 * scale,
                                  )
                                : SvgPicture.asset(
                                    'assets/icon/customDatesUnselected.svg',
                                    width: 26 * scale,
                                    height: 26 * scale,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              GestureDetector(
                onTap: () {
                  createHabit = _habitController.text.trim().isNotEmpty;

                  Navigator.pop(context, {
                    "name": _habitController.text.trim(),
                    "datesToShow": selectedDays,
                    "habitCreated": createHabit,
                  });
                },
                child: Transform.translate(
                  offset: Offset(0, customClicked ? 36 : 0),
                  child: Container(
                    width: 100 * scale,
                    height: 40 * scale,
                    decoration: BoxDecoration(
                      color: Color(0xFF333333),
                      borderRadius: BorderRadius.circular(12 * scale),
                      border: Border(
                        top: BorderSide(color: Color(0xFF242424), width: 2),
                        right: BorderSide(color: Color(0xFF242424), width: 2),
                        left: BorderSide(color: Color(0xFF242424), width: 2),
                        bottom: BorderSide(color: Color(0xFF242424), width: 6),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Create habit",
                        style: TextStyle(
                          color: Color(0xFFF2F2F2),
                          fontSize: 14 * scale,
                          fontWeight: FontWeight.w800,
                          fontFamily: "Hanken_Grotesk",
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (customClicked)
            Row(
              children: [
                AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  child: customClicked
                      ? Padding(
                          padding: EdgeInsets.only(top: 8 * scale),
                          child: Row(
                            children: [
                              weekdayButton("Mo", 0, scale),
                              weekdayButton("Tu", 1, scale),
                              weekdayButton("We", 2, scale),
                              weekdayButton("Th", 3, scale),
                              weekdayButton("Fr", 4, scale),
                              weekdayButton("Sa", 5, scale),
                              weekdayButton("Su", 6, scale),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget weekdayButton(String day, int index, double scale) {
    final selected = selectedDays[index];

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDays[index] = !selectedDays[index];
        });
      },

      child: Container(
        width: 36 * scale,
        height: 28 * scale,
        margin: const EdgeInsets.only(right: 8),

        decoration: BoxDecoration(
          color: selected ? Color(0xFFE5E5E5) : Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(6),
          border: Border(
            top: BorderSide(
              color: selected ? Color(0xFFBFBFBF) : Color(0xFFE0E0E0),
            ),
            right: BorderSide(
              color: selected ? Color(0xFFBFBFBF) : Color(0xFFE0E0E0),
            ),
            left: BorderSide(
              color: selected ? Color(0xFFBFBFBF) : Color(0xFFE0E0E0),
            ),
            bottom: BorderSide(
              color: selected ? Color(0xFFBFBFBF) : Color(0xFFE0E0E0),
              width: selected ? 2 : 3,
            ),
          ),
        ),

        child: Center(
          child: Text(
            day,
            style: TextStyle(
              color: Color(0xFF808080),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
