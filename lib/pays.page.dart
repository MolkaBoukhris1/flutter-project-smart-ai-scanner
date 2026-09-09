import 'package:flutter/material.dart';

class PaysPage extends StatelessWidget {
  const PaysPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pays"),
        backgroundColor: Colors.blue.shade800,
      ),
      body: const Center(
        child: Text(
          "Page Pays",
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}