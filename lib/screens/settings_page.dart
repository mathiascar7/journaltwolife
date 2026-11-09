import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import '../main.dart'; // Asegúrate de que setUserPreferredLocale esté exportado aquí
import 'widgets/app_drawer.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user;
  String newEmail = '';
  String newPassword = '';

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
  }

  // Método para actualizar el idioma en Firestore
  Future<void> _updateLanguageInFirestore(Locale locale) async {
    if (user != null) {
      try {
        await _firestore.collection('users').doc(user!.uid).set({
          'preferredLocale': locale.languageCode,
          'lastUpdate': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        debugPrint("Idioma guardado en Firestore: ${locale.languageCode}");
      } catch (e) {
        debugPrint("Error al guardar idioma en Firestore: $e");
      }
    }
  }

  Future<void> _updateEmail() async {
    try {
      if (newEmail.isEmpty || user == null) return;
      final credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: newPassword,
      );
      await user!.reauthenticateWithCredential(credential);
      await user!.verifyBeforeUpdateEmail(newEmail);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('verification_email_sent'.tr())),
      );
    } catch (e) {
      _showErrorSnackBar(e);
    }
  }

  Future<void> _updatePassword() async {
    try {
      if (newPassword.isEmpty || user == null) return;
      final credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: newPassword,
      );
      await user!.reauthenticateWithCredential(credential);
      await user!.updatePassword(newPassword);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('password_updated'.tr())),
      );
    } catch (e) {
      _showErrorSnackBar(e);
    }
  }

  void _showErrorSnackBar(Object e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${'error_label'.tr()}: $e')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('settings'.tr())),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: Text('user_label'.tr()),
                subtitle: Text(user?.email ?? 'not_logged_in'.tr()),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              decoration: InputDecoration(
                labelText: 'new_email'.tr(),
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) => newEmail = value,
            ),
            const SizedBox(height: 15),
            TextField(
              decoration: InputDecoration(
                labelText: 'new_password'.tr(),
                border: const OutlineInputBorder(),
              ),
              obscureText: true,
              onChanged: (value) => newPassword = value,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (newEmail.isNotEmpty) await _updateEmail();
                if (newPassword.isNotEmpty) await _updatePassword();
              },
              child: Text('update_settings'.tr()),
            ),

            const Divider(height: 40),

            Text('language'.tr(), style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),

            // Dropdown mejorado con persistencia
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Locale>(
                  value: context.locale,
                  isExpanded: true,
                  onChanged: (Locale? locale) async {
                    if (locale != null) {
                      // 1. Cambiar localmente en la UI
                      await context.setLocale(locale);
                      // 2. Guardar en SharedPreferences (Persistencia local)
                      await setUserPreferredLocale(locale);
                      // 3. Guardar en Firestore (Persistencia en la nube)
                      await _updateLanguageInFirestore(locale);

                      setState(() {});
                    }
                  },
                  items: const [
                    DropdownMenuItem(value: Locale('en'), child: Text('English 🇺🇸')),
                    DropdownMenuItem(value: Locale('es'), child: Text('Español 🇪🇸')),
                    DropdownMenuItem(value: Locale('fr'), child: Text('Français 🇫🇷')),
                    DropdownMenuItem(value: Locale('de'), child: Text('Deutsch 🇩🇪')),
                    DropdownMenuItem(value: Locale('it'), child: Text('Italiano 🇮🇹')),
                    DropdownMenuItem(value: Locale('pt'), child: Text('Português 🇵🇹')),
                    DropdownMenuItem(value: Locale('ja'), child: Text('日本語 🇯🇵')),
                    DropdownMenuItem(value: Locale('zh'), child: Text('中文 🇨🇳')),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}