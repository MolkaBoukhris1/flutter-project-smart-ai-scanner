import 'package:flutter/material.dart';
import 'scanner_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Smart AI Scanner")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            ElevatedButton(
              child: Text("Scanner"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => ScannerScreen()));
              },
            ),

            ElevatedButton(
              child: Text("Historique"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => HistoryScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}