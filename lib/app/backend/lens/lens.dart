import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image/image.dart';
import 'package:minima/app/models/lens/analysis.dart';

import '../environ.dart';

class Lens {
  static Lens? _instance;
  static Lens get instance => _instance ??= Lens();

  Future<AnalysisResultData?> analysis(List<int> image,
      {bool autoFit = true}) async {
    if (autoFit) {
      final img = fit(image);
      if (img == null) throw Exception('잘못된 이미지 파일입니다.');
      image = img;
    }

    var req = MultipartRequest("post",
        await Environ.privateApi(Environ.lensServer, '/lens/analysis/'));
    req.files.add(MultipartFile.fromBytes('image', image,
        contentType: MediaType('image', 'png'), filename: 'image.jpg'));

    return await Environ.tryResponseParse(
        await req.send(), (json) => AnalysisResultData.fromJson(json));
  }

  List<int>? fit(List<int> img) {
    const size = 2160;
    var image = decodeImage(img);
    if (image == null) return null;
    if (image.width > size || image.height > size) {
      image = copyResize(image,
          width: image.width > image.height ? size : null,
          height: image.width < image.height ? size : null);
    }

    return encodeJpg(image, quality: 80);
  }
}
