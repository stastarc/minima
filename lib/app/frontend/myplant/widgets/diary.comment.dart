import 'dart:math';

const Map<String?, List<String>> comments = {
  null: [
    '%의 오늘 모습이에요+',
    '새 이파리가 자라고있어요+',
    '예쁘게 자라고있어요+',
    '%의 먼지를 닦아줬어요+',
    '조금씩 잎이 커지고있어요+',
    '새 잎이 나오고있어요+'
  ],
  'water': [
    '오늘은 %에게 물을 줬어요+',
    '%에게 시원하게 목욕시켜줬어요+',
    '%에게 시원하게 목욕시켜줬어요+',
    '%에게 시원하게 물을 줬어요+',
    '물을 듬뿍 줬어요+',
    '%에게 물을 줬어요+',
  ],
  'prune': ['오늘은 잎을 정리 해줬어요+', '잎을 단정하게 잘라줬어요+', '꼬불꼬불 이파리가 자라고있어요+'],
  'fertilize': [
    '%에게 영영제를 줬어요+',
    '영영제를 줬어요+',
    '%에게 영영제를 줬어요. 무럭무럭 자라라렴+',
  ],
  'repot': [
    '화분이 작아보여서 옮겨줬어요+',
    '분갈이를 해줬어요+',
    '흙을 갈아줬어요+',
  ]
};

final _rand = Random();

String buildString(String comment, String plantName) {
  final builder = StringBuffer();

  for (var i = 0; i < comment.length; i++) {
    final c = comment[i];

    if (c == '%') {
      builder.write(plantName);
    } else if (c == '+') {
      builder.write(_rand.nextBool() ? '!' : '.');
    } else {
      builder.write(c);
    }
  }

  return builder.toString();
}

String getComment(String plantName, List<String> schedules) {
  String? keyword;

  if (schedules.isNotEmpty) {
    for (var i = 0; i < schedules.length; i++) {
      keyword = schedules[_rand.nextInt(schedules.length)];
      if (comments.containsKey(keyword)) break;
    }
  }

  final builder = StringBuffer();
  final keywords = comments[keyword]!;

  builder
      .write(buildString(keywords[_rand.nextInt(keywords.length)], plantName));

  if (keyword != null && _rand.nextBool()) {
    final defKeywords = comments[null]!;

    if (defKeywords.isNotEmpty) {
      builder.write(' ');
      builder.write(buildString(
          defKeywords[_rand.nextInt(defKeywords.length)], plantName));
    }
  }

  return builder.toString();
}
