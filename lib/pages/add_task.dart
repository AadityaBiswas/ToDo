import 'package:flutter/material.dart';
import 'package:todo/theme/app_theme.dart';
import 'category_selector.dart'; // Import your newly created files
import 'scheduling_section.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  bool saveClicked = false;
  int selectedCategory = -1;
  bool dateTapped = true;
  bool timeTapped = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 396,
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
          taskName(),

          CategorySelector(
            selectedCategory: selectedCategory,
            onCategorySelected: (newIndex) {
              setState(() {
                selectedCategory = newIndex;
              });
            },
          ),

          SchedulingSection(
            dateTapped: dateTapped,
            timeTapped: timeTapped,
            onDateToggled: (newValue) {
              setState(() {
                dateTapped = newValue;
              });
            },
            onTimeToggled: (newValue) {
              setState(() {
                timeTapped = newValue;
              });
            },
          ),
          Positioned(
            bottom: 10,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  saveClicked = !saveClicked;
                  Navigator.pop(context);
                });
              },
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 16),
                    height: saveClicked ? 0 : 70,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(64),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: saveClicked ? 18 : 16),
                    height: 64,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: saveClicked
                          ? AppColors.secondaryText
                          : Colors.white,
                      borderRadius: BorderRadius.circular(64),
                    ),
                    child: Center(
                      child: Text(
                        "Save",
                        style: TextStyle(
                          fontFamily: "HankenGrostek",
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: saveClicked ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget dragHandle() {
    return Container(
      width: 48,
      height: 5,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(80),
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }

  Widget taskName() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFF111216).withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: const Border(
          top: BorderSide(color: Colors.black, width: 3),
          left: BorderSide(color: Colors.black, width: 3),
          bottom: BorderSide(color: Colors.black, width: 0.5),
          right: BorderSide(color: Colors.black, width: 0.5),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: const Center(
        child: TextField(
          cursorColor: Colors.white60,
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
