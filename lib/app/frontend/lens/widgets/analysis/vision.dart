import 'dart:typed_data';
import 'package:flutter/painting.dart';
import 'package:image/image.dart' as im;
import 'package:tuple/tuple.dart';

// TODO: migrate to C language

class VisionZone {
  final Uint8List data;
  final Rect rect;
  final int width;
  final int height;

  VisionZone(this.data, this.rect, this.width, this.height);

  bool get isEmpty => data.isEmpty;

  double get loss => (rect.width + rect.height) / (width + height);

  int score(int x, int y) {
    var index = y * width + x;
    return data[index];
  }

  bool scoreBoolean(int x, int y, int n) {
    final c = score(x, y);
    return c > n;
  }

  Tuple2<Offset, int> max() {
    var max = 0, maxX = 0, maxY = 0;
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        var s = score(x, y);
        if (s > max) {
          max = s;
          maxX = x;
          maxY = y;
        }
      }
    }
    return Tuple2(Offset(maxX.toDouble(), maxY.toDouble()), max);
  }

  static VisionZone get empty => VisionZone(Uint8List(0), Rect.zero, 0, 0);

  factory VisionZone.colorZone(
    Uint8List image,
    int width,
    int height,
    int elementSize,
    int elementIndex, {
    minLightness = 0,
    minDifference = 0,
  }) {
    List<int> data = [];
    var x1 = -1, y1 = -1, x2 = -1, y2 = -1;

    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        var i = (y * width + x) * elementSize,
            tc = image[i + elementIndex],
            dr = elementIndex == 0 ? double.infinity : tc - image[i],
            dg = elementIndex == 1 ? double.infinity : tc - image[i + 1],
            db = elementIndex == 2 ? double.infinity : tc - image[i + 2];

        if (tc < minLightness ||
            dr < minDifference ||
            dg < minDifference ||
            db < minDifference) {
          data.add(0);
        } else {
          data.add((tc +
                  (elementIndex == 0 ? 0 : dr) +
                  (elementIndex == 1 ? 0 : dg) +
                  (elementIndex == 2 ? 0 : db) / 3)
              .round());

          if (x1 == -1 || x1 > x) {
            x1 = x;
          } else if (x2 < x) {
            x2 = x;
          }

          if (y1 == -1) {
            y1 = y;
          } else if (y2 < y) {
            y2 = y;
          }
        }
      }
    }

    if (x1 == -1) {
      return VisionZone.empty;
    }

    return VisionZone(
      Uint8List.fromList(data),
      Rect.fromLTRB(x1.toDouble(), y1.toDouble(), x2.toDouble(), y2.toDouble()),
      width,
      height,
    );
  }
}
