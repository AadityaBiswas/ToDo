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

class _AddHabitState extends State<AddHabit> with TickerProviderStateMixin {
  late AnimationController _textShakeController;
  late Animation<double> _textShakeAnimation;

  late AnimationController _repeatShakeController;
  late Animation<double> _repeatShakeAnimation;
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
    everydayClicked = !widget.showHabitDays.contains(false);
    weekdaysClicked =
        widget.showHabitDays.take(5).every((e) => e) &&
        !widget.showHabitDays.skip(5).contains(true);
    weekendsClicked =
        !widget.showHabitDays.take(5).contains(true) &&
        widget.showHabitDays.skip(5).every((e) => e);
    _textShakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _textShakeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textShakeController, curve: Curves.linear),
    );

    // 3. Initialize Repeat Shake
    _repeatShakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _repeatShakeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _repeatShakeController, curve: Curves.linear),
    );
    selectedDays = List.from(widget.showHabitDays);
    _habitController = TextEditingController(
      text: widget.habitName == "0" ? "" : widget.habitName,
    );
  }

  @override
  void dispose() {
    _textShakeController.dispose();
    _repeatShakeController.dispose();
    _keyboardFocus.dispose();
    _habitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = math.min(size.width / 440, size.height / 956);
    final screenWidth = MediaQuery.sizeOf(context).width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(_keyboardFocus);
      },
      behavior: HitTestBehavior.translucent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        height: customClicked ? 148 * scale : 116 * scale,
        width: screenWidth,
        padding: EdgeInsets.only(
          top: 10 * scale,
          left: 8 * scale,
          right: 8 * scale,
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

            _buildShakeable(
              animation: _textShakeAnimation,
              child: Container(
                margin: EdgeInsets.only(top: 2),
                child: TextField(
                  cursorColor: Color(0xFF999999),
                  controller: _habitController,
                  maxLength: 30,
                  buildCounter:
                      (
                        context, {
                        required currentLength,
                        required isFocused,
                        maxLength,
                      }) => null,
                  textAlignVertical: TextAlignVertical.center,
                  style: TextStyle(
                    color: Color(0xFF464545),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Hanken_Grotesk",
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    hintText: "What's the habit?",
                    hintStyle: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF999999),
                      fontFamily: "Hanken_Grotesk",
                    ),
                  ),
                ),
              ),
            ),
            Divider(
              height:
                  12 *
                  scale, // Controls total vertical space the divider occupies
              color: Color(0xFFCFCFCF).withValues(alpha: 0.30),
              thickness: 1.5 * scale,
            ),

            SizedBox(height: 2 * scale),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildShakeable(
                  animation: _repeatShakeAnimation,
                  child: SizedBox(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              everydayClicked = !everydayClicked;
                              FocusScope.of(
                                context,
                              ).requestFocus(_keyboardFocus);
                              selectedDays.fillRange(0, 7, everydayClicked);
                              if (everydayClicked) {
                                weekdaysClicked = false;
                                weekendsClicked = false;
                                customClicked = customClicked ? true : false;
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
                              FocusScope.of(
                                context,
                              ).requestFocus(_keyboardFocus);
                              if (weekdaysClicked) {
                                selectedDays.fillRange(0, 5, true);
                                everydayClicked = false;
                                weekendsClicked = false;
                                customClicked = customClicked ? true : false;
                              } else {
                                selectedDays.fillRange(0, 7, false);
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
                              FocusScope.of(
                                context,
                              ).requestFocus(_keyboardFocus);
                              if (weekendsClicked) {
                                selectedDays.fillRange(
                                  0,
                                  5,
                                  false,
                                ); // Mon-Fri become false
                                selectedDays.fillRange(5, 7, true);
                                everydayClicked = false;
                                weekdaysClicked = false;
                                customClicked = customClicked ? true : false;
                              } else {
                                // If they click to deselect, clear everything
                                selectedDays.fillRange(0, 7, false);
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
                              FocusScope.of(
                                context,
                              ).requestFocus(_keyboardFocus);
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
                ),

                GestureDetector(
                  onTap: () {
                    // 1. Separate the logic
                    bool isNameValid = _habitController.text.trim().isNotEmpty;
                    bool isRepeatValid = selectedDays.contains(true);
                    FocusScope.of(context).requestFocus(_keyboardFocus);
                    // 2. Trigger targeted animations
                    if (!isNameValid) {
                      _textShakeController.forward(from: 0.0);
                    }
                    if (!isRepeatValid) {
                      _repeatShakeController.forward(from: 0.0);
                    }

                    // 3. Only submit if both are true
                    if (isNameValid && isRepeatValid) {
                      Navigator.pop(context, {
                        "name": _habitController.text.trim(),
                        "datesToShow": selectedDays,
                        "habitCreated": true,
                      });
                    }
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
                          bottom: BorderSide(
                            color: Color(0xFF242424),
                            width: 6,
                          ),
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
      ),
    );
  }

  Widget _buildShakeable({
    required Animation<double> animation,
    required Widget child,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final dx = math.sin(animation.value * math.pi * 6) * 8;
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
      child: child,
    );
  }

  Widget weekdayButton(String day, int index, double scale) {
    final selected = selectedDays[index];

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDays[index] = !selectedDays[index];
          everydayClicked = selectedDays.every((e) => e);
          weekdaysClicked =
              selectedDays.take(5).every((e) => e) &&
              !selectedDays.skip(5).contains(true);
          weekendsClicked =
              !selectedDays.take(5).contains(true) &&
              selectedDays.skip(5).every((e) => e);
        });
      },

      child: Transform.translate(
        offset: Offset(0, selected ? 2 : 0),
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
                width: 1,
              ),
              right: BorderSide(
                color: selected ? Color(0xFFBFBFBF) : Color(0xFFE0E0E0),
                width: 1,
              ),
              left: BorderSide(
                color: selected ? Color(0xFFBFBFBF) : Color(0xFFE0E0E0),
                width: 1,
              ),
              bottom: BorderSide(
                color: selected ? Color(0xFFBFBFBF) : Color(0xFFE0E0E0),
                width: selected ? 1 : 4,
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
      ),
    );
  }
}
