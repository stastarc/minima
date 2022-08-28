import 'package:collection/collection.dart';

import 'package:flutter/material.dart';
import 'package:minima/shared/skeletons/skeleton_box.dart';

class TextTabBar extends StatefulWidget {
  final List<String> tabs;
  final int currentTab;
  final bool Function(int)? onTabChanged;

  const TextTabBar({
    super.key,
    required this.tabs,
    required this.onTabChanged,
    this.currentTab = 0,
  });

  @override
  State<TextTabBar> createState() => _TextTabBarState();
}

class _TextTabBarState extends State<TextTabBar> {
  late int currentTab;

  @override
  void initState() {
    super.initState();
    currentTab = widget.currentTab;
  }

  void onPressed(int index) {
    if (!(widget.onTabChanged != null ? widget.onTabChanged!(index) : true)) {
      return;
    }
    setState(() {
      currentTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 25,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0xFFCECECE),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: widget.tabs
              .mapIndexed((i, tab) => Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                          child: Ink(
                            width: double.infinity,
                            height: 24,
                            decoration: currentTab == i
                                ? const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Color(0xFF999999),
                                            width: 2)),
                                  )
                                : null,
                            child: Text(
                              tab,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF494949),
                                  fontWeight: FontWeight.w600),
                            ),
                          )),
                      onPressed: () => onPressed(i),
                    ),
                  ))
              .toList(),
        ));
  }
}

class TextTabBarSkeleton extends StatelessWidget {
  final int tabsCount;

  const TextTabBarSkeleton({
    super.key,
    this.tabsCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < tabsCount; i++)
          const Expanded(
            child: Padding(
                padding: EdgeInsets.fromLTRB(24, 8, 24, 12),
                child: SkeletonBox(
                  width: double.infinity,
                  height: 24,
                )),
          ),
      ],
    );
  }
}
