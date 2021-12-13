import 'package:flutter/material.dart';
import 'package:intonize/constants/colors.dart';
import 'package:intonize/controllers/tunerController.dart';

class SoundToggleIcon extends StatelessWidget {
  final Sound sound;
  final bool isLoading;
  final Function()? onTap;

  SoundToggleIcon({
    Key? key,
    required this.sound,
    this.isLoading = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        sound == Sound.piano ? Icons.piano_rounded : Icons.computer_rounded,
        color: !isLoading
            ? AppColors.primary
            : AppColors.primary.withAlpha(AppColors.inactiveAlpha),
      ),
      iconSize: 40,
      onPressed: !isLoading ? onTap : null,
    );
  }
}
