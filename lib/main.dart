import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'firebase_options.dart';

// Pantallas principales
import 'screens/login_page.dart';
import 'screens/sign_up_page.dart';
import 'screens/home_page.dart';
import 'screens/profile_page.dart';
import 'screens/settings_page.dart';
import 'screens/about_page.dart';
import 'screens/statistics_page.dart';
import 'screens/diary_editor_page.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

/// Función para cargar el idioma preferido desde Firestore o Local
Future<Locale> _loadInitialLocale() async {
  String? code;

  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        code = (doc.data()?['preferredLocale'] as String?)?.trim();
      }
    }
  } catch (_) {}

  if (code == null || code.isEmpty) {
    try {
      final prefs = await SharedPreferences.getInstance();
      code = prefs.getString('preferred_language');
    } catch (_) {}
  }

  // Lista de soportados
  const supported = [
    'ar','bn','de','en','es','fr','hi','it','ja','pt','ru','zh'
  ];

  if (code != null && supported.contains(code)) {
    return Locale(code);
  }

  return const Locale('es');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ URLs limpias sin hash
  setUrlStrategy(PathUrlStrategy());

  // Inicialización de Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicialización de localización
  await EasyLocalization.ensureInitialized();

  // 🔹 Remote Config
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(seconds: 10),
    minimumFetchInterval: const Duration(hours: 1),
  ));
  await remoteConfig.fetchAndActivate();
  final remoteVersion = remoteConfig.getString('apkversion');

  // 🔹 Carga el idioma inicial antes de runApp
  final Locale startLocale = await _loadInitialLocale();
  debugPrint("🚀 startLocale aplicado en main(): $startLocale");

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('ar'),
        Locale('bn'),
        Locale('de'),
        Locale('en'),
        Locale('es'),
        Locale('fr'),
        Locale('hi'),
        Locale('it'),
        Locale('ja'),
        Locale('pt'),
        Locale('ru'),
        Locale('zh'),
      ],
      path: 'assets/langs',
      fallbackLocale: const Locale('en'),
      startLocale: startLocale,
      child: MyApp(remoteVersion: remoteVersion),
    ),
  );
}

/// Función global para guardar idioma (usar en SettingsPage)
Future<void> setUserPreferredLocale(Locale locale) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('preferred_language', locale.languageCode);
    debugPrint("💾 Idioma guardado en SharedPreferences: ${locale.languageCode}");
  } catch (_) {}

  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'preferredLocale': locale.languageCode,
      }, SetOptions(merge: true));
      debugPrint("☁️ Idioma guardado en Firestore: ${locale.languageCode}");
    }
  } catch (e) {
    debugPrint('❌ Error guardando idioma en Firestore: $e');
  }
}

class MyApp extends StatelessWidget {
  final String remoteVersion;
  const MyApp({super.key, required this.remoteVersion});

  @override
  Widget build(BuildContext context) {
    debugPrint("🌍 MyApp.build() context.locale = ${context.locale}");
    return MaterialApp(
      title: 'Journal2Life',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // ✅ raíz "/" abre directamente el login con idioma detectado
      home: LoginPage(remoteVersion: remoteVersion),
      routes: {
        // 🌐 Rutas multiidioma (LoginPage)
        '/ar': (context) {
          context.setLocale(const Locale('ar'));
          return LoginPage(remoteVersion: remoteVersion);
        },
        '/bn': (context) {
          context.setLocale(const Locale('bn'));
          return LoginPage(remoteVersion: remoteVersion);
        },
        '/de': (context) {
          context.setLocale(const Locale('de'));
          return LoginPage(remoteVersion: remoteVersion);
        },
        '/en': (context) {
          context.setLocale(const Locale('en'));
          return LoginPage(remoteVersion: remoteVersion);
        },
        '/es': (context) {
          context.setLocale(const Locale('es'));
          return LoginPage(remoteVersion: remoteVersion);
        },
        '/fr': (context) {
          context.setLocale(const Locale('fr'));
          return LoginPage(remoteVersion: remoteVersion);
        },
        '/hi': (context) {
          context.setLocale(const Locale('hi'));
          return LoginPage(remoteVersion: remoteVersion);
        },
        '/it': (context) {
          context.setLocale(const Locale('it'));
          return LoginPage(remoteVersion: remoteVersion);
        },
        '/ja': (context) {
          context.setLocale(const Locale('ja'));
          return LoginPage(remoteVersion: remoteVersion);
        },
        '/pt': (context) {
          context.setLocale(const Locale('pt'));
          return LoginPage(remoteVersion: remoteVersion);
        },
        '/ru': (context) {
          context.setLocale(const Locale('ru'));
          return LoginPage(remoteVersion: remoteVersion);
        },
        '/zh': (context) {
          context.setLocale(const Locale('zh'));
          return LoginPage(remoteVersion: remoteVersion);
        },

        // 🌐 Rutas multiidioma (AboutPage)
        '/ar/about': (context) {
          context.setLocale(const Locale('ar'));
          return const AboutPage();
        },
        '/bn/about': (context) {
          context.setLocale(const Locale('bn'));
          return const AboutPage();
        },
        '/de/about': (context) {
          context.setLocale(const Locale('de'));
          return const AboutPage();
        },
        '/en/about': (context) {
          context.setLocale(const Locale('en'));
          return const AboutPage();
        },
        '/es/about': (context) {
          context.setLocale(const Locale('es'));
          return const AboutPage();
        },
        '/fr/about': (context) {
          context.setLocale(const Locale('fr'));
          return const AboutPage();
        },
        '/hi/about': (context) {
          context.setLocale(const Locale('hi'));
          return const AboutPage();
        },
        '/it/about': (context) {
          context.setLocale(const Locale('it'));
          return const AboutPage();
        },
        '/ja/about': (context) {
          context.setLocale(const Locale('ja'));
          return const AboutPage();
        },
        '/pt/about': (context) {
          context.setLocale(const Locale('pt'));
          return const AboutPage();
        },
        '/ru/about': (context) {
          context.setLocale(const Locale('ru'));
          return const AboutPage();
        },
        '/zh/about': (context) {
          context.setLocale(const Locale('zh'));
          return const AboutPage();
        },

        // 🔹 Rutas normales (sin idioma explícito)
        '/signup': (context) => const SignUpPage(),
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
        '/settings': (context) => const SettingsPage(),
        '/about': (context) => const AboutPage(),
        '/statistics': (context) => const StatisticsPage(),
        '/editor': (context) => const DiaryEditorPage(),
      },
    );
  }
}

