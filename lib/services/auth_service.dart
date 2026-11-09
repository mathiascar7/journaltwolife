import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream para escuchar cambios en el estado de autenticación
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  bool isTestDomain(String email) {
    final testDomains = ['u1.com', 'u2.com', 'u3.com'];
    final domain = email.split('@').last.toLowerCase();
    return testDomains.contains(domain);
  }

  // Registro con email y password
  Future<User?> signUp(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user;

      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': 'Usuario',
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
          'approved': true, // 🔹 campo para validación posterior
          'role': 'student',
        }, SetOptions(merge: true));
      }
      return user;
    } catch (e) {
      print('Error en signUp: $e');
      return null;
    }
  }

  // Login con email y password
  Future<User?> signIn(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print('Error en signIn: $e');
      return null;
    }
  }

  // Login con Google
  Future<User?> signInWithGoogle() async {
    try {
      UserCredential userCredential;

      if (kIsWeb) {
        final provider = GoogleAuthProvider();
        userCredential = await _auth.signInWithPopup(provider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) return null;

        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        userCredential = await _auth.signInWithCredential(credential);
      }

      final user = userCredential.user;
      if (user != null) {
        final docRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
        final doc = await docRef.get();

        if (!doc.exists) {
          await docRef.set({
            'name': user.displayName ?? 'Usuario de Google',
            'email': user.email,
            'photoUrl': user.photoURL,
            'createdAt': FieldValue.serverTimestamp(),
            'approved': true, // 🔹 campo para validación posterior
            'role': 'User',
          }, SetOptions(merge: true));
        }
      }
      return user;
    } catch (e) {
      print('Error en signInWithGoogle: $e');
      return null;
    }
  }

  // Logout
  Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut();
      await _auth.signOut();
    } catch (e) {
      print('Error al cerrar sesión: $e');
    }
  }

  // 🔹 Validación para usuarios con email/password
  Future<bool> checkUserAccess(User user, BuildContext context) async {
    try {
      final isEmailPasswordUser =
      user.providerData.any((info) => info.providerId == 'password');
      final skipVerification = isTestDomain(user.email ?? '');
      final isVerified =
          skipVerification || !isEmailPasswordUser || user.emailVerified;

      if (!isVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('error_verify_email'.tr())),
        );
        return false;
      }

      final doc =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final data = doc.data();

      if (data == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('error_user_not_registered'.tr())),
        );
        return false;
      }

      final isApproved = data['approved'] == true;
      if (!isApproved) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('error_user_not_approved'.tr())),
        );
        return false;
      }

      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('error_generic'.tr(namedArgs: {'error': e.toString()})),
        ),
      );
      return false;
    }
  }

  // 🔹 Validación para usuarios con Google
  Future<bool> checkGoogleUserAccess(User user, BuildContext context) async {
    try {
      final doc =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final data = doc.data();

      if (data == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('login_error'.tr(namedArgs: {
              'error': 'User not registered. Please create an account first.'
            })),
          ),
        );
        return false;
      }

      final isApproved = data['approved'] == true;
      if (!isApproved) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('login_error'.tr(namedArgs: {
              'error': 'Your account has not yet been approved by the administrator.'
            })),
          ),
        );
        return false;
      }

      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('login_error'.tr(namedArgs: {'error': e.toString()})),
        ),
      );
      return false;
    }
  }
}
