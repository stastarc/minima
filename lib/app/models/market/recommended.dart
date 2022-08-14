class RecommendedItem {
  final int goto;
  final String image;
  final String name;
  final String content;

  const RecommendedItem({
    required this.goto,
    required this.image,
    required this.name,
    required this.content,
  });

  RecommendedItem.fromJson(Map<String, dynamic> json)
      : goto = json['goto'],
        image = json['image'],
        name = json['name'],
        content = json['content'];
}

class Recommended {
  final int id;
  final String title;
  final String content;
  final List<RecommendedItem> items;
  final bool isEnd;

  const Recommended({
    required this.id,
    required this.title,
    required this.content,
    required this.items,
    required this.isEnd,
  });

  Recommended.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        content = json['content'],
        items = (json['items'] as List)
            .map((item) => RecommendedItem.fromJson(item))
            .toList(),
        isEnd = json['is_end'];
}
