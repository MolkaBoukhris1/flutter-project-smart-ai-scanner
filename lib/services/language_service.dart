import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class LanguageService {
  final identifier = LanguageIdentifier(confidenceThreshold: 0.5);

  Future<TranslateLanguage> detectLanguage(String text) async {
    final langCode = await identifier.identifyLanguage(text);

    switch (langCode) {
      case 'en':
        return TranslateLanguage.english;
      case 'fr':
        return TranslateLanguage.french;
      case 'ar':
        return TranslateLanguage.arabic;
      default:
        return TranslateLanguage.english;
    }
  }

  void dispose() {
    identifier.close();
  }
}