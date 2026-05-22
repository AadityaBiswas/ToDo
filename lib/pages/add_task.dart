// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:todo/theme/app_theme.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  int selectedCategory = -1;
  bool dateTapped = false;
  bool timeTapped = false;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 390,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Color(0xFF151518),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(color: Colors.white.withAlpha(24), width: 1),
          left: BorderSide(color: Colors.white.withAlpha(24), width: 1),
        ),
      ),
      child: Column(
        children: [
          dragHandle(),
          taskName(),
          categories(screenWidth),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    dateTapped = !dateTapped;
                  });
                },
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        right: (screenWidth - (170 * 2) - 50),
                      ),
                      width: 170,
                      height: 82,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: dateTapped
                            ? tappedBorderCategory()
                            : defualtBorderCategory(),
                        gradient: dateTapped ? null : defaultGradienCategory(),
                        color: dateTapped
                            ? Color(0xFF111216).withOpacity(0.2)
                            : null,
                      ),
                    ),
                  ],
                ),
              ),

              GestureDetector(
                onTap: () {
                  setState(() {
                    timeTapped = !timeTapped;
                  });
                },
                child: Stack(
                  children: [
                    Container(
                      width: 170,
                      height: 82,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: timeTapped
                            ? tappedBorderCategory()
                            : defualtBorderCategory(),
                        gradient: timeTapped ? null : defaultGradienCategory(),
                        color: timeTapped
                            ? Color(0xFF111216).withOpacity(0.2)
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Row categories(double screenWidth) {
    return Row(
      children: [
        categoryButton(screenWidth, 0, Icons.work_outline_rounded, "Work"),
        categoryButton(
          screenWidth,
          1,
          Icons.person_outline_rounded,
          "Personal",
        ),
        categoryButton(screenWidth, 2, Icons.priority_high_rounded, "Urgent"),
        categoryButton(screenWidth, 3, Icons.school_rounded, "Study"),
      ],
    );
  }

  GestureDetector categoryButton(
    double screenWidth,
    int index,
    IconData icon,
    String label,
  ) {
    final categoryTapped = selectedCategory == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          if (selectedCategory == index) {
            selectedCategory = -1;
          } else {
            selectedCategory = index;
          }
        });
      },
      child: Stack(
        children: [
          bottomLayerCategory(categoryTapped),
          topLayerCategory(categoryTapped, index, screenWidth, icon, label),
        ],
      ),
    );
  }

  Container bottomLayerCategory(bool categoryTapped) {
    if (categoryTapped) {
      return Container();
    } else {
      return Container(
        width: 77.6,
        height: 64,
        decoration: BoxDecoration(
          color: const Color(0xFF2F3035),
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.only(bottom: 8),
      );
    }
  }

  Container topLayerCategory(
    bool categoryTapped,
    int index,
    double screenWidth,
    IconData icon,
    String label,
  ) {
    return Container(
      margin: EdgeInsets.only(
        top: categoryTapped ? 4 : 0,
        right: index != 3 ? (screenWidth - (78 * 4) - 40) / 3 : 0,
      ),
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      width: 77.6,
      height: categoryTapped ? 64 : 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: categoryTapped
            ? tappedBorderCategory()
            : defualtBorderCategory(),
        gradient: categoryTapped ? null : defaultGradienCategory(),
        color: categoryTapped ? Color(0xFF111216).withOpacity(0.2) : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: categoryTapped
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
                color: categoryTapped
                    ? AppColors.activeText
                    : AppColors.secondaryText,
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Border tappedBorderCategory() {
    return Border(
      top: BorderSide(color: Colors.black, width: 3),
      left: BorderSide(color: Colors.black, width: 3),
      bottom: BorderSide(color: Colors.black, width: 0.5),
      right: BorderSide(color: Colors.black, width: 0.5),
    );
  }

  Border defualtBorderCategory() {
    return Border(
      top: BorderSide(color: Colors.white.withAlpha(48), width: 1),
      left: BorderSide(color: Colors.white.withAlpha(48), width: 1),
    );
  }

  LinearGradient defaultGradienCategory() {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF33343A), Color(0xFF2C2D33), Color(0xFF24252B)],
    );
  }

  Container dragHandle() {
    return Container(
      width: 48,
      height: 5,
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(80),
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }

  Container taskName() {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      height: 80,
      decoration: BoxDecoration(
        color: Color(0xFF111216).withOpacity(0.2),

        borderRadius: BorderRadius.circular(12),
        border: Border(
          top: BorderSide(color: Colors.black, width: 3),
          left: BorderSide(color: Colors.black, width: 3),
          bottom: BorderSide(color: Colors.black, width: 0.5),
          right: BorderSide(color: Colors.black, width: 0.5),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Center(
        child: TextField(
          cursorColor: Colors.white.withOpacity(0.6),
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: "What needs to be done",
            hintStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
