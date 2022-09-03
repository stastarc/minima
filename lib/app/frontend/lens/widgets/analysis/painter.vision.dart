part of 'painter.dart';

extension AnalysisPainterVision on AnalysisPainter {
  static const positionChunkSize = 92,
      viewChunkSize = 128,
      minLightness = 100,
      minDifference = 10;
  static const int R = 0, G = 1, B = 2, A = 3;

  void _buildVision(im.Image image, Size viewSize) {
    image = _fitImage(image, Size(width, height));
    final isVertical =
        (image.width - viewSize.width) < (image.height - viewSize.height);
    final isViewVertical = viewSize.width < viewSize.height;
    final vsize = isVertical ? viewSize.height : viewSize.width;
    final psizeW = isVertical ? 1 : positionChunkSize,
        psizeH = isVertical ? positionChunkSize : 1;
    var zone = VisionZone.colorZone(
        _toRaw(im.copyResize(image, width: psizeW, height: psizeH)),
        psizeW,
        psizeH,
        4,
        G,
        minLightness: minLightness,
        minDifference: minDifference);

    final offset = zone.isEmpty ? null : zone.max().item1;
    final position = offset == null
        ? 0.5
        : isVertical
            ? offset.dy / positionChunkSize
            : offset.dx / positionChunkSize;
    final absolutePosition = vsize * position - vsize / 2;

    final viewImage = im.copyCrop(
        image,
        isVertical ? 0 : absolutePosition.toInt(),
        isVertical ? absolutePosition.toInt() : 0,
        viewSize.width.toInt(),
        viewSize.height.toInt());
    final vsizeWs = isViewVertical ? viewSize.width / viewSize.height : 1,
        vsizeHs = isViewVertical ? 1 : viewSize.height / viewSize.width,
        vsizeW = (vsizeWs * viewChunkSize).toInt(),
        vsizeH = (vsizeHs * viewChunkSize).toInt();
    zone = VisionZone.colorZone(
        _toRaw(im.copyResize(viewImage, width: vsizeW, height: vsizeH)),
        vsizeW,
        vsizeH,
        4,
        G,
        minLightness: minLightness,
        minDifference: minDifference);

    vision = zone;
    viewScale = max(viewSize.width, viewSize.height) / viewChunkSize;

    _toImage(_toRaw(viewImage), Size(viewSize.width, viewSize.height))
        .then((img) => this.viewImage = img);
  }
}
