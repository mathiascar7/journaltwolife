import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'widgets/app_drawer.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('stats_title'.tr()),
        elevation: 0,
      ),
      drawer: const AppDrawer(),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('entries')
            .where('userId', isEqualTo: uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.bar_chart_rounded, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text('no_entries_yet'.tr(),
                      style: const TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            );
          }

          final docs = snapshot.data!.docs;
          int posCount = 0;
          int negCount = 0;
          Map<String, int> categories = {};

          // Procesamiento de datos de Firebase
          for (var doc in docs) {
            final data = doc.data() as Map<String, dynamic>;
            final analysis = data['analysis'] as Map<String, dynamic>?;
            if (analysis != null) {
              // Extraer listas de detección
              final pos = List.from(analysis['detecciones_positive'] ?? []);
              final neg = List.from(analysis['detecciones_negativas'] ?? []);

              posCount += pos.length;
              negCount += neg.length;

              // Contabilizar cada categoría encontrada
              for (var item in [...pos, ...neg]) {
                // 'categoria' viene en español desde la IA para coincidir con tus llaves
                String cat = item['categoria'] ?? 'Otros';
                categories[cat] = (categories[cat] ?? 0) + 1;
              }
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tarjetas de Resumen (Positivos vs Alertas)
                _buildSummaryCards(posCount, negCount),
                const SizedBox(height: 30),

                // Título de la sección de distribución
                Text(
                  'categories_distribution'.tr(),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),

                // Lista de barras de progreso por categoría
                ...categories.entries.map((e) =>
                    _buildCategoryProgress(context, e.key, e.value, docs.length)).toList(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCards(int pos, int neg) {
    return Row(
      children: [
        _statCard('positive_label'.tr(), pos.toString(), Colors.green, Icons.sentiment_very_satisfied),
        const SizedBox(width: 15),
        _statCard('negative_label'.tr(), neg.toString(), Colors.red, Icons.sentiment_very_dissatisfied),
      ],
    );
  }

  Widget _statCard(String title, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 10),
            Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
            Text(title, style: TextStyle(color: color.withOpacity(0.8), fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryProgress(BuildContext context, String category, int count, int totalDocs) {
    // Cálculo de porcentaje basado en el total de diarios
    double percentage = totalDocs > 0 ? count / totalDocs : 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // AQUÍ SE TRADUCE: 'category' es la llave en español (ej: "Ansiedad")
              // .tr() la convierte en "Anxiety" según tus JSON
              Text(category.tr(), style: const TextStyle(fontWeight: FontWeight.w600)),
              Text('$count', style: const TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percentage > 1 ? 1 : percentage,
              minHeight: 10,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}