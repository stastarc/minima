import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';

class CameraView extends StatefulWidget {
  final void Function(VoidCallback change, void Function(FlashMode flush) flush,
      Future<File?> Function() capture) onBuilder;

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
    await cameraController!
        .lockCaptureOrientation(DeviceOrientation.portraitUp);

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
    // return null;
    try {
      if (cameras == null) return null;
      final image = await cameraController!.takePicture();
      return File(image.path);
    } catch (e) {
      Toast.show('카메라를 사용할 수 없어요.\n$e', duration: Toast.lengthLong);
      return null;
    }
  }

  void onFlush(FlashMode flush) async {
    if (cameraController == null) return;
    await cameraController!.setFlashMode(flush);
  }

  @override
  void initState() {
    super.initState();
    initialize();
    widget.onBuilder(onChangeCamera, onFlush, onCapture);
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
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
