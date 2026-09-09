import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

import '../services/ml_text_service.dart';
import '../services/translate_service.dart';
import '../services/language_service.dart';
import '../services/history_data.dart';
import '../models/history_model.dart';
import 'result_screen.dart';

class ScannerScreen extends StatefulWidget {
  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  File? image;
  final ImagePicker picker = ImagePicker();

  final MLTextService mlService = MLTextService();
  final TranslateService translateService = TranslateService();
  final LanguageService languageService = LanguageService();

  bool isLoading = false;

  // 🌍 langue cible
  TranslateLanguage targetLanguage = TranslateLanguage.french;

  // 🔥 nettoyage texte
  String cleanText(String text) {
    text = text.replaceAll('\n', ' ');
    text = text.replaceAll(RegExp(r'[^\w\s]'), '');
    text = text.replaceAll(RegExp(r'\s+'), ' ');
    return text.trim();
  }

  // 📷 scan image
  Future pickImage(ImageSource source) async {
    final picked = await picker.pickImage(source: source);

    if (picked != null) {
      setState(() {
        image = File(picked.path);
        isLoading = true;
      });

      try {
        // 🧠 OCR
        String extractedText = await mlService.extractText(image!);

        extractedText = cleanText(extractedText);
        extractedText = extractedText.toLowerCase();

        // 🧠 détecter langue
        TranslateLanguage detectedLang =
        await languageService.detectLanguage(extractedText);

        // ❗ éviter même langue
        if (detectedLang == targetLanguage) {
          setState(() => isLoading = false);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Langue détectée = langue cible"),
            ),
          );
          return;
        }

        // 🌍 traduction
        await translateService.initTranslator(
          detectedLang,
          targetLanguage,
        );

        String translatedText =
        await translateService.translateText(extractedText);

        setState(() {
          isLoading = false;
        });

        // 🔥 AJOUT HISTORIQUE
        HistoryData.historyList.add(
          HistoryModel(
            imagePath: image!.path,
            extractedText: extractedText,
            translatedText: translatedText,
          ),
        );

        // 📄 navigation vers résultat
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResultScreen(
              extractedText: extractedText,
              translatedText: translatedText,
              imagePath: image!.path,
            ),
          ),
        );
      } catch (e) {
        setState(() => isLoading = false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur : $e")),
        );
      }
    }
  }

  @override
  void dispose() {
    mlService.dispose();
    translateService.dispose();
    languageService.dispose();
    super.dispose();
  }

  // 🌍 dropdown langue
  Widget buildDropdown() {
    return DropdownButton<TranslateLanguage>(
      value: targetLanguage,
      onChanged: (val) {
        setState(() {
          targetLanguage = val!;
        });
      },
      items: const [
        DropdownMenuItem(
          value: TranslateLanguage.english,
          child: Text("🇬🇧 Anglais"),
        ),
        DropdownMenuItem(
          value: TranslateLanguage.french,
          child: Text("🇫🇷 Français"),
        ),
        DropdownMenuItem(
          value: TranslateLanguage.arabic,
          child: Text("🇸🇦 Arabe"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scanner")),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 📷 image preview
            image != null
                ? Image.file(image!, height: 200)
                : const Text("Aucune image"),

            const SizedBox(height: 20),

            // 🌍 choix langue
            buildDropdown(),

            const SizedBox(height: 30),

            // 📷 boutons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => pickImage(ImageSource.camera),
                  child: const Text("📷 Caméra"),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => pickImage(ImageSource.gallery),
                  child: const Text("🖼 Galerie"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}