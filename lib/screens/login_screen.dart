import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  // 🔁 Contrôleur pour basculer entre Login et Inscription
  late TabController _tabController;

  // 📝 Champs Login
  final _loginEmailCtrl = TextEditingController();
  final _loginPasswordCtrl = TextEditingController();

  // 📝 Champs Inscription
  final _registerNameCtrl = TextEditingController();
  final _registerEmailCtrl = TextEditingController();
  final _registerPasswordCtrl = TextEditingController();
  final _registerConfirmCtrl = TextEditingController();

  // 👁️ Afficher/masquer mot de passe
  bool _loginPasswordVisible = false;
  bool _registerPasswordVisible = false;
  bool _registerConfirmVisible = false;

  // ⚠️ Messages d'erreur
  String? _loginError;
  String? _registerError;
  String? _registerSuccess;

  // 🔄 Chargement
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {
      _loginError = null;
      _registerError = null;
      _registerSuccess = null;
    }));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailCtrl.dispose();
    _loginPasswordCtrl.dispose();
    _registerNameCtrl.dispose();
    _registerEmailCtrl.dispose();
    _registerPasswordCtrl.dispose();
    _registerConfirmCtrl.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────
  // 🔐 ACTION : CONNEXION
  // ─────────────────────────────────────────────
  void _handleLogin() async {
    final email = _loginEmailCtrl.text.trim();
    final password = _loginPasswordCtrl.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() => _loginError = "Veuillez remplir tous les champs.");
      return;
    }

    setState(() {
      _isLoading = true;
      _loginError = null;
    });

    await Future.delayed(const Duration(milliseconds: 600)); // simulation

    final error = AuthService.login(email, password);

    setState(() => _isLoading = false);

    if (error != null) {
      setState(() => _loginError = error);
    } else {
      // ✅ Connexion réussie → aller à l'accueil
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  // ─────────────────────────────────────────────
  // 📋 ACTION : INSCRIPTION
  // ─────────────────────────────────────────────
  void _handleRegister() async {
    final name = _registerNameCtrl.text.trim();
    final email = _registerEmailCtrl.text.trim();
    final password = _registerPasswordCtrl.text;
    final confirm = _registerConfirmCtrl.text;

    // Validations
    if (name.isEmpty || email.isEmpty || password.isEmpty || confirm.isEmpty) {
      setState(() => _registerError = "Veuillez remplir tous les champs.");
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      setState(() => _registerError = "Email invalide.");
      return;
    }

    if (password.length < 6) {
      setState(() => _registerError = "Mot de passe trop court (min. 6 caractères).");
      return;
    }

    if (password != confirm) {
      setState(() => _registerError = "Les mots de passe ne correspondent pas.");
      return;
    }

    setState(() {
      _isLoading = true;
      _registerError = null;
      _registerSuccess = null;
    });

    await Future.delayed(const Duration(milliseconds: 600)); // simulation

    final error = AuthService.register(name, email, password);

    setState(() => _isLoading = false);

    if (error != null) {
      setState(() => _registerError = error);
    } else {
      setState(() => _registerSuccess = "Compte créé ! Vous pouvez vous connecter.");
      _registerNameCtrl.clear();
      _registerEmailCtrl.clear();
      _registerPasswordCtrl.clear();
      _registerConfirmCtrl.clear();
      // Basculer vers l'onglet Login
      Future.delayed(const Duration(seconds: 1), () {
        _tabController.animateTo(0);
      });
    }
  }

  // ─────────────────────────────────────────────
  // 🎨 BUILD
  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Décorations d'arrière-plan
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  const Color(0xFF3B82F6).withOpacity(0.18),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            left: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  const Color(0xFF8B5CF6).withOpacity(0.15),
                  Colors.transparent,
                ]),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const SizedBox(height: 48),

                  // 🔵 Logo / icône
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF3B82F6).withOpacity(0.2),
                          blurRadius: 30,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      size: 52,
                      color: Color(0xFF3B82F6),
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    "Smart AI Scanner",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF111827),
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    "Connectez-vous pour accéder à notre application",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),

                  const SizedBox(height: 36),

                  // 🔁 Onglets Login / Inscription
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: const Color(0xFF1E3A8A),
                      unselectedLabelColor: const Color(0xFF9CA3AF),
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      dividerColor: Colors.transparent,
                      tabs: const [
                        Tab(text: "Connexion"),
                        Tab(text: "Inscription"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // 📄 Contenu des onglets
                  SizedBox(
                    height: 480,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildLoginForm(),
                        _buildRegisterForm(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // 📋 FORMULAIRE CONNEXION
  // ─────────────────────────────────────────────
  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildField(
          controller: _loginEmailCtrl,
          label: "Email",
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        _buildField(
          controller: _loginPasswordCtrl,
          label: "Mot de passe",
          icon: Icons.lock_outline_rounded,
          isPassword: true,
          isVisible: _loginPasswordVisible,
          onToggleVisibility: () =>
              setState(() => _loginPasswordVisible = !_loginPasswordVisible),
        ),

        // Message d'erreur
        if (_loginError != null) ...[
          const SizedBox(height: 14),
          _buildErrorBanner(_loginError!),
        ],

        const SizedBox(height: 28),

        // Bouton connexion
        _buildButton(
          label: "Se connecter",
          onTap: _isLoading ? null : _handleLogin,
          isLoading: _isLoading,
        ),

        const SizedBox(height: 20),

        // Lien inscription
        GestureDetector(
          onTap: () => _tabController.animateTo(1),
          child: const Text(
            "Pas encore de compte ? S'inscrire",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF3B82F6),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // 📋 FORMULAIRE INSCRIPTION
  // ─────────────────────────────────────────────
  Widget _buildRegisterForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildField(
          controller: _registerNameCtrl,
          label: "Nom complet",
          icon: Icons.person_outline_rounded,
        ),
        const SizedBox(height: 14),
        _buildField(
          controller: _registerEmailCtrl,
          label: "Email",
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 14),
        _buildField(
          controller: _registerPasswordCtrl,
          label: "Mot de passe",
          icon: Icons.lock_outline_rounded,
          isPassword: true,
          isVisible: _registerPasswordVisible,
          onToggleVisibility: () => setState(
                  () => _registerPasswordVisible = !_registerPasswordVisible),
        ),
        const SizedBox(height: 14),
        _buildField(
          controller: _registerConfirmCtrl,
          label: "Confirmer le mot de passe",
          icon: Icons.lock_outline_rounded,
          isPassword: true,
          isVisible: _registerConfirmVisible,
          onToggleVisibility: () => setState(
                  () => _registerConfirmVisible = !_registerConfirmVisible),
        ),

        // Erreur ou succès
        if (_registerError != null) ...[
          const SizedBox(height: 14),
          _buildErrorBanner(_registerError!),
        ],
        if (_registerSuccess != null) ...[
          const SizedBox(height: 14),
          _buildSuccessBanner(_registerSuccess!),
        ],

        const SizedBox(height: 22),

        _buildButton(
          label: "Créer mon compte",
          onTap: _isLoading ? null : _handleRegister,
          isLoading: _isLoading,
        ),

        const SizedBox(height: 16),

        GestureDetector(
          onTap: () => _tabController.animateTo(0),
          child: const Text(
            "Déjà un compte ? Se connecter",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF3B82F6),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // 🧱 COMPOSANTS RÉUTILISABLES
  // ─────────────────────────────────────────────

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool isVisible = false,
    VoidCallback? onToggleVisibility,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && !isVisible,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 15, color: Color(0xFF111827)),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
          prefixIcon: Icon(icon, color: const Color(0xFF6B7280), size: 22),
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(
              isVisible
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: const Color(0xFF9CA3AF),
              size: 20,
            ),
            onPressed: onToggleVisibility,
          )
              : null,
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required VoidCallback? onTap,
    bool isLoading = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 18),
            alignment: Alignment.center,
            child: isLoading
                ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            )
                : Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorBanner(String message) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFCA5A5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded,
              color: Color(0xFFDC2626), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                  color: Color(0xFFDC2626),
                  fontSize: 13,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessBanner(String message) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF86EFAC)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline_rounded,
              color: Color(0xFF16A34A), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                  color: Color(0xFF16A34A),
                  fontSize: 13,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}