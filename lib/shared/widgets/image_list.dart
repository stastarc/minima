import 'package:flutter/material.dart';
import 'package:minima/app/backend/cdn/cdn.dart';
import 'package:page_view_indicators/page_view_indicators.dart';

class PageListView extends StatefulWidget {
  final PageController? controller;
  final void Function(int index)? onPageChanged;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final int itemCount;
  final double? width, height;

  const PageListView({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    this.controller,
    this.onPageChanged,
    this.width,
    this.height,
  });

  @override
  State createState() => _PageListViewState();
}

class _PageListViewState extends State<PageListView> {
  final notifier = ValueNotifier<int>(0);
  void onPageChanged(int index) {
    notifier.value = index;
    if (widget.onPageChanged != null) {
      widget.onPageChanged!(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: widget.width,
          height: widget.height,
          child: PageView.builder(
            controller: widget.controller,
            itemCount: widget.itemCount,
            itemBuilder: widget.itemBuilder,
            onPageChanged: onPageChanged,
          ),
        ),
        Positioned(
          left: 0.0,
          right: 0.0,
          bottom: 0.0,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: CirclePageIndicator(
              itemCount: widget.itemCount,
              currentPageNotifier: notifier,
              dotColor: const Color(0xFFDDDDDD),
              selectedDotColor: const Color(0xFF6D6D6D),
            ),
          ),
        ),
      ],
    );
  }
}

class ImageListView extends StatelessWidget {
  final List<String> images;
  final Color placeholderColor;
  final double placeholderSize;
  final String errorComment;
  final BoxFit? fit;
  final double? width;
  final double? height;

  const ImageListView({
    super.key,
    required this.images,
    this.width,
    this.height,
    this.placeholderColor = const Color.fromARGB(255, 192, 195, 210),
    this.placeholderSize = 100,
    this.errorComment = '이미지 준비중',
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return PageListView(
        width: width,
        height: height,
        itemCount: images.length,
        itemBuilder: (_, i) => CDN.image(
              id: images[i],
              placeholderColor: placeholderColor,
              placeholderSize: placeholderSize,
              errorComment: errorComment,
              fit: fit,
            ));
  }
}
