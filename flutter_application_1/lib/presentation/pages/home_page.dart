import 'package:flutter/material.dart';
import '../widgets/mi_text.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyText Example'),
      ),
      body: const Center(
        child: MiText(text: "Hello World"),
      ),
    );
  }
}
