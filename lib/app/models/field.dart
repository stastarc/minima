import 'package:flutter/material.dart';

class LoclizedField {
  final Map<String, String> data;

  LoclizedField({
    required this.data,
  });

  String localized(BuildContext context) =>
      data[Localizations.localeOf(context).languageCode] ?? '알수없음';

  String? get ko => data['ko'];
  String? get en => data['en'];
  String? get zh => data['zh'];
  String? get ja => data['ja'];

  factory LoclizedField.fromJson(Map<String, dynamic> names) {
    return LoclizedField(data: Map<String, String>.from(names));
  }
}

class LinkedField {
  final String word;
  final String type;
  final String link;

  LinkedField({
    required this.word,
    required this.type,
    required this.link,
  });

  factory LinkedField.fromJson(Map<String, dynamic> json) {
    return LinkedField(
      word: json['word'] as String,
      type: json['type'] as String,
      link: json['link'] as String,
    );
  }
}
