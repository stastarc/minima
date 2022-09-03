part of 'painter.dart';

extension AnalysisPainterDot on AnalysisPainter {
  void _buildDots(VisionZone vision) {
    dots = Dots(vision, viewScale);
    dots!.fill((55 * scale).toInt());
  }

  void _drawDot(Canvas canvas, Size size) {
    for (final dot in dots!.dots) {
      final transparency = dots!.halfAge > dot.age
          ? dot.age / dots!.halfAge
          : (dots!.maxAge - dot.age) < dots!.halfAge
              ? (dots!.maxAge - dot.age) / dots!.halfAge
              : 1.0;
      final paint = Paint()
        ..color = Colors.white.withOpacity(transparency)
        ..style = PaintingStyle.fill;
      final stroke = Paint()
        ..color = const Color(0xFF13C750).withOpacity(transparency)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawCircle(Offset(dot.x, dot.y), dot.size * scale * 10, paint);
      canvas.drawCircle(Offset(dot.x, dot.y), dot.size * scale * 10, stroke);
    }
  }

  void _dotUpdate(double delta) {
    dots!.update(delta);
  }
}
