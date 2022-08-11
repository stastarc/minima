import 'package:minima/app/models/market/product.dart';
import 'package:collection/collection.dart';

class CheckoutCache {
  List<CheckoutItem> items = [];
  CheckoutDeliveryAddress? address;

  CheckoutCache.empty() {
    items = [];
  }

  CheckoutCache.fromJson(Map<String, dynamic> json) {
    items = (json['items'] as List<dynamic>)
        .map((e) => CheckoutItem.fromJson(e))
        .toList();
    address = json['address'] == null
        ? null
        : CheckoutDeliveryAddress.fromJson(json['address']);
  }

  Map<String, dynamic> toJson() => {
        'items': items.map((e) => e.toJson()).toList(),
        'address': address?.toJson(),
      };
}

class CheckoutItem {
  final ProductDetail product;
  final List<bool> options;

  CheckoutItem({
    required this.product,
    required this.options,
  });

  CheckoutItem.fromJson(Map<String, dynamic> json)
      : product = ProductDetail.fromJsonInternal(json['product']),
        options =
            (json['options'] as List<dynamic>).map((e) => e as bool).toList();

  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'options': options,
      };

  int get totalPrice =>
      options.mapIndexed((i, e) => e ? product.options[i].price : 0).sum;

  List<ProductOption> get selectedOptions => List<ProductOption>.from(options
      .mapIndexed((i, e) => e ? product.options[i] : null)
      .where((e) => e != null)
      .toList());
}

class CheckoutDeliveryAddress {
  final String postCode;
  final String address;
  final String detail;

  CheckoutDeliveryAddress({
    required this.postCode,
    required this.address,
    required this.detail,
  });

  CheckoutDeliveryAddress.fromJson(Map<String, dynamic> json)
      : postCode = json['post_code'],
        address = json['address'],
        detail = json['detail'];

  Map<String, dynamic> toJson() => {
        'post_code': postCode,
        'address': address,
        'detail': detail,
      };
}
