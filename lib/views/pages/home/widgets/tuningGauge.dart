import 'package:flutter/material.dart';
import 'package:intonize/constants/colors.dart';
import 'package:intonize/constants/sizes.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class TuningGauge extends StatelessWidget {
  final double diffCents;
  final String note;
  final bool isActive;

  TuningGauge(
      {Key? key,
      required this.diffCents,
      required this.note,
      this.isActive = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          minimum: -50,
          maximum: 50,
          startAngle: 135,
          endAngle: 45,
          canScaleToFit: true,
          interval: 20,
          majorTickStyle: MajorTickStyle(
            color: AppColors.gaugePrimary,
            length: 4,
          ),
          minorTickStyle: MinorTickStyle(
            color: AppColors.gaugePrimary.withAlpha(150),
            length: 2,
          ),
          minorTicksPerInterval: 1,
          axisLabelStyle:
              GaugeTextStyle(color: AppColors.gaugePrimary, fontFamily: 'Gugi'),
          ranges: <GaugeRange>[
            GaugeRange(
              startValue: -50,
              endValue: -10,
              color: diffCents < -10 && isActive
                  ? AppColors.lowTuning
                  : Colors.transparent,
              startWidth: AppSizes.activeGaugeThickness,
              endWidth: AppSizes.activeGaugeThickness,
            ),
            GaugeRange(
              startValue: -10,
              endValue: 10,
              color: diffCents >= -10 && diffCents <= 10 && isActive
                  ? AppColors.inTune
                  : AppColors.inTune.withAlpha(100),
              startWidth: diffCents >= -10 && diffCents <= 10 && isActive
                  ? AppSizes.activeGaugeThickness
                  : AppSizes.inactiveGaugeThickness,
              endWidth: diffCents >= -10 && diffCents <= 10 && isActive
                  ? AppSizes.activeGaugeThickness
                  : AppSizes.inactiveGaugeThickness,
            ),
            GaugeRange(
              startValue: 10,
              endValue: 50,
              color: diffCents > 10 && isActive
                  ? AppColors.highTuning
                  : Colors.transparent,
              startWidth: AppSizes.activeGaugeThickness,
              endWidth: AppSizes.activeGaugeThickness,
            )
          ],
          axisLineStyle: AxisLineStyle(
            cornerStyle: CornerStyle.bothFlat,
            thickness: AppSizes.inactiveGaugeThickness,
            gradient: SweepGradient(
              colors: <Color>[
                AppColors.lowTuning.withAlpha(150),
                AppColors.highTuning.withAlpha(150),
              ],
              stops: <double>[0, 1],
            ),
          ),
          pointers: <GaugePointer>[
            NeedlePointer(
              value: diffCents,
              needleLength: 0.8,
              needleStartWidth: 7,
              needleEndWidth: 10,
              lengthUnit: GaugeSizeUnit.factor,
              gradient: LinearGradient(
                colors: [
                  AppColors.gaugePrimary.withOpacity(0),
                  isActive
                      ? AppColors.gaugePrimary
                      : AppColors.gaugePrimary.withOpacity(0),
                ],
                stops: <double>[0, 0.75],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              knobStyle: KnobStyle(
                knobRadius: 0.0,
                sizeUnit: GaugeSizeUnit.factor,
              ),
            ),
          ],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              angle: 90,
              positionFactor: 0.4,
              widget: Text(
                isActive ? note : '',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                  color: AppColors.gaugePrimary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
