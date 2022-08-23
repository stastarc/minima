import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:minima/app/backend/lens/lens.dart';
import 'package:minima/app/frontend/lens/widgets/analysis.dart';
import 'package:minima/app/frontend/lens/widgets/result_view.dart';
import 'package:minima/app/models/lens/analysis.dart';
import 'package:minima/routers/_route.dart';
import 'package:minima/shared/error.dart';
import 'package:minima/shared/skeletons/skeleton_box.dart';
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
  dynamic result;
  late Future<void> initialized;

  Future<void> initialize() async {
    try {
      result = await Lens.instance.analysis(widget.image);
    } catch (e) {
      result = BackendError.fromException(e);
    }
    setState(() {});
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

        return const SkeletonBox(
          width: double.infinity,
        );
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
                width: double.infinity,
                height: double.infinity,
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const backgroundHeight = 300.0;
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
                    children: [
                      const SizedBox(height: backgroundHeight - 20 - 4),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: buildBody(),
                      )
                    ],
                  ))
            ])));
  }
}
