import 'package:flutter/material.dart';
import 'package:minima/app/backend/cdn/cdn.dart';
import 'package:page_view_indicators/page_view_indicators.dart';

class ImageListView extends StatefulWidget {
  final List<String> images;

  const ImageListView({super.key, required this.images});

  @override
  State createState() => _ImageListViewState();
}

class _ImageListViewState extends State<ImageListView> {
  final _currentPageNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 400,
          child: PageView.builder(
            itemCount: widget.images.length,
            itemBuilder: (_, i) =>
                CDN.image(id: widget.images[i], errorComment: '상품 이미지\n준비중'),
            onPageChanged: (i) => _currentPageNotifier.value = i,
          ),
        ),
        Positioned(
          left: 0.0,
          right: 0.0,
          bottom: 0.0,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: CirclePageIndicator(
              itemCount: widget.images.length,
              currentPageNotifier: _currentPageNotifier,
              dotColor: const Color(0xFFDDDDDD),
              selectedDotColor: const Color(0xFF6D6D6D),
            ),
          ),
        ),
      ],
    );
  }
}
