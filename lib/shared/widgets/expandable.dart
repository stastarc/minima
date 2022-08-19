import 'package:flutter/material.dart';
import 'package:minima/shared/widgets/button.dart';

class Expandable extends StatefulWidget {
  final Widget child;
  final Widget expanded;
  final bool initiallyExpanded;

  const Expandable({
    super.key,
    required this.child,
    required this.expanded,
    this.initiallyExpanded = false,
  });

  @override
  State createState() => _ExpandableState();
}

class _ExpandableState extends State<Expandable> {
  late bool expanded;

  @override
  void initState() {
    super.initState();
    expanded = widget.initiallyExpanded;
  }

  void onMore() {
    setState(() => expanded = !expanded);
  }

  Widget buildMoreButton() {
    return PrimaryButton(
      width: 110,
      padding: EdgeInsets.zero,
      decoration: const BoxDecoration(),
      onPressed: onMore,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(
          expanded ? Icons.expand_less : Icons.expand_more,
          color: Colors.black,
          size: 32,
        ),
        Text(expanded ? '접기' : '더보기', style: TextStyle(color: Colors.black))
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.child,
        if (!expanded) buildMoreButton(),
        if (expanded) widget.expanded,
        if (expanded) buildMoreButton(),
      ],
    );
  }
}
