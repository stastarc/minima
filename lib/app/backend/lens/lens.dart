import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:minima/app/backend/cdn/cdn.dart';
import 'package:minima/app/models/lens/analysis.dart';

import '../environ.dart';

class Lens {
  static Lens? _instance;
  static Lens get instance => _instance ??= Lens();

  Future<AnalysisResultData?> analysis(List<int> image,
      {bool autoFit = true}) async {
    if (autoFit) {
      final img = CDN.instance.fitImage(image);
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
}
