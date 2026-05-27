import 'package:flutter/material.dart';
import 'package:todo/theme/app_theme.dart';

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
  TextEditingController dayController = TextEditingController();
  int selectedQuickOption = -1;
  bool saveDate = false;
  @override
  void initState() {
    super.initState();
    today = DateTime.now();
    fixedMonth = widget.finalMonth;
    fixedYear = widget.finalYear;
    dayController.text = widget.finalDay;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 430,
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
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              quickOption(0, Icons.wb_sunny_rounded, "Tommorow"),
              quickOption(1, Icons.weekend, "This Sunday"),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              quickOption(2, Icons.today_rounded, "Next Monday"),
              quickOption(3, Icons.update, "Day After"),
            ],
          ),
          dateChanger(),
          saveDateButton(),
        ],
      ),
    );
  }

  GestureDetector saveDateButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          saveDate = true;
        });
        if (saveDate) {
          Navigator.pop(context, (
            day: dayController.text,
            month: fixedMonth,
            year: fixedYear,
          ));
        }
      },
      child: Stack(
        children: [
          Container(
            height: saveDate ? 0 : 70,
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(64),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: saveDate ? 12 : 0),
            height: 64,
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: saveDate ? AppColors.secondaryText : Colors.white,
              borderRadius: BorderRadius.circular(64),
            ),
            child: Center(
              child: Text(
                "Save",
                style: TextStyle(
                  fontFamily: "HankenGrostek",
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: saveDate ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container dateChanger() {
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
              controller: dayController,
              cursorColor: Colors.white60,
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintTextDirection: TextDirection.rtl,
                hintText: today.day.toString(),
                hintStyle: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: AppColors.activeText,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(width: 4),
          Text(
            ".",
            style: TextStyle(color: AppColors.inactiveText, fontSize: 40),
          ),

          SizedBox(width: 6),

          SizedBox(
            child: Text(
              fixedMonth.toString(),
              style: TextStyle(
                color: AppColors.inactiveText,
                fontSize: 32,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 4),
          Text(
            ".",
            style: TextStyle(color: AppColors.inactiveText, fontSize: 40),
          ),
          SizedBox(width: 4),
          Text(
            fixedYear.toString(),
            style: TextStyle(
              color: AppColors.inactiveText,
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget quickOption(int index, IconData icon, String label) {
    final bool quickOptionTapped = selectedQuickOption == index;
    return GestureDetector(
      onTap: () {
        quickOptionSet(index);
      },
      child: Stack(
        children: [
          bottomLayerOption(quickOptionTapped),
          topLayerOption(quickOptionTapped, index, icon, label),
        ],
      ),
    );
  }

  void quickOptionSet(int index) {
    DateTime thisSunday() {
      int daysTillSunday = DateTime.sunday - today.weekday;
      if (daysTillSunday < 0) {
        return today.add((Duration(days: daysTillSunday + 7)));
      }
      return today.add(Duration(days: daysTillSunday));
    }

    DateTime nextMonday() {
      int daysTillMonday = DateTime.monday - today.weekday;
      if (daysTillMonday <= 0) {
        daysTillMonday += 7;
      }
      return today.add(Duration(days: daysTillMonday));
    }

    final DateTime targetDate;
    if (index == 0) {
      targetDate = today.add(const Duration(days: 1));
    } else if (index == 1) {
      targetDate = thisSunday();
    } else if (index == 2) {
      targetDate = nextMonday();
    } else {
      targetDate = today.add(const Duration(days: 2));
    }
    setState(() {
      if (selectedQuickOption == index) {
        selectedQuickOption = -1;
        dayController.text = today.day.toString();
      } else {
        selectedQuickOption = index;
        dayController.text = targetDate.day.toString();
        fixedMonth = targetDate.month.toString();
        fixedYear = targetDate.year.toString();
      }
    });
  }

  Widget bottomLayerOption(bool quickOptionTapped) {
    return Container(
      width: 178,
      height: quickOptionTapped ? 0 : 87,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 53, 54, 59),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget topLayerOption(
    bool quickOptionTapped,
    int index,
    IconData icon,
    String label,
  ) {
    return Container(
      margin: EdgeInsets.only(top: quickOptionTapped ? 5 : 0),
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      width: 178,
      height: 82,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: quickOptionTapped
            ? tappedBorderOption()
            : defaultBorderOption(),
        color: quickOptionTapped
            ? const Color(0xFF111216).withOpacity(0.2)
            : Color(0xFF202125),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: quickOptionTapped
                ? AppColors.activeText
                : AppColors.secondaryText,
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: quickOptionTapped
                    ? AppColors.activeText
                    : AppColors.secondaryText,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Border tappedBorderOption() {
    return const Border(
      top: BorderSide(color: Colors.black, width: 3),
      left: BorderSide(color: Colors.black, width: 3),
      bottom: BorderSide(color: Colors.black, width: 0.5),
      right: BorderSide(color: Colors.black, width: 0.5),
    );
  }

  Border defaultBorderOption() {
    return Border(
      top: BorderSide(color: Colors.white.withAlpha(20), width: 0.7),
      left: BorderSide(color: Colors.white.withAlpha(20), width: 0.7),
    );
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
}
