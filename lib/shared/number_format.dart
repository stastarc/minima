import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const locale = 'ko_KR';

final _currencyFormat =
    NumberFormat.simpleCurrency(locale: locale, name: "", decimalDigits: 0);
final _ratingFormat = NumberFormat("###.0", locale);
final _detaildFormat = NumberFormat("###.00", locale);

final _dateFormat = DateFormat("yyyy.MM.dd", locale);
final _longDateFormat = DateFormat("yyyy. M. d. (E)", locale);
final _isoDateFormat = DateFormat("yyyy-MM-dd");
final _deliveryDateFormat = DateFormat("M/d", locale);
final _weekDateFormat = DateFormat("E", locale);
final _monthDateFormat = DateFormat("MMMM", locale);

String currencyFormat(int price) {
  return _currencyFormat.format(price);
}

String ratingFormat(num rating) {
  return _ratingFormat.format(rating);
}

String detaildFormat(num rating) {
  return _detaildFormat.format(rating);
}

String dateFormat(DateTime date) {
  return _dateFormat.format(date);
}

String longDateFormat(DateTime date) {
  return _longDateFormat.format(date);
}

String deliveryDateFormat(DateTime date) {
  return _deliveryDateFormat.format(date);
}

String weekDateFormat(DateTime date) {
  return _weekDateFormat.format(date);
}

String monthDateFormat(DateTime date) {
  return _monthDateFormat.format(date);
}

String isoDateFormat(DateTime date) {
  return _isoDateFormat.format(date);
}

String timeFormat(Duration time) {
  final isAM = time.inHours < 12;
  return "${isAM ? "오전" : "오후"} ${time.inHours % 12}:${(time.inMinutes % 60).toString().padLeft(2, "0")}";
}

bool colorIsLight(Color color) {
  final r = color.red;
  final g = color.green;
  final b = color.blue;
  final brightness = (r * 299 + g * 587 + b * 114) / 1000;
  return brightness > 125;
}
