import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:get/get.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:pitchupdart/instrument_type.dart';
import 'package:pitchupdart/pitch_handler.dart';

class TunerController extends GetxController with StateMixin {
  // Removes the need to call Get.find() all the time.
  static TunerController get to => Get.find();

  final FlutterAudioCapture _audioRecorder = FlutterAudioCapture();
  final PitchDetector _pitchDetectorDart = PitchDetector(44100, 2000);
  final PitchHandler _pitchupDart = PitchHandler(InstrumentType.guitar);
  final FlutterMidi _midi = FlutterMidi();

  RxDouble diffCents = 0.0.obs;
  RxDouble frequency = 0.0.obs;
  RxString note = "".obs;
  RxBool isActive = false.obs;
  RxInt midiNote = 0.obs;

  // Where the loaded sounds are stored.
  late ByteData _pianoByte;
  late ByteData _synthByte;

  RxBool isPiano = true.obs;

  int getMidiNote(double freq) => (12 * log(freq / 440) / log(2) + 69).toInt();

  Future<void> _loadMidi() async {
    _pianoByte = await rootBundle.load('assets/Piano.sf2');
    _synthByte = await rootBundle.load('assets/Synth.sf2');
    _midi.prepare(sf2: _pianoByte);
  }

  Future<void> changeSound() async {
    _midi.stopMidiNote(midi: midiNote.value);
    if (isPiano.value) {
      _midi.changeSound(sf2: _synthByte);
      isPiano.value = false;
    } else {
      _midi.changeSound(sf2: _pianoByte);
      isPiano.value = true;
    }
    update();
  }

  Future<void> startCapture() async {
    change('loading', status: RxStatus.loading());
    await _loadMidi();
    print("hi");
    await _audioRecorder.start(listener, onError,
        sampleRate: 44100, bufferSize: 3000);
    note.value = "";
    diffCents.value = 0.0;
    frequency.value = 1.0;
    isActive.value = false;
    update();
    change('success', status: RxStatus.success());
  }

  Future<void> stopCapture() async {
    await _audioRecorder.stop();
    note.value = "";
    frequency.value = 1.0;
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
      diffCents.value = -handledPitchResult.diffCents;
      note.value = handledPitchResult.note;
      isActive.value = true;

      int newMidiNote = getMidiNote(frequency.value);
      if (newMidiNote != midiNote.value) {
        _midi.stopMidiNote(midi: midiNote.value);
        midiNote.value = newMidiNote;
        _midi.playMidiNote(midi: midiNote.value);
      }
    } else {
      isActive.value = false;
      _midi.stopMidiNote(midi: midiNote.value);
      midiNote.value = 0;
    }
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
