class BackendError {
  final String message;
  final int code;

  BackendError(this.message, this.code);

  BackendError.unknown()
      : message = '알 수 없는 오류가 발생했습니다.',
        code = 0;

  BackendError.fromException(Object e)
      : message = e.toString(),
        code = e.runtimeType.toString().hashCode;
}
