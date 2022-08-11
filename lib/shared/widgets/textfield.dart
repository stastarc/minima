import 'package:flutter/material.dart';

class PrimaryTextField extends StatelessWidget {
  final String? title;
  final String? hint;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final EdgeInsets? padding;
  final bool? enabled;
  final bool readOnly;
  final GestureTapCallback? onTap;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const PrimaryTextField({
    super.key,
    this.title,
    this.hint,
    this.controller,
    this.minLines,
    this.maxLines,
    this.maxLength,
    this.enabled,
    this.readOnly = false,
    this.onTap,
    this.padding,
    this.keyboardType,
    this.suffix,
    this.onChanged,
    this.onSubmitted,
  });

  Widget buildTextField() {
    return TextField(
      minLines: minLines,
      maxLines: maxLines,
      maxLength: maxLength,
      controller: controller,
      keyboardType: keyboardType,
      enabled: enabled,
      readOnly: readOnly,
      onTap: onTap,
      onSubmitted: onSubmitted,
      onChanged: onChanged,
      decoration: InputDecoration(
          contentPadding: padding ?? const EdgeInsets.all(13),
          hintText: hint,
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF9C9C9C)),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF9C9C9C)),
            borderRadius: BorderRadius.circular(12),
          ),
          suffixIcon: suffix),
    );
  }

  @override
  Widget build(BuildContext context) {
    return title != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title!,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF434343)),
              ),
              const SizedBox(height: 4),
              buildTextField(),
            ],
          )
        : buildTextField();
  }
}
