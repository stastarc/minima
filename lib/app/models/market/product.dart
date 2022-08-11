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

  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
        'important': important,
      };
}

class Product {
  final int id;
  final String title;
  final String name;
  final int price;
  final String image;
  final num rating;

  const Product({
    required this.id,
    required this.title,
    required this.name,
    required this.price,
    required this.image,
    required this.rating,
  });

  Product.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        name = json['name'],
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

  ProductDetail.fromJsonInternal(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        name = json['name'],
        price = json['price'],
        deliveryPrice = json['deliveryPrice'],
        info = List<dynamic>.from(json['info'])
            .map((e) => Tuple2(e[0] as String, e[1] as String))
            .toList(),
        rating = json['rating'],
        images = List<String>.from(json['images']),
        components = List<dynamic>.from(json['components'])
            .map((e) => Tuple2(e[0] as int, e[1] as String))
            .toList(),
        options = List<dynamic>.from(json['options'])
            .map((e) => ProductOption.fromJson(e))
            .toList(),
        content = json['content'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'name': name,
        'price': price,
        'deliveryPrice': deliveryPrice,
        'info': info.map((e) => [e.item1, e.item2]).toList(),
        'rating': rating,
        'images': images,
        'components': components.map((e) => [e.item1, e.item2]).toList(),
        'options': options,
        'content': content,
      };
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
