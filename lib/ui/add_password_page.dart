import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import '../models/password_entry.dart';
import '../state/password_provider.dart';

class AddPasswordPage extends StatefulWidget {
  const AddPasswordPage({super.key});

  @override
  State<AddPasswordPage> createState() => _AddPasswordPageState();
}

class _AddPasswordPageState extends State<AddPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _siteController = TextEditingController();
  final _passwordController = TextEditingController();

  // Clave secreta fija por simplicidad. En producción, usa una clave generada y guardada de forma segura.
  final _key = encrypt.Key.fromUtf8('1234567890123456'); // 16 caracteres = 128 bits
  final _iv = encrypt.IV.fromLength(16); // Vector de inicialización

  void _savePassword() {
    if (_formKey.currentState!.validate()) {
      final encrypter = encrypt.Encrypter(encrypt.AES(_key));
      final encryptedPassword = encrypter.encrypt(
        _passwordController.text,
        iv: _iv,
      );

      final newEntry = PasswordEntry(
        id: const Uuid().v4(),
        site: _siteController.text,
        encryptedPassword: encryptedPassword.base64,
      );

      Provider.of<PasswordProvider>(context, listen: false).addEntry(newEntry);
      Navigator.pop(context); // Regresar a HomePage
    }
  }

  @override
  void dispose() {
    _siteController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Contraseña')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _siteController,
                decoration: const InputDecoration(labelText: 'Sitio o App'),
                validator: (value) =>
                    value!.isEmpty ? 'Este campo es obligatorio' : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) =>
                    value!.isEmpty ? 'Este campo es obligatorio' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _savePassword,
                child: const Text('Guardar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
