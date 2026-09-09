import 'package:flutter/material.dart';

class GalleriePage extends StatelessWidget {
  const GalleriePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Galerie"),
        backgroundColor: Colors.blue.shade800,
      ),
      body: const Center(
        child: Text(
          "Page Galerie",
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}