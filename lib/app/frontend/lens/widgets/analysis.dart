import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AnalysisAnimationView extends StatefulWidget {
  final double? width, height;
  final Uint8List image;

  const AnalysisAnimationView({
    super.key,
    this.width,
    this.height,
    required this.image,
  });

  @override
  State createState() => _AnalysisAnimationViewState();
}

class _AnalysisAnimationViewState extends State<AnalysisAnimationView> {
  late WebViewController _controller;
  bool isLoading = true;

  void onWebViewCreated(WebViewController controller) async {
    _controller = controller;
    controller.loadHtmlString(
        await rootBundle.loadString('assets/html/analysis.html'));
  }

  void onPageFinished(String url) async {
    if (!isLoading) return;
    await _controller.runJavascript(
        "runScanner('data:image/jpg;base64,${base64.encode(widget.image)}', ScannerOptions.default(), false)");
    await Future.delayed(const Duration(milliseconds: 200));
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: WebView(
          backgroundColor: Colors.transparent,
          initialUrl: 'about:blank',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: onWebViewCreated,
          onPageFinished: onPageFinished),
    );
  }
}
