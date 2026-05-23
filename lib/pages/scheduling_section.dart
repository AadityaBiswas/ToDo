import 'package:flutter/material.dart';
import 'package:todo/theme/app_theme.dart';

class SchedulingSection extends StatelessWidget {
  final bool dateTapped;
  final bool timeTapped;
  final ValueChanged<bool> onDateToggled;
  final ValueChanged<bool> onTimeToggled;

  const SchedulingSection({
    super.key,
    required this.dateTapped,
    required this.timeTapped,
    required this.onDateToggled,
    required this.onTimeToggled,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Row(children: [dateSelector(screenWidth), timeSelector()]);
  }

  GestureDetector timeSelector() {
    return GestureDetector(
      onTap: () => onTimeToggled(!timeTapped),
      child: Container(
        padding: EdgeInsets.all(7),
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
            SizedBox(height: 6),
            Text(
              "Duration",
              style: TextStyle(
                fontSize: 14,
                color: AppColors.secondaryText,
                fontFamily: "JetBrainsMono",
              ),
            ),
            SizedBox(height: 4),
            Text(
              "1h 30m",
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

  GestureDetector dateSelector(double screenWidth) {
    return GestureDetector(
      onTap: () => onDateToggled(!dateTapped),
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
              "Today",
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
