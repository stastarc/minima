import 'package:intl/intl.dart';

final _currencyFormat =
    NumberFormat.simpleCurrency(locale: "ko_KR", name: "", decimalDigits: 0);
final _ratingFormat = NumberFormat("###.0");

final _dateFormat = DateFormat("yyyy.MM.dd");
final _deliveryDateFormat = DateFormat("M/d");

String currencyFormat(int price) {
  return _currencyFormat.format(price);
}

String ratingFormat(num rating) {
  return _ratingFormat.format(rating);
}

String dateFormat(DateTime date) {
  return _dateFormat.format(date);
}

String deliveryDateFormat(DateTime date) {
  return _deliveryDateFormat.format(date);
}
