import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intonize/controllers/tunerController.dart';
import 'package:intonize/views/pages/home/homePage.dart';

void main() async {
  await Get.putAsync(() => TunerController().init());
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
