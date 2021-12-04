import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intonize/constants/colors.dart';
import 'package:intonize/controllers/tunerController.dart';
import 'package:intonize/views/pages/home/widgets/tuningGauge.dart';

class HomePage extends StatelessWidget {
  final TunerController _tunerController = Get.find();

  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homePage,
      body: Center(
        child: GetBuilder<TunerController>(
            initState: (_) => _tunerController.startCapture(),
            builder: (_) {
              final double frequency = _tunerController.frequency.value;
              final double diffCents = _tunerController.diffCents.value;
              final bool isActive = _tunerController.isActive.value;
              final String note = _tunerController.note.value;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    diffCents.toInt().toString() + '¢',
                    style:
                        TextStyle(color: AppColors.gaugePrimary, fontSize: 24),
                  ),
                  TuningGauge(
                    diffCents: diffCents,
                    isActive: isActive,
                    note: note,
                  ),
                  Text(
                    frequency.toInt().toString() + ' Hz',
                    style: TextStyle(color: Colors.white.withAlpha(150)),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
