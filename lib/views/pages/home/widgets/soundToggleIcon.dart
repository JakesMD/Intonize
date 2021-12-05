import 'package:flutter/material.dart';
import 'package:intonize/constants/colors.dart';

class SoundToggleIcon extends StatelessWidget {
  final bool isPiano;
  final bool isLoading;
  final Function()? onTap;

  SoundToggleIcon({
    Key? key,
    this.isPiano = true,
    this.isLoading = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(isPiano ? Icons.piano_rounded : Icons.computer_rounded),
      color: !isLoading
          ? AppColors.primary
          : AppColors.primary.withAlpha(AppColors.inactiveAlpha),
      iconSize: 40,
      onPressed: !isLoading ? onTap : null,
    );
  }
}
