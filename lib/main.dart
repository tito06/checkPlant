import 'package:camera/camera.dart';
import 'package:check_plant/Home.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final cameras = await availableCameras();
    final firstCamera = cameras.isNotEmpty ? cameras.first : null;

    runApp(MaterialApp(home: MyApp(camera: firstCamera)));
  } catch (e) {
    runApp(const MaterialApp(home: MyApp(camera: null))); // No camera available
  }
}



// api key : 2b10v5D6z5k5Wianu4J4RugTJ