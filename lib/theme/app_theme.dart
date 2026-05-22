import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFF121317);

  static const activeBase = Color(0xFF343539);

  static const activeTileTop = Color(0xFF4C4D52);
  static const activeTileMiddle = Color(0xFF46474B);
  static const activeTileBottom = Color(0xFF3F4044);

  static const activeText = Color(0xFFFFFFFF);
  static const activeTime = Color(0x99FFFFFF); // 60% white

  static const tileTop1 = Color(0xFF535459);
  static const tileTop2 = Color(0xFF494A4E);
  static const tileTop3 = Color(0xFF414247);

  static const tileBottom = Color(0xFF2A2B2F);

  static const secondaryText = Color(0xFFB0B0B5);

  static const inactiveTile = Color(0xFF101013);
  static const inactiveText = Color(0xFF747478);

  static const completedTile = Color(0x66000000);
  static const completedStrokeTop = Color(0x1AFFFFFF); // 10% white
  static const completedStrokeLeft = Color(0x0DFFFFFF); // 5% white
  static const completedText = Color(0xFF77777A);
}

class AppTextStyles {
  static const taskTitle = TextStyle(
    color: AppColors.activeText,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const taskTime = TextStyle(
    color: AppColors.secondaryText,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const inactiveTaskTitle = TextStyle(
    color: AppColors.inactiveText,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
}
