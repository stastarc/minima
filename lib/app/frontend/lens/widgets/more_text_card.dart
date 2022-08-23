import 'package:flutter/material.dart';
import 'package:minima/shared/widgets/rounded_card.dart';

class MoreRCard extends StatefulWidget {
  final Widget child;
  final Widget? moreChild;
  final EdgeInsets padding;
  final Color color;
  final double borderRadius;
  final double? width, height;

  const MoreRCard({
    super.key,
    required this.child,
    this.moreChild,
    this.padding = const EdgeInsets.all(12),
    this.color = const Color(0xFFF9F9F9),
    this.borderRadius = 14,
    this.width,
    this.height,
  });

  @override
  State createState() => _MoreRCardState();
}

class _MoreRCardState extends State<MoreRCard> {
  bool _isExpanded = false;

  void onTap() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RCard(
      padding: widget.padding,
      color: widget.color,
      borderRadius: widget.borderRadius,
      width: widget.width,
      height: widget.height,
      suffix: widget.moreChild != null
          ? GestureDetector(
              onTap: onTap,
              child: Icon(
                _isExpanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                size: 26,
              ))
          : null,
      child: _isExpanded
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [widget.child, widget.moreChild!])
          : widget.child,
    );
  }
}
