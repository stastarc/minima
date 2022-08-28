import 'package:flutter/material.dart';

enum LoadStatus {
  error,
  noMore,
  completed,
}

class LoadStatusData {
  final LoadStatus status;
  final int itemCount;
  final dynamic args;

  const LoadStatusData({
    required this.status,
    required this.itemCount,
    this.args,
  });

  LoadStatusData.error(int itemCount, {dynamic args})
      : this(
          status: LoadStatus.error,
          itemCount: itemCount,
          args: args,
        );

  LoadStatusData.noMore(int itemCount, {dynamic args})
      : this(
          status: LoadStatus.noMore,
          itemCount: itemCount,
          args: args,
        );

  LoadStatusData.completed(int itemCount, {dynamic args})
      : this(
          status: LoadStatus.completed,
          itemCount: itemCount,
          args: args,
        );
}

class InfinityScrollListView extends StatefulWidget {
  final Widget Function(BuildContext context, int index) itemBuilder;
  final Widget Function(BuildContext context, dynamic args)? loadingBuilder;
  final Widget Function(BuildContext context, dynamic args)? noMoreBuilder;
  final Widget Function(BuildContext context, dynamic args)? errorBuilder;

  final Future<LoadStatusData> Function() onArrived;
  final int proximityPixel;

  const InfinityScrollListView({
    super.key,
    required this.itemBuilder,
    required this.onArrived,
    this.loadingBuilder,
    this.noMoreBuilder,
    this.errorBuilder,
    this.proximityPixel = 200,
  });

  @override
  State createState() => _InfinityScrollListViewState();
}

class _InfinityScrollListViewState extends State<InfinityScrollListView> {
  final _scroll = ScrollController();
  Future<void>? _onArrived;
  LoadStatusData? _data;

  void _onScroll() {
    if (_data == null ||
        _scroll.position.pixels >=
            _scroll.position.maxScrollExtent - widget.proximityPixel) {
      _onArrived ??= widget
          .onArrived()
          .then(onLoaded)
          .catchError((e) => onLoaded(LoadStatusData.error(0, args: e)));
    }
  }

  void onLoaded(LoadStatusData data) {
    setState(() {
      _data = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  Widget buildItem(BuildContext context, int index) {
    if (index < (_data?.itemCount ?? 0)) {
      return widget.itemBuilder(context, index);
    } else {
      final status = _data?.status;
      if (status == LoadStatus.error) {
        if (widget.errorBuilder != null) {
          return widget.errorBuilder!(context, _data?.args);
        }
      } else if (status == LoadStatus.noMore) {
        if (widget.noMoreBuilder != null) {
          return widget.noMoreBuilder!(context, _data?.args);
        }
      } else {
        if (widget.loadingBuilder != null) {
          return widget.loadingBuilder!(context, _data?.args);
        }
      }

      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasMore = _data?.status != LoadStatus.noMore;
    final w = ListView.builder(
        controller: _scroll,
        itemBuilder: buildItem,
        itemCount: (_data?.itemCount ?? 0) + (hasMore ? 1 : 0));
    _onScroll();
    return w;
  }
}

class InfinityScrollController extends ScrollController {
  final VoidCallback onArrived;
  final void Function(double)? onArrivedAt;
  final List<Arrived>? arrivedAtList;
  final double proximityPixel;

  InfinityScrollController({
    required this.onArrived,
    this.proximityPixel = 200,
    this.onArrivedAt,
    this.arrivedAtList,
  }) {
    addListener(_onScroll);
  }

  void _onScroll() {
    if (position.pixels >= position.maxScrollExtent - proximityPixel) {
      onArrived();
    }

    if (arrivedAtList != null) {
      for (final arrived in arrivedAtList!) {
        if (position.pixels >= arrived.arrivedAt &&
            position.pixels < arrived.arrivedAt + arrived.proximityPixel) {
          if (onArrivedAt != null) {
            onArrivedAt!(arrived.arrivedAt);
          }

          if (arrived.onArrived != null) {
            arrived.onArrived!();
          }
        }
      }
    }
  }
}

class Arrived {
  final double arrivedAt, proximityPixel;
  final VoidCallback? onArrived;

  const Arrived({
    required this.arrivedAt,
    required this.proximityPixel,
    this.onArrived,
  });
}
