import 'package:flutter/material.dart';

class Label extends StatelessWidget {
  final String label;
  final String value;
  final Function? onTap;

  const Label({
    super.key,
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      children: [
        Text(label),
        const SizedBox(height: 8.0),
        Text(
          value,
          style: const TextStyle(decoration: TextDecoration.underline),
        ),
      ],
    );
    if (onTap == null) {
      return content;
    } else {
      return InkWell(
        onTap: onTap!.call(),
        child: content,
      );
    }
  }
}
