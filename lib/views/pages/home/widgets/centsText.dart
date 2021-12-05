import 'package:flutter/material.dart';
import 'package:intonize/constants/colors.dart';

class CentsText extends StatelessWidget {
  final double diffCents;
  final bool isActive;

  CentsText({
    Key? key,
    required this.diffCents,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      isActive ? diffCents.toInt().toString() + '¢' : '',
      style: TextStyle(color: AppColors.gaugePrimary, fontSize: 24),
    );
  }
}
