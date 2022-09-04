import 'package:minima/app/backend/environ.dart';
import 'package:minima/app/models/market/feed.dart';
import 'package:minima/app/models/market/product.dart';
import 'package:minima/app/models/market/qna.dart';
import 'package:minima/app/models/market/rating.dart';
import 'package:minima/app/models/market/recommended.dart';
import 'package:minima/app/models/market/search.dart';

part 'market.api.dart';

class Market {
  static Market? _instance;
  static Market get instance => _instance ??= Market();

  final int freeDelivery = 50000;

  List<FeedPart>? _feedParts;
  DateTime? cachedAt;

  Future<List<FeedPart>> getCachedFeeds() async {
    if (_feedParts == null ||
        cachedAt == null ||
        cachedAt!.isBefore(DateTime.now().subtract(const Duration(hours: 1)))) {
      _feedParts = await getFeeds();
      cachedAt = DateTime.now();
    }

    return _feedParts!;
  }
}
