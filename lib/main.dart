import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intonize/controllers/tunerController.dart';
import 'package:intonize/views/pages/home/homePage.dart';

void main() async {
  // Initializes the TunerController so we can find it later.
  Get.put(TunerController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Intonize',
      theme: ThemeData(
        fontFamily: 'Gugi',
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
