import 'dart:math';
import 'dart:ui';

import 'package:minima/app/frontend/lens/widgets/analysis/vision.dart';

const minDifference = 10;

final random = Random();

class Dot {
  double x;
  double y;
  double size;
  double age;
  double speed;

  Dot(this.x, this.y, this.size, [this.age = 0, this.speed = 1]);
}

class Dots {
  final int maxAge = 80;
  final int fadeR = 4;
  final VisionZone vision;
  final double scale;
  late List<Dot> dots;
  late int halfAge;

  Dots(this.vision, this.scale) {
    dots = [];
    halfAge = maxAge ~/ fadeR;
  }

  Offset get randomOffset {
    while (true) {
      final x = random.nextDouble() * vision.rect.width + vision.rect.left;
      final y = random.nextDouble() * vision.rect.height + vision.rect.top;

      if (vision.scoreBoolean(x.toInt(), y.toInt(), minDifference)) {
        return Offset(x, y);
      }
    }
  }

  void fill(int count) {
    dots.clear();
    for (var i = 0; i < count; i++) {
      final offset = randomOffset;
      dots.add(Dot(
          offset.dx * scale,
          offset.dy * scale,
          (random.nextDouble() * .2 + 0.3) * scale,
          random.nextDouble() * 0.2 + .8));
    }
  }

  void respawn(Dot dot) {
    final offset = randomOffset;
    dot.x = offset.dx * scale;
    dot.y = offset.dy * scale;
    dot.age = 0;
    dot.speed = random.nextDouble();
  }

  void update(double delta) {
    for (var dot in dots) {
      dot.age += delta * dot.speed;

      if (dot.age >= maxAge) {
        respawn(dot);
      }
    }
  }
}
