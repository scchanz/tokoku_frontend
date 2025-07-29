import 'package:flutter/material.dart';
import '../models/user_model.dart';

class ProfilePage extends StatelessWidget {
  final UserModel user;

  const ProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Saya"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nama: ${user.name}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text("Email: ${user.email}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // kembali ke login/home
              },
              child: const Text("Keluar"),
            )
          ],
        ),
      ),
    );
  }
}
