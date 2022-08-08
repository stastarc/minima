import 'package:minima/app/backend/environ.dart';
import 'package:minima/app/models/market/feed.dart';
import 'package:minima/app/models/market/product.dart';
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

  Future<List<ProductRating>?> getProductRatings(int productId,
      {int offset = 0, RatingOrderBy orderby = RatingOrderBy.high}) async {
    return await Environ.privateGetResopnse(
        Environ.marketServer,
        'market/products/$productId/reviews',
        (json) => (json as List<dynamic>)
            .map((e) => ProductRating.fromJson(e))
            .toList(),
        query: {
          'offset': offset,
          'orderby': orderby.toString().split('.').last,
        });
  }
}
