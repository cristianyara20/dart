import 'package:flutter/material.dart';

class MiText extends StatelessWidget {
  final String text; // Property

  // Constructor
  const MiText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}
