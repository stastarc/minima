import 'dart:io';

import 'package:flutter/material.dart';
import 'package:minima/app/frontend/lens/pages/analysis.dart';
import 'package:minima/app/frontend/lens/widgets/bottombar.dart';
import 'package:minima/app/frontend/lens/widgets/camera.dart';
import 'package:minima/app/frontend/lens/widgets/topbar.dart';
import 'package:minima/routers/_route.dart';

import 'widgets/grid.dart';

class LensPage extends StatefulWidget {
  const LensPage({super.key});

  @override
  State createState() => _LensPageState();
}

class _LensPageState extends State<LensPage> {
  Future<File?> Function()? _onCamera;
  VoidCallback? _onChange;

  @override
  void initState() {
    super.initState();
  }

  void onGallery() {}

  void onCamera() async {
    if (_onCamera == null) return;
    _onCamera!().then((image) {
      // if (image == null) return;
      Navigator.push(context, slideRTL(AnalysisPage(image: image)));
    });
  }

  void onChange() {
    if (_onChange != null) {
      _onChange!();
    }
  }

  void onBuilder(VoidCallback change, Future<File?> Function() capture) {
    _onCamera = capture;
    _onChange = change;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: CameraView(
            onBuilder: onBuilder,
          ),
        ),
        ...buildCameraGrid(context),
        // const Positioned(top: 0, left: 0, right: 0, child: CameraGrid()),
        const Positioned(top: 0, left: 0, right: 0, child: TopBarView()),
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
