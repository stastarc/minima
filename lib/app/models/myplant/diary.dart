class DiaryData {
  DateTime date;
  String comment;
  List<String> images;

  DiaryData({
    required this.date,
    required this.comment,
    required this.images,
  });

  DiaryData.fromJson(Map<String, dynamic> json)
      : date = DateTime.parse(json['date'] as String),
        comment = json['comment'] as String,
        images =
            (json['images'] as List<dynamic>).map((e) => e as String).toList();
}

class DiariesData {
  final List<DiaryData> diaries;
  final int pageCount;

  DiariesData({
    required this.diaries,
    required this.pageCount,
  });

  DiariesData.fromJson(Map<String, dynamic> json)
      : diaries = (json['diaries'] as List<dynamic>)
            .map((e) => DiaryData.fromJson(e as Map<String, dynamic>))
            .toList(),
        pageCount = json['page_count'] as int;
}
