part of 'painter.dart';

extension AnalysisPainterImage on AnalysisPainter {
  im.Image _fitImage(im.Image image, Size size) {
    final double ratio = image.width / image.height;
    final double targetRatio = size.width / size.height;

    int newWidth = ratio > targetRatio
        ? (size.height * ratio).toInt()
        : size.width.toInt();
    int newHeight =
        ratio > targetRatio ? size.height.toInt() : size.width ~/ ratio;

    return im.copyResize(image, width: newWidth, height: newHeight);
  }

  Uint8List _toRaw(im.Image image) {
    return image.getBytes();
  }

  Future<ui.Image> _toImage(Uint8List raw, Size size) {
    final Completer<ui.Image> completer = Completer();

    ui.decodeImageFromPixels(raw, size.width.toInt(), size.height.toInt(),
        ui.PixelFormat.rgba8888, (result) => completer.complete(result));

    return completer.future;
  }
}
