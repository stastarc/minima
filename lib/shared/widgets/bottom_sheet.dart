import 'package:flutter/material.dart';

Widget _buildSheetWidget({
  EdgeInsets padding = const EdgeInsets.all(12),
  required Widget child,
}) {
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
}

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
      return _buildSheetWidget(
        padding: padding,
        child: child,
      );
    },
  );
}

void showBottomMenuSheet(BuildContext context, List<BottomMenuItem> items) {
  showSheet(context,
      padding: EdgeInsets.zero,
      child: BottomMenuSheet(
        items: items,
      ));
}

class BottomMenuItem {
  final String title;
  final VoidCallback onPressed;
  final Color? color;

  const BottomMenuItem({
    required this.title,
    required this.onPressed,
    this.color,
  });
}

class BottomMenuSheet extends StatelessWidget {
  final List<BottomMenuItem> items;

  const BottomMenuSheet({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in items)
          InkWell(
            onTap: () {
              Navigator.pop(context);
              item.onPressed();
            },
            child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                child: Text(
                  item.title,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: item.color),
                )),
          ),
        const SizedBox(height: 12),
      ],
    );
  }
}
