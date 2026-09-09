import 'dart:io';
import 'package:flutter/material.dart';
import '../models/history_model.dart';
import '../services/history_data.dart';
import 'result_screen.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final historyList = HistoryData.historyList;

    return Scaffold(
      appBar: AppBar(title: const Text("Historique")),
      body: historyList.isEmpty
          ? const Center(child: Text("Aucun historique"))
          : ListView.builder(
        itemCount: historyList.length,
        itemBuilder: (context, index) {
          final item = historyList[index];

          return Card(
            child: ListTile(
              leading: Image.file(
                File(item.imagePath),
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(item.extractedText),
              subtitle: Text(item.translatedText),

              // 🔥 CLICK → PAGE DETAIL
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ResultScreen(
                      extractedText: item.extractedText,
                      translatedText: item.translatedText,
                      imagePath: item.imagePath,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}