import 'package:flutter/material.dart';
import 'package:pbmuas/view_models/auth_v_model.dart';
import 'package:pbmuas/screens/widgets/panitia_navbar.dart';
import 'package:provider/provider.dart';

class AkunContent extends StatelessWidget {
  const AkunContent({super.key});

  @override
  Widget build(BuildContext context) {
    final authVModel = Provider.of<AuthVModel>(context);

    final String nama = authVModel.akun?.nama ?? 'Panitia';
    final String email = authVModel.akun?.email ?? '-';
    final String noHp = authVModel.akun?.noHp ?? '-';
    final int? role = authVModel.akun?.roleAkunId;
    final String roleLabel = role == 1 ? 'Panitia' : role == 2 ? 'Peserta' : 'Tidak diketahui';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 40),
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blue,
            child: Icon(Icons.person, size: 60, color: Colors.white),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              nama,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 30),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text("Email"),
            subtitle: Text(email),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text("Nomor HP"),
            subtitle: Text(noHp),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: const Text("Role"),
            subtitle: Text(roleLabel),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () async {
              await authVModel.logout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              }
            },
            icon: const Icon(Icons.logout),
            label: const Text("Logout"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 14),
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}