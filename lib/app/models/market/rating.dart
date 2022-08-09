import 'user.dart';

enum RatingOrderBy {
  last,
  high,
  low,
}

class ProductRating {
  final int id;
  final num rating;
  final String comment;
  final UserInfo? writer;
  final List<String> images;
  final DateTime updatedAt;

  ProductRating({
    required this.id,
    required this.rating,
    required this.comment,
    required this.writer,
    required this.images,
    required this.updatedAt,
  });

  ProductRating.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        rating = json['rating'],
        comment = json['comment'],
        writer =
            json['writer'] == null ? null : UserInfo.fromJson(json['writer']),
        images = List<String>.from(json['images']),
        updatedAt = DateTime.parse(json['updated_at']);
}

class ProductRatings {
  final List<ProductRating> ratings;
  final num average;

  ProductRatings({
    required this.ratings,
    required this.average,
  });

  ProductRatings.fromJson(Map<String, dynamic> json)
      : ratings = List<ProductRating>.from(
            json['ratings'].map((x) => ProductRating.fromJson(x)).toList()),
        average = json['average'];
}
