import 'package:app/screen/getstart.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

void main() {
  var devicePre = true;

  if (devicePre) {
    runApp(DevicePreview(
      //enabled: !kReleaseMode,
      builder: (context) => const MyApp(),
    ));
    // ignore: dead_code
  } else {
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpineCare+',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const GetStartedScreen(),
    );
  }
}
