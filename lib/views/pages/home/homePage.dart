import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intonize/constants/colors.dart';
import 'package:intonize/controllers/tunerController.dart';
import 'package:intonize/views/pages/home/widgets/centsText.dart';
import 'package:intonize/views/pages/home/widgets/hertzText.dart';
import 'package:intonize/views/pages/home/widgets/soundToggleIcon.dart';
import 'package:intonize/views/pages/home/widgets/tuningGauge.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homePage,
      body: Center(
        child: GetBuilder<TunerController>(
          initState: (_) => TunerController.to.startCapture(),
          builder: (_) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CentsText(
                diffCents: TunerController.to.diffCents.value,
                isActive: TunerController.to.isActive.value,
              ),
              TuningGauge(
                diffCents: TunerController.to.diffCents.value,
                isActive: TunerController.to.isActive.value,
                note: TunerController.to.note.value,
                isLoading: TunerController.to.status == RxStatus.loading(),
              ),
              HertzText(
                frequency: TunerController.to.frequency.value,
                isActive: TunerController.to.isActive.value,
              ),
              SizedBox(height: 30),
              SoundToggleIcon(
                isLoading: TunerController.to.status == RxStatus.loading(),
                isPiano: TunerController.to.isPiano.value,
                onTap: TunerController.to.changeSound,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
