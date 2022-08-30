import 'package:flutter/material.dart';

class MessageDialogButton {
  final String title;
  final void Function(BuildContext context) onTap;
  final bool isDestructive;

  const MessageDialogButton({
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  factory MessageDialogButton.closeButton(
          {String title = '확인',
          bool isDestructive = false,
          void Function(BuildContext context)? onTap}) =>
      MessageDialogButton(
        title: title,
        onTap: (context) {
          Navigator.of(context).pop();
          if (onTap != null) onTap(context);
        },
        isDestructive: isDestructive,
      );
}

class MessageDialog extends StatelessWidget {
  final String title, message;
  final TextAlign textAlign;
  final List<MessageDialogButton> buttons;

  const MessageDialog({
    super.key,
    required this.title,
    required this.message,
    required this.buttons,
    this.textAlign = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      contentPadding: EdgeInsets.fromLTRB(18, 12, 18, buttons.isEmpty ? 12 : 0),
      buttonPadding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
      content: Text(message, textAlign: textAlign),
      actions: [
        for (final button in buttons)
          TextButton(
            child: Text(button.title,
                style: TextStyle(
                    color: button.isDestructive
                        ? Colors.red[600]!
                        : Colors.black87,
                    fontSize: 17,
                    fontWeight: FontWeight.bold)),
            onPressed: () => button.onTap(context),
          ),
      ],
    );
  }
}

void showMessageDialog(
  BuildContext context, {
  required String title,
  required String message,
  required List<MessageDialogButton> buttons,
  TextAlign textAlign = TextAlign.left,
}) {
  showDialog(
      context: context,
      builder: (c) => MessageDialog(
            title: title,
            message: message,
            buttons: buttons,
            textAlign: textAlign,
          ));
}
