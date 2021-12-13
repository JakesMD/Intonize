import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:get/get.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:pitchupdart/instrument_type.dart';
import 'package:pitchupdart/pitch_handler.dart';

enum Sound { piano, synth }
enum Status { loading, loaded, error }

class TunerController extends GetxController with StateMixin<Status> {
  static TunerController get to =>
      Get.find(); // Removes the need to call Get.find() all the time.

  final FlutterAudioCapture _audioRecorder = FlutterAudioCapture();
  final PitchDetector _pitchDetectorDart = PitchDetector(44100, 2000);
  final PitchHandler _pitchupDart = PitchHandler(InstrumentType.guitar);
  final FlutterMidi _midi = FlutterMidi();

  RxDouble diffCents = 0.0.obs;
  RxDouble frequency = 1.0.obs; // default is 1.0 not 0.0 to stop log errors.
  RxString note = "".obs;
  RxBool isActive = false.obs;
  RxInt midiNote = 0.obs;

  late ByteData _pianoByte; // Where the loaded sounds are stored.
  late ByteData _synthByte;
  Rx<Sound> sound = Sound.piano.obs;

  // Calculates the midi note number from the frequency.
  int getMidiNoteFromFrequency(double freq) =>
      (12 * log(freq / 440) / log(2) + 69).toInt();

  @override
  void onInit() {
    startCapture();
    super.onInit();
  }

  Future<void> _loadMidi() async {
    _pianoByte = await rootBundle
        .load('assets/Piano.sf2'); // Loads the sounds from the assets.
    _synthByte = await rootBundle.load('assets/Synth.sf2');
    _midi.prepare(sf2: _pianoByte); // Loads the piano sound.
  }

  Future<void> startCapture() async {
    change(Status.loading, status: RxStatus.loading());
    await _loadMidi(); // Loads the midi sounds.
    print("Hi");
    await _audioRecorder.start(listener, onError,
        sampleRate: 44100, bufferSize: 3000); // Starts listening for notes.
    change(Status.loaded, status: RxStatus.success());
  }

  Future<void> stopCapture() async {
    await _audioRecorder.stop(); // Stops listening.
    // Resets the variables.
    note.value = "";
    frequency.value = 1.0;
    diffCents.value = 0.0;
    isActive.value = false;
    midiNote = 0.obs;
    update();
  }

  void listener(dynamic obj) {
    // Gets the audio sample.
    var buffer = Float64List.fromList(obj.cast<double>());
    final List<double> audioSample = buffer.toList();

    // Uses pitch_detector_dart library to detect a pitch from the audio sample.
    final result = _pitchDetectorDart.getPitch(audioSample);

    // If there is a pitch - evaluate it
    if (result.pitched) {
      final handledPitchResult = _pitchupDart.handlePitch(result.pitch);
      frequency.value = handledPitchResult.expectedFrequency;
      diffCents.value = -handledPitchResult.diffCents;
      note.value = handledPitchResult.note;
      isActive.value = true;

      // Gets the midi note and plays the sound.
      int newMidiNote = getMidiNoteFromFrequency(frequency.value);
      if (newMidiNote != midiNote.value) {
        _midi.stopMidiNote(midi: midiNote.value);
        midiNote.value = newMidiNote;
        _midi.playMidiNote(midi: midiNote.value);
      }
    }
    // If there is no pitch - stop the sound and hide some graphics.
    else {
      isActive.value = false;
      _midi.stopMidiNote(midi: midiNote.value);
      midiNote.value = 0;
    }
    update();
  }

  // Toggles between the midi sounds.
  Future<void> toggleSound() async {
    _midi.stopMidiNote(midi: midiNote.value);
    if (sound.value == Sound.piano) {
      _midi.changeSound(sf2: _synthByte);
      sound.value = Sound.synth;
    } else {
      _midi.changeSound(sf2: _pianoByte);
      sound.value = Sound.piano;
    }
    update();
  }

  void onError(Object e) {
    change(Status.loaded, status: RxStatus.error(e.toString()));
    print(e);
  }

  @override
  void onClose() async {
    await stopCapture();
    super.onClose();
  }
}
