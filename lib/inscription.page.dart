import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// stateful 5ater fih text nekteb fih ou nfasa5
class InscriptionPage extends StatefulWidget {
  const InscriptionPage({super.key});

  @override
  //kol user yekhou instance de page
  //khatrou stateful lazem na3mel create state
  State<InscriptionPage> createState() => _InscriptionPageState();
}
//State = la partie qui contient les données qui peuvent changer au cours du temps
// logique de page XD
class _InscriptionPageState extends State<InscriptionPage> {
//controller : pour lire ,modifier , controler les champ
  final TextEditingController txt_login = TextEditingController();
  final TextEditingController txt_password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Page Inscription"),
        backgroundColor: Colors.amber,
      ),
        body: Column(
          //children = liste des widgets affichés
          children: [
            //padding pour ajouter espace entre les widget 10 pixels sur tous les côtés
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: txt_login,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  hintText: "Utilisateur",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: txt_password,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  hintText: "Mot de passe",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => _onInscrire(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text(
                "Inscription",
                style: TextStyle(fontSize: 25, color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/authentification');
              },
              child: const Text(
                "J'ai déjà un compte",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      );
    }

    Future<void> _onInscrire() async {
      final prefs = await SharedPreferences.getInstance();

      if (txt_login.text.isNotEmpty && txt_password.text.isNotEmpty) {
        await prefs.setString("login", txt_login.text);
        await prefs.setString("password", txt_password.text);
        await prefs.setBool("connecte", true);

        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Champs vides")),
        );
      }
    }
  }