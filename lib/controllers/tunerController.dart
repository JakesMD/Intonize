import 'dart:typed_data';

import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:get/get.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:pitchupdart/instrument_type.dart';
import 'package:pitchupdart/pitch_handler.dart';

class TunerController extends GetxController {
  final _audioRecorder = FlutterAudioCapture();
  final _pitchDetectorDart = PitchDetector(44100, 2000);
  final _pitchupDart = PitchHandler(InstrumentType.guitar);

  RxDouble diffCents = 0.0.obs;
  RxDouble frequency = 0.0.obs;
  RxString note = "".obs;
  RxInt octave = 0.obs;
  RxBool isActive = false.obs;

  Future<TunerController> init() async {
    return this;
  }

  Future<void> startCapture() async {
    await _audioRecorder.start(listener, onError,
        sampleRate: 44100, bufferSize: 3000);
    note.value = "";
    diffCents.value = 0.0;
    frequency.value = 0.0;
    isActive.value = false;
    update();
  }

  Future<void> stopCapture() async {
    await _audioRecorder.stop();
    note.value = "";
    frequency.value = 0.0;
    diffCents.value = 0.0;
    isActive.value = false;
    update();
  }

  void listener(dynamic obj) {
    //Gets the audio sample
    var buffer = Float64List.fromList(obj.cast<double>());
    final List<double> audioSample = buffer.toList();

    //Uses pitch_detector_dart library to detect a pitch from the audio sample
    final result = _pitchDetectorDart.getPitch(audioSample);

    //If there is a pitch - evaluate it
    if (result.pitched) {
      //Uses the pitchupDart library to check a given pitch for a Guitar
      final handledPitchResult = _pitchupDart.handlePitch(result.pitch);
      frequency.value = handledPitchResult.expectedFrequency;
      diffCents.value = handledPitchResult.diffCents;
      note.value = handledPitchResult.note;
      isActive.value = true;
    } else
      isActive.value = false;
    update();
  }

  void onError(Object e) {
    print(e);
  }

  @override
  void onClose() {
    stopCapture();
    super.onClose();
  }
}
