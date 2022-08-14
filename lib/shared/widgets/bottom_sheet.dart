import 'package:flutter/material.dart';

void showSheet(
  BuildContext context, {
  EdgeInsets padding = const EdgeInsets.all(12),
  bool isScrollControlled = true,
  required Widget child,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: isScrollControlled,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    builder: (BuildContext context) {
      return Wrap(
        alignment: WrapAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: 100,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Padding(
              padding: padding,
              child: SizedBox(
                width: double.infinity,
                child: child,
              ))
        ],
      );
    },
  );
}
