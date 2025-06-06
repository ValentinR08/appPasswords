import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/password_provider.dart';
import 'add_password_page.dart';
import 'password_detail_page.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final passwordProvider = Provider.of<PasswordProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis passwords'),
      ),
      body: ListView.builder(
        itemCount: passwordProvider.entries.length,
        itemBuilder: (context, index) {
          final entry = passwordProvider.entries[index];
          return ListTile(
            title: Text(entry.site),
            trailing: const Icon(Icons.lock_outline),
            onTap: () {
              // Aquí podrías navegar a una pantalla que pida huella y luego muestre la contraseña
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PasswordDetailPage(entry: entry),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddPasswordPage()),
          );
        },
        child: const Icon(Icons.add),
      ),

    );
  }
}
