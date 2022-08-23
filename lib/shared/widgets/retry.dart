import 'package:flutter/material.dart';

import '../error.dart';

class RetryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? text;
  final String buttonText;
  final BackendError error;

  const RetryButton(
      {super.key,
      required this.onPressed,
      this.text,
      required this.error,
      this.buttonText = '다시 시도'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.error_outline_rounded, size: 80),
        const SizedBox(height: 16),
        Text(
            '${text != null ? '$text\n' : ''}${error.message}\n오류코드: ${error.code}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        OutlinedButton(
            onPressed: onPressed,
            child: Text(
              buttonText,
              style: const TextStyle(color: Colors.black45),
            ))
      ]),
    );
  }
}
