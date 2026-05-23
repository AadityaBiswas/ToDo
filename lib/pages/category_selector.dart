import 'package:flutter/material.dart';
import 'package:todo/theme/app_theme.dart';

class CategorySelector extends StatelessWidget {
  final int selectedCategory;
  final ValueChanged<int> onCategorySelected;

  const CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

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

  Widget categoryButton(
    double screenWidth,
    int index,
    IconData icon,
    String label,
  ) {
    final categoryTapped = selectedCategory == index;
    return GestureDetector(
      onTap: () {
        if (selectedCategory == index) {
          onCategorySelected(-1);
        } else {
          onCategorySelected(index);
        }
      },
      child: Stack(
        children: [
          bottomLayerCategory(categoryTapped),
          topLayerCategory(categoryTapped, index, screenWidth, icon, label),
        ],
      ),
    );
  }

  Widget bottomLayerCategory(bool categoryTapped) {
    if (categoryTapped) {
      return const SizedBox.shrink();
    } else {
      return Container(
        width: 77.6,
        height: 64,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 53, 54, 59),
          borderRadius: BorderRadius.circular(12),
        ),
      );
    }
  }

  Widget topLayerCategory(
    bool categoryTapped,
    int index,
    double screenWidth,
    IconData icon,
    String label,
  ) {
    return Container(
      margin: EdgeInsets.only(
        top: categoryTapped ? 2 : 0,
        right: index != 3 ? (screenWidth - (78 * 4) - 40) / 3 : 0,
        bottom: 14,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      width: 77.6,
      height: categoryTapped ? 64 : 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: categoryTapped
            ? tappedBorderCategory()
            : defaultBorderCategory(),
        // gradient: categoryTapped ? null : defaultGradientCategory(),
        color: categoryTapped
            ? const Color(0xFF111216).withOpacity(0.2)
            : Color(0xFF202125),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: categoryTapped
                ? (label == "Urgent" ? Colors.redAccent : AppColors.activeText)
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
                    ? (label == "Urgent"
                          ? Colors.redAccent
                          : AppColors.activeText)
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

  Border tappedBorderCategory() {
    return const Border(
      top: BorderSide(color: Colors.black, width: 3),
      left: BorderSide(color: Colors.black, width: 3),
      bottom: BorderSide(color: Colors.black, width: 0.5),
      right: BorderSide(color: Colors.black, width: 0.5),
    );
  }

  Border defaultBorderCategory() {
    return Border(
      top: BorderSide(color: Colors.white.withAlpha(20), width: 0.7),
      left: BorderSide(color: Colors.white.withAlpha(20), width: 0.7),
    );
  }

  // LinearGradient defaultGradientCategory() {
  //   return const LinearGradient(
  //     begin: Alignment.topCenter,
  //     end: Alignment.bottomCenter,
  //     colors: [Color(0xFF33343A), Color(0xFF2C2D33), Color(0xFF24252B)],
  //   );
  // }
}
