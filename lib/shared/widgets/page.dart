import 'package:flutter/material.dart';

class PageWidget extends StatefulWidget {
  final Widget child;
  final String? title;
  final Color titleColor;
  final bool fullScreen;
  final bool closeable;
  final VoidCallback? onClose;

  const PageWidget(
      {super.key,
      required this.child,
      this.title,
      this.titleColor = Colors.black,
      this.fullScreen = false,
      this.closeable = true,
      this.onClose});

  @override
  State<PageWidget> createState() => _PageWidgetState();
}

class _PageWidgetState extends State<PageWidget> {
  void _onClose() {
    if (widget.onClose != null) {
      widget.onClose!();
    }

    if (widget.closeable) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            if (widget.fullScreen) Expanded(child: widget.child),
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: SizedBox(
                    height: 52,
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: 52,
                              height: 52,
                              child: TextButton(
                                  onPressed: _onClose,
                                  child: Icon(Icons.arrow_back_ios_new_rounded,
                                      size: 24, color: widget.titleColor))),
                          if (widget.title != null)
                            Expanded(
                                child: Text(widget.title!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: widget.titleColor,
                                        decoration: TextDecoration.none))),
                          if (widget.title != null) const SizedBox(width: 52),
                        ]))),
            if (!widget.fullScreen) widget.child
          ],
        ));
  }
}