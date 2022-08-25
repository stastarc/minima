import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minima/app/frontend/lens/pages/analysis.dart';
import 'package:minima/app/frontend/lens/widgets/bottombar.dart';
import 'package:minima/app/frontend/lens/widgets/camera.dart';
import 'package:minima/app/frontend/lens/widgets/topbar.dart';
import 'package:minima/routers/_route.dart';
import 'package:toast/toast.dart';

import 'widgets/grid.dart';

class LensPage extends StatefulWidget {
  const LensPage({super.key});

  @override
  State createState() => _LensPageState();
}

class _LensPageState extends State<LensPage> {
  Future<File?> Function()? _onCamera;
  VoidCallback? _onChange;
  void Function(FlashMode flush)? _flush;

  @override
  void initState() {
    super.initState();
  }

  void onGallery() {}

  void onCamera() async {
    if (_onCamera == null) return;
    try {
      final data = (await _onCamera!())?.readAsBytesSync() ??
          (kDebugMode
              ? (await rootBundle.load('assets/images/dummy/질병.jpg'))
                  .buffer
                  .asUint8List()
              : null);
      if (data == null) return;

      await Navigator.push(context, slideRTL(AnalysisPage(image: data)));
    } catch (e) {
      Toast.show('카메라를 사용할 수 없어요.\n$e', duration: Toast.lengthLong);
      return;
    }
  }

  void onChange() {
    if (_onChange != null) {
      _onChange!();
    }
  }

  void onFlush(FlashMode flush) {
    if (_flush != null) {
      _flush!(flush);
    }
  }

  void onBuilder(VoidCallback change, void Function(FlashMode flush) flush,
      Future<File?> Function() capture) {
    _onCamera = capture;
    _onChange = change;
    _flush = flush;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            top: 52,
            bottom: 130,
            left: 0,
            right: 0,
            child: CameraView(
              onBuilder: onBuilder,
            )),
        ...buildCameraGrid(context),
        Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: TopBarView(
              onFlush: onFlush,
            )),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 130,
          child: BottomBarView(
            onGallery: onGallery,
            onCamera: onCamera,
            onChange: onChange,
          ),
        )
      ],
    );
  }
}
