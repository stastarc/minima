import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:minima/app/backend/cdn/cdn.dart';
import 'package:minima/app/models/lens/analysis.dart';
import 'package:minima/app/models/lens/credit.dart';

import '../environ.dart';

class Lens {
  static Lens? _instance;
  static Lens get instance => _instance ??= Lens();
  AnalysisCreditData? _credit;

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

    var res = await Environ.tryResponseParse(
        await req.send(), (json) => AnalysisResultData.fromJson(json));

    if (res != null) _credit = res.credit;

    return res;
  }

  Future<AnalysisCreditData?> getCredit() async {
    var res = await Environ.privateGetResopnse(Environ.lensServer,
        '/billing/credits/', (json) => AnalysisCreditData.fromJson(json));
    if (res != null) _credit = res;
    return res;
  }

  Future<AnalysisCreditData?> payCredit(int amount) async {
    var res = await Environ.privatePostResopnse(Environ.lensServer,
        '/billing/pay', (json) => AnalysisCreditData.fromJson(json),
        query: {'amount': amount});
    if (res != null) _credit = res;
    return res;
  }
}
