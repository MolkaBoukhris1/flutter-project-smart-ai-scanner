import 'dart:io'; // AJOUTER
import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String extractedText;
  final String translatedText;
  final String imagePath;

  const ResultScreen({
    super.key,
    required this.extractedText,
    required this.translatedText,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Résultat")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Image.file(File(imagePath), height: 200),
            const SizedBox(height: 20),

            const Text("Texte détecté :", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(extractedText),

            const SizedBox(height: 20),

            const Text("Texte traduit :", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(translatedText),
          ],
        ),
      ),
    );
  }
}