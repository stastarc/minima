// product model
// Language: dart

import 'package:tuple/tuple.dart';

class ProductOption {
  final String name;
  final int price;
  final bool important;

  ProductOption({
    required this.name,
    required this.price,
    required this.important,
  });

  ProductOption.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        price = json['price'],
        important = json['important'];
}

class Product {
  final int id;
  final String title;
  final int price;
  final String image;
  final num rating;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.rating,
  });

  Product.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        price = json['price'],
        image = json['image'],
        rating = json['rating'];
}

class ProductDetail {
  final int id;
  final int price;
  final int deliveryPrice;
  final String title;
  final String name;
  final List<Tuple2<String, String>> info;
  final num rating;
  final List<String> images;
  final List<Tuple2<int, String>> components;
  final List<ProductOption> options;
  final String content;

  ProductDetail.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        name = json['name'],
        price = json['price'],
        deliveryPrice = json['delivery_fee'],
        info = productInfoParse(json['info']),
        rating = json['rating'],
        images = List<String>.from(json['images']),
        components = componentParse(json['component']),
        options = List<ProductOption>.from(
            json['options'].map((x) => ProductOption.fromJson(x)).toList()),
        content = json['content'];
}

List<Tuple2<String, String>> productInfoParse(String info) {
  List<Tuple2<String, String>> items = [];
  var lines = info.split('\n');

  for (String line in lines) {
    var start = line.indexOf(':');
    if (start == -1) continue;
    items.add(Tuple2(line.substring(0, start), line.substring(start + 1)));
  }
  return items;
}

List<Tuple2<int, String>> componentParse(String component) {
  List<Tuple2<int, String>> items = [];
  var lines = component.split(',');

  for (String line in lines) {
    var start = line.indexOf(':');
    if (start == -1) continue;
    final count = int.tryParse(line.substring(start + 1));
    if (count == null || count <= 0) continue;
    items.add(Tuple2(count, line.substring(0, start)));
  }
  return items;
}
