import 'package:flutter/material.dart';
import 'package:intonize/constants/colors.dart';

class HertzText extends StatelessWidget {
  final double frequency;
  final bool isActive;

  const HertzText({
    Key? key,
    required this.frequency,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      isActive ? frequency.toInt().toString() + ' Hz' : '',
      style: TextStyle(
        color: AppColors.primary.withAlpha(AppColors.inactiveAlpha),
      ),
    );
  }
}
