import 'package:flutter/material.dart';
import 'package:todo/theme/app_theme.dart';

class TimeAllocation extends StatefulWidget {
  final String initialHour;
  final String initialMinute;
  const TimeAllocation({
    super.key,
    required this.initialHour,
    required this.initialMinute,
  });

  @override
  State<TimeAllocation> createState() => _TimeAllocationState();
}

class _TimeAllocationState extends State<TimeAllocation> {
  final TextEditingController hourController = TextEditingController();
  final TextEditingController minuteController = TextEditingController();
  bool saveTime = false;
  @override
  void initState() {
    super.initState();
    if (widget.initialHour != "0" || widget.initialMinute != "0") {
      hourController.text = widget.initialHour;
      minuteController.text = widget.initialMinute;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF151518),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(color: Colors.white.withAlpha(24), width: 1),
          left: BorderSide(color: Colors.white.withAlpha(24), width: 1),
        ),
      ),

      child: Column(
        children: [
          dragHandle(),
          const SizedBox(height: 12),
          timeTextField(),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () async {
              String timeHour = hourController.text.trim().isEmpty
                  ? "0"
                  : hourController.text.trim();
              String timeMinute = minuteController.text.trim().isEmpty
                  ? "0"
                  : minuteController.text.trim();
              if (timeHour.isNotEmpty || timeMinute.isNotEmpty) {
                setState(() {
                  saveTime = true;
                });
                Navigator.pop(context, (
                  timeHour: timeHour,
                  timeMinute: timeMinute,
                ));
              } else {
                setState(() {
                  saveTime = true;
                });
                await Future.delayed(const Duration(milliseconds: 150));
                setState(() {
                  saveTime = false;
                });
              }
            },
            child: Stack(
              children: [
                Container(
                  height: saveTime ? 0 : 70,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(64),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: saveTime ? 12 : 0),
                  height: 64,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: saveTime ? AppColors.secondaryText : Colors.white,
                    borderRadius: BorderRadius.circular(64),
                  ),
                  child: Center(
                    child: Text(
                      "Save",
                      style: TextStyle(
                        fontFamily: "HankenGrostek",
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: saveTime ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container timeTextField() {
    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 12),
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFF111216).withOpacity(0.2),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          bottomLeft: Radius.circular(12),
        ),
        border: const Border(
          top: BorderSide(color: Colors.black, width: 3),
          left: BorderSide(color: Colors.black, width: 3),
          bottom: BorderSide(color: Colors.black, width: 0.5),
          right: BorderSide(color: Colors.black, width: 0.5),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40,
            child: TextField(
              textAlign: TextAlign.right,
              controller: hourController,
              cursorColor: Colors.white60,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintTextDirection: TextDirection.rtl,
                hintText: "0",
                hintStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(width: 12),
          Text(
            "Hour",
            style: TextStyle(color: Color(0xFFC4C7C8), fontSize: 18),
          ),

          SizedBox(width: 20),

          SizedBox(
            width: 40,
            child: TextField(
              textAlign: TextAlign.right,
              controller: minuteController,
              cursorColor: Colors.white60,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintTextDirection: TextDirection.rtl,
                hintText: "0",
                hintStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(width: 12),
          Text(
            "Minutes",
            style: TextStyle(color: Color(0xFFC4C7C8), fontSize: 18),
          ),
        ],
      ),
    );
  }
}

Widget dragHandle() {
  return Container(
    width: 48,
    height: 5,
    decoration: BoxDecoration(
      color: Colors.white.withAlpha(80),
      borderRadius: BorderRadius.circular(100),
    ),
  );
}
