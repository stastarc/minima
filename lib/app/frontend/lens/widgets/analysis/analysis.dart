import 'dart:typed_data';
import 'package:image/image.dart' as im;

import 'package:flutter/material.dart';
import 'package:minima/app/frontend/lens/widgets/analysis/painter.dart';

class AnalysisAnimationView extends StatefulWidget {
  final double width, height;
  final Uint8List image;

  const AnalysisAnimationView({
    super.key,
    required this.width,
    required this.height,
    required this.image,
  });

  @override
  State createState() => _AnalysisAnimationViewState();
}

class _AnalysisAnimationViewState extends State<AnalysisAnimationView>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  late Animation<double> animation;
  late AnimationController controller;
  late AnalysisPainter painter;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    animation = controller.drive(Tween<double>(begin: 0, end: 1));
    // animation = controller.drive(CurveTween(curve: Curves.easeOut));

    painter = AnalysisPainter(
        width: widget.width,
        height: widget.height,
        image: im.decodeImage(widget.image)!,
        animation: animation);
    controller.repeat();

    _load();
  }

  Future<void> _load() async {
    painter.build();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: CustomPaint(
        painter: painter,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
