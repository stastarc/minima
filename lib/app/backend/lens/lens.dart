import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:minima/app/models/lens/analysis.dart';

import '../environ.dart';

class Lens {
  static Lens? _instance;
  static Lens get instance => _instance ??= Lens();

  Future<AnalysisResultData?> analysis(List<int> image) async {
    var req = MultipartRequest("post",
        await Environ.privateApi(Environ.lensServer, '/lens/analysis/'));
    req.files.add(MultipartFile.fromBytes('image', image,
        contentType: MediaType('image', 'png'), filename: 'image.jpg'));

    return await Environ.tryResponseParse(
        await req.send(), (json) => AnalysisResultData.fromJson(json));
  }
}
