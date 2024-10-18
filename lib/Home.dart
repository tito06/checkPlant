import 'dart:io';

import 'package:camera/camera.dart';
import 'package:check_plant/DisplayPlantScreen.dart';
import 'package:check_plant/PhotoScreen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    required this.camera,
  });

  final CameraDescription? camera;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final picker = ImagePicker();
  File? _image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Home Screen")),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {
                  if (widget.camera != null) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            TakePhoto(camera: widget.camera!)));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No camera available')),
                    );
                  }
                },
                child: Text("Open camera")),
            TextButton(
                onPressed: () {
                  _pickImage();
                },
                child: Text("Open file"))
          ],
        )));
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery); // or ImageSource.camera
    if (pickedFile != null) {
      setState(() {
        // _image = File(pickedFile.path);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                Displaypicturescreen(imagePath: pickedFile.path)));
      });
    }
  }
}
