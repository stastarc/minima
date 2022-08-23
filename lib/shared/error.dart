import 'package:flutter/foundation.dart';

class BackendError {
  final String message;
  final int code;

  const BackendError(this.message, this.code);

  factory BackendError.unknown() => const BackendError('알 수 없는 오류가 발생했습니다.', 0);

  static BackendError fromException(Object e) {
    if (kDebugMode) {
      print(e);
    }
    return BackendError(e.toString(), e.runtimeType.toString().hashCode);
  }
}
