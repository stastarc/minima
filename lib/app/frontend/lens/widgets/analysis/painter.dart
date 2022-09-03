import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as im;
import 'package:minima/app/frontend/lens/widgets/analysis/dot.dart';

import 'package:minima/app/frontend/lens/widgets/analysis/vision.dart';
import 'package:minima/shared/number_format.dart';

part 'painter.image.dart';
part 'painter.vision.dart';
part 'painter.dot.dart';

class AnalysisPainter extends CustomPainter {
  static const baseRR = 1000 / 60.0;
  final stopwatch = Stopwatch();
  final double width, height;

  late double scale, viewScale;

  int frame = 0, fps = 0, frameElapsedTime = 0;
  Animation<double> animation;
  ui.Image? viewImage;
  VisionZone? vision;
  Dots? dots;
  bool isPainting = false;

  AnalysisPainter(
      {required this.animation,
      required this.width,
      required this.height,
      required image})
      : super(repaint: animation) {
    scale = width * height / (720 * 360);
    _buildVision(image, Size(width, height));
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (viewImage == null) return;
    if (isPainting) return;
    isPainting = true;
    if (dots == null) _buildDots(vision!);
    stopwatch.stop();
    frameElapsedTime += stopwatch.elapsedMilliseconds;
    final delta = min(stopwatch.elapsedMilliseconds, 999) / baseRR;
    try {
      _dotUpdate(delta);

      canvas.drawImage(viewImage!, Offset.zero, Paint());

      _drawDot(canvas, size);
      frame++;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      isPainting = false;
    }
    if (kDebugMode) {
      TextPainter tp = TextPainter(
          text: TextSpan(
              style: const TextStyle(
                  color: Colors.white,
                  backgroundColor: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
              text:
                  'FPS: $fps\nDelta: ${detaildFormat(delta).padLeft(4, '0')}'),
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, const Offset(5.0, 5.0));
      if (frameElapsedTime > 1000) {
        frameElapsedTime = 0;
        fps = frame;
        frame = 0;
      }
    }
    stopwatch.reset();
    stopwatch.start();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
