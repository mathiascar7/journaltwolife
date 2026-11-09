import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import 'home_page.dart';
import 'sign_up_page.dart';
import 'forgot_password_page.dart';
import 'about_page.dart';
import 'package:url_launcher/url_launcher.dart';


class LoginPage extends StatefulWidget {
  final String? remoteVersion;

  const LoginPage({super.key, this.remoteVersion});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const String currentVersion = "1.0.0";
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authService = AuthService();

  bool isTestDomain(String email) {
    final testDomains = ['u1.com', 'u2.com', 'u3.com'];
    final domain = email.split('@').last.toLowerCase();
    return testDomains.contains(domain);
  }

  @override
  void initState() {
    super.initState();
    _checkVersion();
  }

  void _checkVersion() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final remoteVersion = widget.remoteVersion ?? "";
      if (remoteVersion.isNotEmpty && remoteVersion != currentVersion) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('update_available'.tr()),
            content: Text(
              'update_message'.tr(
                namedArgs: {'remote': remoteVersion, 'current': currentVersion},
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  const url =
                      'https://drive.google.com/file/d/1Aze36eeMWfDdDvCfJDyeP-vy7Y4nQhdI/view?usp=sharing';
                  final uri = Uri.parse(url);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('cannot_open_url'.tr())),
                    );
                  }
                },
                child: Text('update_button'.tr()),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('cancel_button'.tr()),
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Image.asset(
              'assets/journal2life_logo.png',
              width: 150,
              height: 150,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutPage()),
                );
              },
              child: Text('info_button'.tr()),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                final url = Uri.parse(
                    "https://drive.google.com/uc?export=download&id=1Aze36eeMWfDdDvCfJDyeP-vy7Y4nQhdI");
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('download_started'.tr())),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('download_error'.tr())),
                  );
                }
              },
              child: Text('download_apk'.tr()),
            ),
            const SizedBox(height: 20),
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
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ForgotPasswordPage()),
                ),
                child: Text('login_forgot_password'.tr()),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _handleLogin,
              child: Text('login_button'.tr()),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: Image.asset(
                'assets/google_logo.png',
                height: 24,
                width: 24,
              ),
              label: Text('login_google'.tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                side: const BorderSide(color: Colors.grey),
                minimumSize: const Size(double.infinity, 50),
                textStyle: const TextStyle(fontSize: 16),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: _handleGoogleLogin,
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SignUpPage()),
              ),
              child: Text('login_signup_prompt'.tr()),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      final user = await authService.signIn(email, password);
      await user?.reload();
      final refreshedUser = FirebaseAuth.instance.currentUser;

      if (refreshedUser == null) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'invalid_credentials'.tr(),
        );
      }

      final isEmailPasswordUser = refreshedUser.providerData.any(
            (info) => info.providerId == 'password',
      );
      final skipVerification = isTestDomain(refreshedUser.email ?? '');
      final isVerified =
          skipVerification || !isEmailPasswordUser || refreshedUser.emailVerified;

      if (!isVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('error_verify_email'.tr())),
        );
        return;
      }

      final isAllowed = await authService.checkUserAccess(refreshedUser, context);
      if (isAllowed && mounted) {
        // 🔹 Leer idioma de Firestore
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(refreshedUser.uid)
            .get();
        final code = (doc.data()?['preferredLocale'] as String?)?.trim();
        if (code != null && code.isNotEmpty) {
          await context.setLocale(Locale(code));
          debugPrint("🌍 Idioma aplicado tras login: $code");
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'login_error'.tr(
                namedArgs: {'error': e.message ?? 'unknown_error'.tr()},
              ),
            ),
          ),
        );
      }
    } catch (e) {
      _showError(e.toString());
    }
  }


  Future<void> _handleGoogleLogin() async {
    try {
      final user = await authService.signInWithGoogle();
      if (user == null) {
        _showError('Google sign-in cancelled');
        return;
      }

      final isAllowed = await authService.checkGoogleUserAccess(user, context);
      if (isAllowed && mounted) {
        // 🔹 Leer idioma de Firestore
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        final code = (doc.data()?['preferredLocale'] as String?)?.trim();
        if (code != null && code.isNotEmpty) {
          await context.setLocale(Locale(code));
          debugPrint("🌍 Idioma aplicado tras login con Google: $code");
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? 'Error desconocido');
    } catch (e) {
      _showError(e.toString());
    }
  }


  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('login_error'.tr(namedArgs: {'error': message}))),
    );
  }
}
