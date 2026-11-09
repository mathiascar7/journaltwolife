import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';

import '../services/auth_service.dart';
import 'home_page.dart';
import 'login_page.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  // Cambia esto a false si no quieres requerir verificación de correo
  static const bool requireEmailVerification = true;

  // Mantenemos la lógica de dominios de prueba para tu fase de testing
  bool isTestDomain(String email) {
    final testDomains = ['u1.com', 'u2.com', 'u3.com'];
    final domain = email.split('@').last.toLowerCase();
    return testDomains.contains(domain);
  }

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final authService = AuthService();

    return Scaffold(
      appBar: AppBar(title: Text('signup_title'.tr())),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView( // Añadido para evitar error de overflow con teclado
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Puedes añadir un icono o logo aquí
              const Icon(Icons.auto_stories, size: 80, color: Colors.blue),
              const SizedBox(height: 30),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'email_label'.tr(),
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'password_label'.tr(),
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () async {
                  final email = emailController.text.trim();
                  final password = passwordController.text.trim();

                  if (email.isEmpty || password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('error_empty_fields'.tr())),
                    );
                    return;
                  }

                  try {
                    final user = await authService.signUp(email, password);

                    if (user != null) {
                      final isEmailPasswordUser = user.providerData
                          .any((p) => p.providerId == 'password');

                      // Si es un dominio de prueba o usuario Google, saltamos verificación si lo deseas
                      final skipVerification = isTestDomain(email);

                      if (requireEmailVerification &&
                          isEmailPasswordUser &&
                          !skipVerification) {
                        await user.sendEmailVerification();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('verification_email_sent'.tr())),
                          );
                        }
                      }

                      // GUARDAR EN FIRESTORE (Ajustado para el diario)
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .set({
                        'name': '', // Se editará en ProfilePage
                        'email': user.email,
                        'role': 'User',
                        'createdAt': FieldValue.serverTimestamp(),
                        // Eliminamos 'approved' y 'universityId' como pediste
                      }, SetOptions(merge: true));

                      if (!context.mounted) return;

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          (requireEmailVerification && isEmailPasswordUser && !skipVerification)
                              ? const LoginPage()
                              : const HomePage(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('registration_failed'.tr())),
                      );
                    }
                  } on FirebaseAuthException catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('firebase_error'.tr(args: [e.message ?? 'Unknown']))),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('generic_error'.tr(args: [e.toString()]))),
                    );
                  }
                },
                child: Text('signup_button'.tr()),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: Text('already_have_account'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}