import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';

import 'profile_page.dart';
import 'widgets/app_drawer.dart';
import 'diary_editor_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showProfileButton = false;
  bool isLoading = true;
  String? _userName;

  @override
  void initState() {
    super.initState();
    checkUserStatus();
  }

  Future<void> checkUserStatus() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = doc.data();
      final name = data?['name']?.toString().trim();

      setState(() {
        _userName = name;
        showProfileButton = (name == null || name.isEmpty);
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void _confirmDelete(String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('delete_confirm_title'.tr()),
        content: Text('delete_confirm_msg'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr()),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance.collection('entries').doc(docId).delete();
              if (mounted) Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('entry_deleted_msg'.tr())),
              );
            },
            child: Text('delete'.tr(), style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _editEntry(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiaryEditorPage(
          existingEntryId: doc.id,
          existingText: data['content'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('app_name'.tr()),
        actions: [
          if (showProfileButton)
            IconButton(
              icon: const Icon(Icons.account_circle, color: Colors.orange),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              ),
            ),
        ],
      ),
      drawer: const AppDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DiaryEditorPage()),
        ),
        label: Text('new_entry'.tr()),
        icon: const Icon(Icons.edit),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildEntriesList(user?.uid)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Text(
            '${'home_welcome'.tr()}, ${_userName ?? 'user'.tr()}',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'home_description'.tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _buildEntriesList(String? uid) {
    if (uid == null) return const SizedBox();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('entries')
          .where('userId', isEqualTo: uid)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final docs = snapshot.data!.docs;
        if (docs.isEmpty) return Center(child: Text('no_entries_yet'.tr()));

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final doc = docs[index];
            final data = doc.data() as Map<String, dynamic>;
            final analysis = data['analysis'] as Map<String, dynamic>?;
            final date = (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();

            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(
                  DateFormat.yMMMMEEEEd(context.locale.languageCode).format(date),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(data['content'] ?? '', maxLines: 2, overflow: TextOverflow.ellipsis),
                    if (analysis != null) ...[
                      const SizedBox(height: 12),
                      _buildMiniSummary(analysis),
                    ]
                  ],
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (val) => val == 'edit' ? _editEntry(doc) : _confirmDelete(doc.id),
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 'edit', child: Text('edit'.tr())),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text('delete'.tr(), style: const TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
                onTap: () => analysis != null ? _showAnalysisDetail(context, analysis) : null,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMiniSummary(Map<String, dynamic> analysis) {
    final pos = List.from(analysis['detecciones_positive'] ?? []);
    final neg = List.from(analysis['detecciones_negativas'] ?? []);
    return Wrap(
      spacing: 8,
      children: [
        if (neg.isNotEmpty) const Icon(Icons.sentiment_dissatisfied, color: Colors.red, size: 20),
        if (pos.isNotEmpty) const Icon(Icons.sentiment_satisfied, color: Colors.green, size: 20),
        if (analysis['alertas_criticas'] == true) const Icon(Icons.warning, color: Colors.orange, size: 20),
      ],
    );
  }

  void _showAnalysisDetail(BuildContext context, Map<String, dynamic> analysis) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) {
        final pos = List.from(analysis['detecciones_positive'] ?? []);
        final neg = List.from(analysis['detecciones_negativas'] ?? []);
        return Container(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.auto_awesome, size: 40, color: Colors.amber),
                const SizedBox(height: 10),
                Text('analysis_title'.tr(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                Text(analysis['analisis_general'] ?? '', textAlign: TextAlign.center, style: const TextStyle(fontSize: 15, height: 1.4)),
                const Divider(height: 30),
                // USANDO CLAVES TRADUCIDAS
                if (pos.isNotEmpty) _buildTagSection('detected_wellbeing'.tr(), pos, Colors.green),
                if (neg.isNotEmpty) _buildTagSection('mental_health_alerts'.tr(), neg, Colors.red),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("close".tr())
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTagSection(String title, List items, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((i) {
            final score = i['fuerza'] ?? i['nivel_riesgo'] ?? 0;
            return Chip(
              avatar: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text("$score", style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold))
              ),
              // TRADUCCIÓN DE LA LLAVE EN INGLÉS (ej: anxiety -> Ansiedad)
              label: Text("${i['categoria']}".tr(), style: const TextStyle(fontSize: 12)),
              backgroundColor: color.withOpacity(0.1),
              side: BorderSide(color: color.withOpacity(0.2)),
            );
          }).toList(),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}