import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AnalysisAnimationView extends StatefulWidget {
  final double? width, height;

  const AnalysisAnimationView({super.key, this.width, this.height});
  @override
  State createState() => _AnalysisAnimationViewState();
}

class _AnalysisAnimationViewState extends State<AnalysisAnimationView> {
  late WebViewController _controller;

  void onWebViewCreated(WebViewController controller) {
    _controller = controller;
    rootBundle.loadString('assets/html/analysis.html').then((html) {
      controller.loadHtmlString(html);
    });
  }

  void onPageFinished(String url) {
    Future.delayed(const Duration(seconds: 1), () {
      rootBundle.load('assets/images/dummy/야추.jpg').then((bytes) {
        final str =
            "runScanner('data:image/jpg;base64,${base64.encode(bytes.buffer.asUint8List())}', ScannerOptions.default(), false)";
        _controller.runJavascript(str);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: WebView(
          backgroundColor: Colors.black,
          initialUrl: 'about:blank',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: onWebViewCreated,
          onPageFinished: onPageFinished),
    );
  }
}
