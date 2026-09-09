import '../models/user_model.dart';
class AuthService {
  // Liste des utilisateurs inscrits (en mémoire)
  static List<UserModel> _users = [];

  // Utilisateur actuellement connecté
  static UserModel? currentUser;

  // ✅ INSCRIPTION
  static String? register(String name, String email, String password) {
    // Vérifier si l'email existe déjà
    final exists = _users.any((u) => u.email.toLowerCase() == email.toLowerCase());
    if (exists) {
      return "Cet email est déjà utilisé.";
    }

    // Ajouter le nouvel utilisateur
    _users.add(UserModel(name: name, email: email, password: password));
    return null; // null = succès, pas d'erreur
  }

  // ✅ CONNEXION
  static String? login(String email, String password) {
    try {
      final user = _users.firstWhere(
            (u) =>
        u.email.toLowerCase() == email.toLowerCase() &&
            u.password == password,
      );
      currentUser = user;
      return null; // null = succès
    } catch (_) {
      return "Email ou mot de passe incorrect.";
    }
  }

  // ✅ DÉCONNEXION
  static void logout() {
    currentUser = null;
  }

  // ✅ VÉRIFIER SI CONNECTÉ
  static bool get isLoggedIn => currentUser != null;
}