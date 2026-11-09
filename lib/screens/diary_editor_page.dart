import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../services/gemini_service.dart';

class DiaryEditorPage extends StatefulWidget {
  final String? existingEntryId;
  final String? existingText;

  const DiaryEditorPage({super.key, this.existingEntryId, this.existingText});

  @override
  State<DiaryEditorPage> createState() => _DiaryEditorPageState();
}

class _DiaryEditorPageState extends State<DiaryEditorPage> {
  final TextEditingController _controller = TextEditingController();
  final GeminiService _geminiService = GeminiService();
  bool _isAnalyzing = false;
  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingText != null) _controller.text = widget.existingText!;
    _speech = stt.SpeechToText();
  }

  Future<void> _saveAndAnalyze() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() => _isAnalyzing = true);

    try {
      final analysis = await _geminiService.analyzeText(text, context.locale.languageCode);

      final uid = FirebaseAuth.instance.currentUser?.uid;
      final docRef = widget.existingEntryId != null
          ? FirebaseFirestore.instance.collection('entries').doc(widget.existingEntryId)
          : FirebaseFirestore.instance.collection('entries').doc();

      await docRef.set({
        'userId': uid,
        'content': text,
        'timestamp': FieldValue.serverTimestamp(),
        'analysis': analysis,
      }, SetOptions(merge: true));

      if (mounted) _showAnalysisResult(analysis);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isAnalyzing = false);
    }
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          localeId: context.locale.toString(),
          onResult: (result) {
            if (result.finalResult) {
              setState(() {
                _controller.text = "${_controller.text} ${result.recognizedWords}".trim();
                _isListening = false;
              });
            }
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _showAnalysisResult(Map<String, dynamic> analysis) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        final pos = List.from(analysis['detecciones_positive'] ?? []);
        final neg = List.from(analysis['detecciones_negativas'] ?? []);

        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.auto_awesome, size: 45, color: Colors.amber),
                const SizedBox(height: 15),
                Text(
                    'analysis_title'.tr(),
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
                ),
                const SizedBox(height: 15),
                Text(
                  analysis['analisis_general'] ?? '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, height: 1.4),
                ),
                const Divider(height: 40),

                if (pos.isNotEmpty)
                  _buildTagSection('detected_wellbeing'.tr(), pos, Colors.green),

                if (neg.isNotEmpty)
                  _buildTagSection('mental_health_alerts'.tr(), neg, Colors.red),

                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                    ),
                    onPressed: () {
                      Navigator.pop(context); // Cierra BottomSheet
                      Navigator.pop(context); // Vuelve al Home
                    },
                    child: Text('finish_button'.tr()),
                  ),
                ),
                const SizedBox(height: 10),
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
        Row(
          children: [
            Icon(Icons.label_important_outline, size: 18, color: color),
            const SizedBox(width: 8),
            Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((i) => Chip(
            label: Text(
              "${i['categoria']}".tr(),
              style: const TextStyle(fontSize: 12),
            ),
            backgroundColor: color.withOpacity(0.1),
            side: BorderSide(color: color.withOpacity(0.2)),
          )).toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingEntryId != null ? 'edit_entry_title'.tr() : 'new_entry_title'.tr()),
        actions: [
          IconButton(
              icon: Icon(_isListening ? Icons.mic : Icons.mic_none, color: _isListening ? Colors.red : null),
              onPressed: _listen
          ),
          TextButton(
              onPressed: _isAnalyzing ? null : _saveAndAnalyze,
              child: Text('save'.tr().toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold))
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              maxLines: null,
              expands: true,
              style: const TextStyle(fontSize: 18, height: 1.5),
              decoration: InputDecoration(
                hintText: 'editor_hint'.tr(),
                border: InputBorder.none,
              ),
            ),
          ),

          if (_isAnalyzing)
            Container(
              color: Colors.white.withOpacity(0.8),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Corregido: sin Wood
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 20),
                    Text(
                      'analyzing_text'.tr(),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'wait_moment'.tr(),
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}