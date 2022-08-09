import 'user.dart';

class ProductQnA {
  final int id;
  final int productId;
  final UserInfo? writer;
  final String content;
  final String? answer;
  final DateTime? answeredAt;
  final DateTime uploadedAt;

  ProductQnA({
    required this.id,
    required this.productId,
    required this.writer,
    required this.content,
    required this.answer,
    required this.answeredAt,
    required this.uploadedAt,
  });

  ProductQnA.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        productId = json['product_id'],
        writer =
            json['writer'] == null ? null : UserInfo.fromJson(json['writer']),
        content = json['content'],
        answer = json['answer'],
        answeredAt = json['answered_at'] == null
            ? null
            : DateTime.parse(json['answered_at']),
        uploadedAt = DateTime.parse(json['uploaded_at']);
}
