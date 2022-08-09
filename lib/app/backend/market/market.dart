import 'package:http/src/response.dart';
import 'package:minima/app/backend/environ.dart';
import 'package:minima/app/models/market/feed.dart';
import 'package:minima/app/models/market/product.dart';
import 'package:minima/app/models/market/qna.dart';
import 'package:minima/app/models/market/rating.dart';

class Market {
  static Market? _instance;
  static Market get instance => _instance ??= Market();

  Future<ProductDetail?> getProductDetail(int productId) async {
    return await Environ.privateGetResopnse(Environ.marketServer,
        '/market/products/$productId', (json) => ProductDetail.fromJson(json));
  }

  Future<List<FeedPart>?> getFeeds() async {
    return await Environ.privateGetResopnse(
        Environ.marketServer,
        '/market/feed',
        (json) =>
            (json as List<dynamic>).map((e) => FeedPart.fromJson(e)).toList());
  }

  Future<ProductRatings?> getProductRatings(int productId,
      {int offset = 0, RatingOrderBy orderby = RatingOrderBy.high}) async {
    return await Environ.privateGetResopnse(
        Environ.marketServer,
        'market/products/$productId/reviews',
        (json) => ProductRatings.fromJson(json),
        query: {
          'offset': offset,
          'orderby': orderby.toString().split('.').last,
        });
  }

  Future<List<ProductQnA>?> getProductQnAs(int productId) async {
    return await Environ.privateGetResopnse(
        Environ.marketServer,
        '/market/products/$productId/qnas',
        (json) => (json as List<dynamic>)
            .map((e) => ProductQnA.fromJson(e))
            .toList());
  }

  Future<int?> writeQnA(int productId, String content) async {
    return await Environ.privatePostResopnse(Environ.marketServer,
        '/market/products/$productId/qnas', (json) => json['qna']['id'] as int,
        body: {'content': content});
  }
}
