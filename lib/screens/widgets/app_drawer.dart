import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Text(
              'menu'.tr(), // [cite: 96]
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: Text('home'.tr()), // [cite: 97]
            onTap: () => Navigator.pushReplacementNamed(context, '/home'),
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: Text('profile'.tr()), // [cite: 98]
            onTap: () => Navigator.pushReplacementNamed(context, '/profile'),
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: Text('stats_title'.tr()), // [cite: 98]
            onTap: () => Navigator.pushReplacementNamed(context, '/statistics'),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text('settings'.tr()),
            onTap: () => Navigator.pushReplacementNamed(context, '/settings'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: Text('log_out'.tr()), // [cite: 99]
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
}