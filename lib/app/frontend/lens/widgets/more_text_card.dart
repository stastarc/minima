import 'package:flutter/material.dart';
import 'package:minima/shared/widgets/rounded_card.dart';

class MoreRCard extends StatefulWidget {
  final Widget child;
  final Widget? moreChild;
  final EdgeInsets padding;
  final Color color;
  final double borderRadius;
  final double? width, height, paddingVertical;
  final bool columnMode;

  const MoreRCard({
    super.key,
    required this.child,
    this.moreChild,
    this.padding = const EdgeInsets.all(12),
    this.color = const Color(0xFFF9F9F9),
    this.borderRadius = 14,
    this.width,
    this.height,
    this.paddingVertical,
    this.columnMode = false,
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
      columnMode: widget.columnMode,
      crossAxisAlignment: widget.columnMode
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.end,
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
          ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              widget.child,
              if (widget.paddingVertical != null)
                SizedBox(height: widget.paddingVertical),
              widget.moreChild!
            ])
          : widget.child,
    );
  }
}
