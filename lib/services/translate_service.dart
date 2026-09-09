import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class TranslateService {
  OnDeviceTranslator? translator;

  final modelManager = OnDeviceTranslatorModelManager();

  Future<void> initTranslator(
      TranslateLanguage sourceLang,
      TranslateLanguage targetLang) async {

    // fermer ancien traducteur
    translator?.close();

    try {
      // 🔥 vérifier si modèle existe déjà
      final isSourceDownloaded =
      await modelManager.isModelDownloaded(sourceLang.bcpCode);

      final isTargetDownloaded =
      await modelManager.isModelDownloaded(targetLang.bcpCode);

      // 🔥 télécharger seulement si nécessaire
      if (!isSourceDownloaded) {
        await modelManager.downloadModel(sourceLang.bcpCode);
      }

      if (!isTargetDownloaded) {
        await modelManager.downloadModel(targetLang.bcpCode);
      }

      // 🔥 créer traducteur
      translator = OnDeviceTranslator(
        sourceLanguage: sourceLang,
        targetLanguage: targetLang,
      );
    } catch (e) {
      throw Exception("Erreur téléchargement modèle : $e");
    }
  }

  Future<String> translateText(String text) async {
    if (translator == null) {
      throw Exception("Translator not initialized");
    }

    try {
      return await translator!.translateText(text);
    } catch (e) {
      throw Exception("Erreur traduction : $e");
    }
  }

  void dispose() {
    translator?.close();
  }
}