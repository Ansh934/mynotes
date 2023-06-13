import 'package:flutter/material.dart';

class CircleLoadingScreen extends StatelessWidget {
  const CircleLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
