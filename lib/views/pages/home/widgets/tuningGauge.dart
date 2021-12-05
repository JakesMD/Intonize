import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intonize/constants/colors.dart';
import 'package:intonize/constants/numbers.dart';
import 'package:intonize/constants/sizes.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class TuningGauge extends StatelessWidget {
  final double diffCents;
  final String note;
  final bool isActive;
  final bool isLoading;

  TuningGauge({
    Key? key,
    required this.diffCents,
    required this.note,
    this.isActive = false,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          startAngle: 135,
          endAngle: 45,
          canScaleToFit: true,
          minimum: -AppNumbers.gaugeValue,
          maximum: AppNumbers.gaugeValue,
          interval: AppNumbers.gaugeInterval,
          majorTickStyle: MajorTickStyle(
            color: AppColors.gaugePrimary,
            length: 4,
          ),
          minorTickStyle: MinorTickStyle(
            color: AppColors.gaugePrimary.withAlpha(AppColors.inactiveAlpha),
            length: 2,
          ),
          minorTicksPerInterval: 1,
          axisLabelStyle: GaugeTextStyle(
            color: AppColors.gaugePrimary,
            fontFamily: 'Gugi',
          ),
          axisLineStyle: AxisLineStyle(
            cornerStyle: CornerStyle.bothFlat,
            thickness: AppSizes.inactiveGaugeThickness,
            gradient: SweepGradient(
              colors: <Color>[
                AppColors.lowTuning.withAlpha(AppColors.inactiveAlpha),
                AppColors.highTuning.withAlpha(AppColors.inactiveAlpha),
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
                stops: <double>[0.25, 0.75],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              knobStyle: KnobStyle(
                knobRadius: 0.0,
                sizeUnit: GaugeSizeUnit.factor,
              ),
            ),
          ],
          ranges: <GaugeRange>[
            // Too low range
            GaugeRange(
              startValue: -AppNumbers.gaugeValue,
              endValue: -AppNumbers.gaugeInTuneValue,
              color: diffCents < -AppNumbers.gaugeInTuneValue && isActive
                  ? AppColors.lowTuning
                  : Colors.transparent,
              startWidth: AppSizes.activeGaugeThickness,
              endWidth: AppSizes.activeGaugeThickness,
            ),

            // In tune range
            GaugeRange(
              startValue: -AppNumbers.gaugeInTuneValue,
              endValue: AppNumbers.gaugeInTuneValue,
              color: diffCents >= -AppNumbers.gaugeInTuneValue &&
                      diffCents <= AppNumbers.gaugeInTuneValue &&
                      isActive
                  ? AppColors.inTune
                  : AppColors.inTune.withAlpha(AppColors.inactiveAlpha),
              startWidth: diffCents >= -AppNumbers.gaugeInTuneValue &&
                      diffCents <= AppNumbers.gaugeInTuneValue &&
                      isActive
                  ? AppSizes.activeGaugeThickness
                  : AppSizes.inactiveGaugeThickness,
              endWidth: diffCents >= -AppNumbers.gaugeInTuneValue &&
                      diffCents <= AppNumbers.gaugeInTuneValue &&
                      isActive
                  ? AppSizes.activeGaugeThickness
                  : AppSizes.inactiveGaugeThickness,
            ),

            // Too high range
            GaugeRange(
              startValue: AppNumbers.gaugeInTuneValue,
              endValue: AppNumbers.gaugeValue,
              color: diffCents > AppNumbers.gaugeInTuneValue && isActive
                  ? AppColors.highTuning
                  : Colors.transparent,
              startWidth: AppSizes.activeGaugeThickness,
              endWidth: AppSizes.activeGaugeThickness,
            )
          ],
          annotations: <GaugeAnnotation>[
            // Note text
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
            // Loading indicator
            GaugeAnnotation(
              angle: 90,
              positionFactor: 0.0,
              widget: isLoading
                  ? SpinKitWave(
                      color: AppColors.primary,
                      size: 50,
                    )
                  : Container(),
            ),
          ],
        ),
      ],
    );
  }
}
