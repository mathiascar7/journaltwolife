import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('about_title'.tr())),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Descripción general
            Text(
              'about_description'.tr(),
              style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            const Divider(),

            // 🔹 Perfil
            _buildSection(
              context,
              title: 'about_profile_title'.tr(),
              items: [
                'about_profile_item1'.tr(),
                'about_profile_item2'.tr(),
                'about_profile_item3'.tr(),
              ],
            ),
            const Divider(),

            // 🔹 Multiplataforma
            _buildSection(
              context,
              title: 'about_crossplatform_title'.tr(),
              items: [
                'about_crossplatform_item1'.tr(),
                'about_crossplatform_item2'.tr(),
              ],
            ),
            const Divider(),

            // 🔹 Idiomas
            _buildSection(
              context,
              title: 'about_multilang_title'.tr(),
              items: [
                'about_multilang_item1'.tr(),
                'about_multilang_item2'.tr(),
                'about_multilang_item3'.tr(),
                'about_multilang_item4'.tr(),
                'about_multilang_item5'.tr(),
                'about_multilang_item6'.tr(),
                'about_multilang_item7'.tr(),
                'about_multilang_item8'.tr(),
                'about_multilang_item9'.tr(),
                'about_multilang_item10'.tr(),
                'about_multilang_item11'.tr(),
                'about_multilang_item12'.tr(),
              ],
            ),
            const Divider(),

            // 🔹 Categorías emocionales divididas en dos columnas
            Text('about_categories_title'.tr(), style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
            )),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Positivas
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildCategoryItems([
                      'Deporte/Arte',
                      'Amor propio',
                      'Mindfulness',
                      'Motivación',
                      'Amistades saludables',
                      'Superación',
                      'Diversión',
                      'Gratitud',
                      'Altruismo',
                      'Éxitos académicos/personales',
                      'Crecimiento espiritual',
                      'Optimismo',
                      'Resolución de conflictos',
                    ]),
                  ),
                ),
                const SizedBox(width: 16),
                // Negativas
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildCategoryItems([
                      'Estrés crónico',
                      'Dificultades relacionales',
                      'Ansiedad',
                      'Bullying',
                      'Depresión',
                      'Trastornos de imagen corporal',
                      'Cyberbullying',
                      'Problemas académicos',
                      'Adicciones',
                      'Eventos traumáticos/violentos',
                      'Desconfianza/Paranoia',
                      'Maltrato',
                      'Acoso sexual',
                    ]),
                  ),
                ),
              ],
            ),
            const Divider(),

            // 🔹 Actividades
            _buildSection(
              context,
              title: 'about_activities_title'.tr(),
              items: [
                'about_activities_item1'.tr(),
                'about_activities_item2'.tr(),
                'about_activities_item3'.tr(),
              ],
            ),
            const Divider(),

            // 🔹 Inteligencia Artificial
            _buildSection(
              context,
              title: 'about_ai_title'.tr(),
              items: [
                'about_ai_item1'.tr(),
                'about_ai_item2'.tr(),
                'about_ai_item3'.tr(),
                'about_ai_item4'.tr(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context,
      {required String title, required List<String> items}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Column(
            children: items
                .map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_outline,
                      size: 18, color: Colors.blue),
                  const SizedBox(width: 6),
                  Expanded(child: Text(item)),
                ],
              ),
            ))
                .toList(),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCategoryItems(List<String> items) {
    return items
        .map((item) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline,
              size: 18, color: Colors.blue),
          const SizedBox(width: 6),
          Expanded(child: Text(item.tr())),
        ],
      ),
    ))
        .toList();
  }
}
