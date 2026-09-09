import 'package:flutter/material.dart';

class ParametresPage extends StatelessWidget {
  const ParametresPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Paramètres"),
        backgroundColor: Colors.blue.shade800,
      ),
      body: const Center(
        child: Text(
          "Page Paramètres",
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}