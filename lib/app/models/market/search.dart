import 'package:minima/app/models/market/product.dart';

enum ProductSearchMode { full, tag, name }

class ProductSearch {
  final String query;
  final List<Product> products;
  final int page;
  final int size;

  ProductSearch({
    required this.query,
    required this.products,
    required this.page,
    required this.size,
  });

  ProductSearch.empty()
      : query = '',
        products = [],
        page = 0,
        size = 0;

  ProductSearch.fromJson(Map<String, dynamic> json)
      : query = json['query'],
        products = (json['products'] as List<dynamic>)
            .map((e) => Product.fromJson(e))
            .toList(),
        page = json['page'],
        size = json['size'];
}
