import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import '../models/password_entry.dart';

class PasswordDetailPage extends StatefulWidget {
  final PasswordEntry entry;

  const PasswordDetailPage({super.key, required this.entry});

  @override
  State<PasswordDetailPage> createState() => _PasswordDetailPageState();
}

class _PasswordDetailPageState extends State<PasswordDetailPage> {
  String? decryptedPassword;
  bool isAuthenticating = false;

  final LocalAuthentication auth = LocalAuthentication();
  final _key = encrypt.Key.fromUtf8('1234567890123456');
  final _iv = encrypt.IV.fromLength(16);

  Future<void> _authenticateAndDecrypt() async {
    try {
      setState(() {
        isAuthenticating = true;
      });

      final didAuthenticate = await auth.authenticate(
        localizedReason: 'Autentícate para ver la contraseña',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (didAuthenticate) {
        final encrypter = encrypt.Encrypter(encrypt.AES(_key));
        final decrypted = encrypter.decrypt64(widget.entry.encryptedPassword, iv: _iv);

        setState(() {
          decryptedPassword = decrypted;
        });
      }
    } catch (e) {
      setState(() {
        decryptedPassword = 'Error al desencriptar';
      });
    } finally {
      setState(() {
        isAuthenticating = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _authenticateAndDecrypt();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.entry.site)),
      body: Center(
        child: isAuthenticating
            ? const CircularProgressIndicator()
            : Text(
                decryptedPassword ?? 'No autenticado',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
