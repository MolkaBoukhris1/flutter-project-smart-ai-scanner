import 'package:flutter/material.dart';
import '../services/auth_service.dart';   // ← NOUVEAU

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Récupérer l'utilisateur connecté
    final user = AuthService.currentUser;

    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade900, Colors.blue.shade500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              accountName: Text(
                user?.name ?? "Utilisateur",   // ← Affiche le vrai nom
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              accountEmail: Text(
                user?.email ?? "",              // ← Affiche le vrai email
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person_rounded, size: 40, color: Colors.blueAccent),
              ),
            ),

            const SizedBox(height: 10),

            _buildItem(Icons.home_rounded, "Accueil", context, route: "/home"),
            _buildItem(Icons.dashboard_rounded, "Tableau de bord", context, route: "/services"),
            _buildItem(Icons.document_scanner_rounded, "Scanner IA", context, route: "/scanner"),
            _buildItem(Icons.history_rounded, "Historique", context, route: "/historique"),

            const Spacer(),
            const Divider(),

            // 🔴 Bouton Déconnexion
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: ListTile(
                leading: Icon(Icons.logout_rounded, color: Colors.red.shade400, size: 28),
                title: Text(
                  "Déconnexion",
                  style: TextStyle(
                    color: Colors.red.shade400,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                onTap: () {
                  AuthService.logout();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                        (route) => false,   // Efface tout l'historique de navigation
                  );
                },
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(
      IconData icon,
      String title,
      BuildContext context, {
        String? route,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue.shade800, size: 28),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        hoverColor: Colors.blue.shade50,
        splashColor: Colors.blue.shade100,
        onTap: () {
          Navigator.pop(context);
          if (route != null) {
            Navigator.pushNamed(context, route);
          }
        },
      ),
    );
  }
}