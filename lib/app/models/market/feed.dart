import 'package:minima/app/models/market/product.dart';

enum FeedSearchType { tag, name }

class FeedPart {
  final String title;
  final FeedSearchType searchType;
  final String content;
  final List<Product> products;

  FeedPart.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        searchType = FeedSearchType.values.firstWhere(
            (e) => e.toString().contains('.${json['search_type']}')),
        content = json['content'],
        products = (json['products'] as List<dynamic>)
            .map((e) => Product.fromJson(e))
            .toList();
}
