enum RatingOrderBy {
  last,
  high,
  low,
}

class ProductRating {
  final int id;
  final num rating;
  final String comment;
  final List<String> images;
  final DateTime updatedAt;

  ProductRating({
    required this.id,
    required this.rating,
    required this.comment,
    required this.images,
    required this.updatedAt,
  });

  ProductRating.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        rating = json['rating'],
        comment = json['comment'],
        images = List<String>.from(json['images']),
        updatedAt = DateTime.parse(json['updated_at']);
}
