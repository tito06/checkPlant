import 'package:camera/camera.dart';
import 'package:check_plant/DisplayPlantScreen.dart';
import 'package:flutter/material.dart';

class TakePhoto extends StatefulWidget {
  const TakePhoto({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  State<TakePhoto> createState() => _TakePhotoState();
}

class _TakePhotoState extends State<TakePhoto> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Camera"),
      ),
      body: FutureBuilder(
          future: _initializeControllerFuture,
          builder: (context, snapShot) {
            if (snapShot.connectionState == ConnectionState.done) {
              return CameraPreview(_controller);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();

            if (!context.mounted) return;

            await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    Displaypicturescreen(imagePath: image.path)));
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt_outlined),
      ),
    );
  }
}
