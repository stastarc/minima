import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

class ColumnHeader extends StatelessWidget {
  final dynamic icon;
  final String title;

  const ColumnHeader({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon is IconData)
            Icon(icon, size: 28)
          else
            Iconify(icon, size: 28),
          const SizedBox(width: 4),
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }
}
