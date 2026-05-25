import 'package:flutter/material.dart';
import 'package:todo/pages/date_allocation.dart';
import 'package:todo/pages/time_allocation.dart';
import 'package:todo/theme/app_theme.dart';

class SchedulingSection extends StatelessWidget {
  final String selectedDate;
  final int selectedMonth;
  final int selectedYear;
  final bool dateTapped;
  final bool timeTapped;
  final ValueChanged<bool> onDateToggled;
  final ValueChanged<bool> onTimeToggled;
  final Function(String hour, String minute) onTimeSelected;
  final String selectedHour;
  final String selectedMinute;
  final Function(String date, int month, int year) onDateSelected;

  const SchedulingSection({
    required this.selectedDate,
    required this.selectedMonth,
    required this.selectedYear,
    required this.selectedHour,
    required this.selectedMinute,
    super.key,
    required this.onDateSelected,
    required this.dateTapped,
    required this.timeTapped,
    required this.onDateToggled,
    required this.onTimeToggled,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Row(
      children: [dateSelector(screenWidth, context), timeSelector(context)],
    );
  }

  GestureDetector timeSelector(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result =
            await showModalBottomSheet<({String timeHour, String timeMinute})>(
              context: context,
              builder: (context) {
                return TimeAllocation(
                  initialHour: selectedHour,
                  initialMinute: selectedMinute,
                );
              },
            );

        if (result != null) {
          onTimeSelected(result.timeHour, result.timeMinute);
          onTimeToggled(true);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(7),
        width: 140,
        height: 82,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: defaultBorder(),
          color: const Color(0xFF111216).withOpacity(0.2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 6),
            Text(
              "Duration",
              style: TextStyle(
                fontSize: 14,
                color: AppColors.secondaryText,
                fontFamily: "JetBrainsMono",
              ),
            ),
            const SizedBox(height: 4),
            if (!(selectedHour == "0" && selectedMinute == "0"))
              Text(
                selectedHour == "0" && selectedMinute == "0"
                    ? "Set estimate"
                    : selectedHour == "0"
                    ? "${selectedMinute}m"
                    : selectedMinute == "0"
                    ? "${selectedHour}h"
                    : "${selectedHour}h ${selectedMinute}m",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            if ((selectedHour == "0" && selectedMinute == "0"))
              Text(
                "Set a Estimate",
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.activeText,
                  fontFamily: "JetBrainsMono",
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ),
    );
  }

  GestureDetector dateSelector(double screenWidth, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result =
            await showModalBottomSheet<({String day, int month, int year})>(
              context: context,
              builder: ((context) {
                return DateAllocation(
                  finalDay: selectedDate,
                  finalMonth: selectedMonth,
                  finalYear: selectedYear,
                );
              }),
            );
        if (result != null) {
          onDateSelected(result.day, result.month, result.year);
          onDateToggled(true);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 42, vertical: 8),
        margin: EdgeInsets.only(right: (screenWidth - 41 - 220 - 140)),
        width: 220,
        height: 82,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: defaultBorder(),
          color: const Color(0xFF111216).withOpacity(0.2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 4),
            Text(
              "Scheduled For",
              style: TextStyle(
                fontSize: 14,
                color: AppColors.secondaryText,
                fontFamily: "JetBrainsMono",
              ),
            ),
            SizedBox(height: 4),
            Text(
              selectedDate == DateTime.now().day.toString() &&
                      selectedMonth == DateTime.now().month &&
                      selectedYear == DateTime.now().year
                  ? "Today"
                  : "$selectedDate.${selectedMonth.toString()}.$selectedYear",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Border defaultBorder() {
    return const Border(
      top: BorderSide(color: Colors.black, width: 3),
      left: BorderSide(color: Colors.black, width: 3),
      bottom: BorderSide(color: Colors.black, width: 1.5),
      right: BorderSide(color: Colors.black, width: 1.5),
    );
  }
}
