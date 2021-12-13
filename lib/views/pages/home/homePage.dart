import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intonize/constants/colors.dart';
import 'package:intonize/controllers/tunerController.dart';
import 'package:intonize/views/pages/home/widgets/centsText.dart';
import 'package:intonize/views/pages/home/widgets/hertzText.dart';
import 'package:intonize/views/pages/home/widgets/soundToggleIcon.dart';
import 'package:intonize/views/pages/home/widgets/tuningGauge.dart';

class HomePage extends GetView<TunerController> {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homePage,
      body: Center(
        child: controller.obx(
          (state) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CentsText(
                diffCents: controller.diffCents.value,
                isActive: controller.isActive.value,
              ),
              TuningGauge(
                diffCents: controller.diffCents.value,
                isActive: controller.isActive.value,
                note: controller.note.value,
                isLoading: controller.status.isLoading,
              ),
              HertzText(
                frequency: controller.frequency.value,
                isActive: controller.isActive.value,
              ),
              SizedBox(height: 30),
              SoundToggleIcon(
                isLoading: controller.status.isLoading,
                sound: controller.sound.value,
                onTap: controller.toggleSound,
              ),
            ],
          ),
          onLoading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CentsText(
                diffCents: controller.diffCents.value,
                isActive: controller.isActive.value,
              ),
              TuningGauge(
                diffCents: controller.diffCents.value,
                isActive: controller.isActive.value,
                note: controller.note.value,
                isLoading: controller.status.isLoading,
              ),
              HertzText(
                frequency: controller.frequency.value,
                isActive: controller.isActive.value,
              ),
              SizedBox(height: 30),
              SoundToggleIcon(
                isLoading: controller.status.isLoading,
                sound: controller.sound.value,
                onTap: controller.toggleSound,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
