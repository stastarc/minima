import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraView extends StatefulWidget {
  final void Function(VoidCallback change, Future<File?> Function() capture)
      onBuilder;

  const CameraView({super.key, required this.onBuilder});

  @override
  State createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  List<CameraDescription>? cameras;
  CameraController? cameraController;
  int cameraIndex = 0;
  bool isLoading = false;

  Future<void> initialize() async {
    if (isLoading) return;
    isLoading = true;
    setState(() {});

    cameras ??= await availableCameras();
    final camera = cameras![cameraIndex];

    cameraController = CameraController(
      camera,
      ResolutionPreset.ultraHigh,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    await cameraController!.initialize();
    setState(() {
      isLoading = false;
    });
  }

  void onChangeCamera() {
    if (cameras == null) return;
    cameraIndex = ++cameraIndex < cameras!.length ? cameraIndex : 0;
    initialize();
  }

  Future<File?> onCapture() async {
    return null;
    if (cameras == null) return null;
    final image = await cameraController!.takePicture();
    return File(image.path);
  }

  @override
  void initState() {
    super.initState();
    initialize();
    widget.onBuilder(onChangeCamera, onCapture);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Ink(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black,
          )
        : CameraPreview(cameraController!);
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }
}
