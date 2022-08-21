import 'package:flutter/material.dart';
import 'package:minima/shared/widgets/dialog.dart';
import 'package:toast/toast.dart';

void futureWaitDialog<T>(
  BuildContext context, {
  required String title,
  required String message,
  required Future<T> future,
  required void Function(T result)? onDone,
  required void Function(dynamic e)? onError,
}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) {
        ToastContext().init(context);
        future.then((f) {
          Navigator.pop(c);
          if (onDone != null) {
            onDone(f);
          }
        }).catchError((e) {
          Navigator.pop(c);
          if (onError != null) {
            onError(e);
          }
        });

        return WillPopScope(
            onWillPop: () async => false,
            child: MessageDialog(
              title: title,
              message: message,
              textAlign: TextAlign.center,
              buttons: const [],
            ));
      });
}
