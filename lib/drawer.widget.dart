import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [

          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade800, Colors.blue.shade400],
              ),
            ),
            accountName: const Text("Utilisateur"),
            accountEmail: const Text("user@email.com"),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage('Image/voiture.png'),
            ),
          ),

          _buildItem(Icons.home, "Accueil", context, route: "/home"),
          _buildItem(Icons.cloud, "Météo", context, route: "/meteo"),
          _buildItem(Icons.image, "Galerie", context, route: "/gallerie"),
          _buildItem(Icons.public, "Pays", context, route: "/pays"),
          _buildItem(Icons.mail, "Contact", context, route: "/contact"),
          _buildItem(Icons.settings, "Paramètres", context, route: "/parametres"),
        //Pousse le bouton Déconnexion vers le bas.
          const Spacer(),
          //Ligne séparatrice.
          const Divider(),

          _buildItem(Icons.logout, "Déconnexion", context, isLogout: true),
        ],
      ),
    );
  }

  Widget _buildItem(
      IconData icon,
      String title,
      BuildContext context, {
        bool isLogout = false,
        String? route, // ✅ AJOUT ICI
      }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isLogout ? Colors.red : Colors.blue.shade700,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout ? Colors.red : Colors.black87,
        ),
      ),
      onTap: () async {
        // pop pour supprimer toute les feunetre ecraser
        Navigator.pop(context);

        if (isLogout) {
          SharedPreferences prefs =
          await SharedPreferences.getInstance();
          await prefs.setBool("connecte", false); // ⚠️ même clé que main.dart
         //encore dans l’arbre
          if (context.mounted) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/authentification', (route) => false);
          }
        }
        else if (route != null) {
          Navigator.pushNamed(context, route);
        }
      },
    );
  }
}