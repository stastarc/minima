import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:minima/app/backend/lens/lens.dart';
import 'package:minima/app/frontend/lens/widgets/analysis/analysis.dart';
import 'package:minima/app/frontend/lens/widgets/result_view.dart';
import 'package:minima/shared/error.dart';
import 'package:minima/shared/widgets/page.dart';
import 'package:minima/shared/widgets/retry.dart';

class AnalysisPage extends StatefulWidget {
  // final File image;
  final Uint8List image;

  const AnalysisPage({super.key, required this.image});

  @override
  State createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  static const backgroundHeight = 300.0;
  dynamic result;
  bool fadeout = false;
  late Future<void> initialized;

  Future<void> initialize() async {
    try {
      result = await Lens.instance.analysis(widget.image);
      fadeout = true;
      if (mounted) setState(() {});
      await Future.delayed(const Duration(milliseconds: 1010));
    } catch (e) {
      result = BackendError.fromException(e);
    }
    fadeout = false;
    if (mounted) setState(() {});
  }

  void retry() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    initialized = initialize();
  }

  Widget buildBody() {
    return FutureBuilder(
      future: initialized,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (result == null || result is BackendError) {
            return RetryButton(
              onPressed: retry,
              error: result,
              text: '분석 요청을 실패했습니다.',
              buttonText: '닫기',
            );
          }

          return AnalysisResultView(result: result);
        }

        return const AnalysisResultViewSkeleton();
      },
    );
  }

  Widget buildBackground() {
    return FutureBuilder(
      future: initialized,
      builder: (context, snapshot) {
        return Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Image.memory(
                widget.image,
                fit: BoxFit.cover,
              ),
            ),
            if (snapshot.connectionState != ConnectionState.done)
              AnalysisAnimationView(
                image: widget.image,
                width: MediaQuery.of(context).size.width,
                height: backgroundHeight,
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        fullScreen: true,
        titleColor: Colors.grey[200]!,
        child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Stack(children: [
              SizedBox(
                  width: double.infinity,
                  height: backgroundHeight,
                  child: buildBackground()),
              Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ListView(
                    physics: const ClampingScrollPhysics(),
                    children: [
                      const SizedBox(height: backgroundHeight - (20 * 2) - 4),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: AnimatedOpacity(
                          opacity: fadeout ? 0 : 1,
                          duration: const Duration(milliseconds: 500),
                          alwaysIncludeSemantics: true,
                          child: buildBody(),
                        ),
                      )
                    ],
                  ))
            ])));
  }
}
