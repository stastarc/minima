import 'package:flutter/material.dart';
import 'package:minima/shared/error.dart';
import 'package:minima/shared/widgets/retry.dart';
import 'package:toast/toast.dart';

class FutureBuilderWidget<T> extends StatefulWidget {
  final Future<T>? future;
  final Future<T> Function()? futureBuilder;
  final Widget? loading;
  final Widget Function(dynamic)? errorBuilder;
  final Widget Function()? loadingBuilder;
  final Widget Function(T)? completedBuilder;
  final Widget Function(T?)? defaultBuilder;
  final String retryText;
  final VoidCallback? onRetry;

  const FutureBuilderWidget({
    super.key,
    this.future,
    this.futureBuilder,
    this.loading,
    this.errorBuilder,
    this.loadingBuilder,
    this.completedBuilder,
    this.defaultBuilder,
    this.retryText = '다시 시도',
    this.onRetry,
  });

  @override
  State createState() => _FutureBuilderWidgetState<T>();
}

class _FutureBuilderWidgetState<T> extends State<FutureBuilderWidget<T>> {
  Future<T>? future;

  void init() {
    future = widget.future ?? widget.futureBuilder!();
  }

  void onRetry() {
    if (widget.futureBuilder != null) {
      setState(init);
    } else {
      if (widget.onRetry != null) {
        widget.onRetry!();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            if (widget.errorBuilder != null) {
              return widget.errorBuilder!(snapshot.error);
            } else if (widget.onRetry == null &&
                widget.defaultBuilder != null) {
              return widget.defaultBuilder!(null);
            } else {
              return RetryButton(
                  buttonText: widget.retryText,
                  onPressed: onRetry,
                  error: snapshot.error != null
                      ? BackendError.fromException(snapshot.error!)
                      : BackendError.unknown());
            }
          } else {
            if (widget.completedBuilder != null) {
              return widget.completedBuilder!(snapshot.data as T);
            } else {
              return widget.defaultBuilder!(snapshot.data as T);
            }
          }
        } else {
          if (widget.loadingBuilder != null) {
            return widget.loadingBuilder!();
          } else if (widget.defaultBuilder != null) {
            return widget.defaultBuilder!(null);
          } else {
            return widget.loading ??
                const Center(
                  child: CircularProgressIndicator(),
                );
          }
        }
      },
    );
  }
}
